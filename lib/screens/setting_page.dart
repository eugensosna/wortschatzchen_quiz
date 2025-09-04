import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/providers/settings_provider.dart';
import 'package:wortschatzchen_quiz/utils/constants.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Talker? talker;
  bool _isLoading = false;
  bool _isTestingConnection = false;
  bool _connectionSuccessful = false;
  String? _errorMessage;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await Provider.of<AppDataProvider>(context, listen: false).sharedPrefs;
    talker = Provider.of<AppDataProvider>(context, listen: false).talker;

    // final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baseUrlController.text = prefs.getString(baseUrlSettingsName) ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(baseUrlSettingsName, _baseUrlController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  // Test connection without authentication
  Future<void> _testConnection() async {
    if (_baseUrlController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a base URL to test';
        _connectionSuccessful = false;
      });
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _errorMessage = null;
      _connectionSuccessful = false;
    });

    var dio = getDio();
    dio.options.baseUrl = _baseUrlController.text;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    try {
      // Try a simple GET request to test connectivity
      // You can change this endpoint to match your API's health check or any public endpoint
      String url = '/authenticate';
      var dataToSend = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      final response = await dio.post(
        url,
        data: dataToSend,
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Server responded with status code: ${response.statusCode}  data:${response.data}');
      }

      setState(() {
        _connectionSuccessful = true;
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection successful!'),
          backgroundColor: Colors.green,
        ),
      );

      talker?.info('Connection test successful');
    } catch (e) {
      String errorMsg;
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            errorMsg = 'Connection timeout - please check your URL';
            break;
          case DioExceptionType.connectionError:
            errorMsg = 'Cannot connect to server - please check your URL and internet connection';
            break;
          case DioExceptionType.badResponse:
            errorMsg = 'Server responded with error: ${e.response?.statusCode}';
            break;
          default:
            errorMsg = 'Connection failed: ${e.message}';
        }
      } else {
        errorMsg = 'Connection failed: ${e.toString()}';
      }

      setState(() {
        _connectionSuccessful = false;
        _errorMessage = errorMsg;
      });

      talker?.error('Connection test failed', e);
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _baseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Base URL',
                        hintText: 'http://localhost:8080',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a base URL';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Reset connection status when URL changes
                        setState(() {
                          _connectionSuccessful = false;
                          _errorMessage = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isTestingConnection ? null : _testConnection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _connectionSuccessful
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: _isTestingConnection
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _connectionSuccessful ? Icons.check_circle : Icons.wifi_find,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text('Test'),
                            ],
                          ),
                  ),
                ],
              ),

              // Error message display
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Text('Save Settings'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            child: Text('Login'),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: _cancel,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Dio getDio() {
    final dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
          printResponseData: false,
        ),
      ),
    );
    return dio;
  }

  void _login() async {
    var dio = getDio();
    dio.options.baseUrl = _baseUrlController.text;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String url = '/authenticate';

    try {
      final response = await dio.post(
        url,
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        final token = response.data['id_token'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(authTokenSettingsName, token);
        await prefs.setString(baseUrlSettingsName, _baseUrlController.text);

        talker?.info(token);

        var headers = {'Authorization': 'Bearer ' + token};
        talker?.info(headers);

        var words = await dio.get('/words/', options: Options(headers: headers));
        talker?.info("list of Words ${words.data}");

        // var sett = Provider.of<SettingsProvider>(context, listen: false).;
        Provider.of<SettingsProvider>(context, listen: false)
            .updateSettings(_baseUrlController.text, token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Handle successful response
    } catch (e) {
      // Handle error
      String errorMsg;
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            errorMsg = 'Login timeout - please try again';
            break;
          case DioExceptionType.connectionError:
            errorMsg = 'Cannot connect to server - please check your connection';
            break;
          case DioExceptionType.badResponse:
            if (e.response?.statusCode == 401) {
              errorMsg = 'Invalid username or password';
            } else {
              errorMsg = 'Login failed: Server error ${e.response?.statusCode}';
            }
            break;
          default:
            errorMsg = 'Login failed: ${e.message}';
        }
      } else {
        errorMsg = 'Login failed: ${e.toString()}';
      }

      setState(() {
        _errorMessage = errorMsg;
      });

      talker?.error('Login failed', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }
}
