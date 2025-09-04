import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'settings_service.dart';

class SettingsProvider with ChangeNotifier {
  String _baseUrl = '';
  String _authToken = '';
  late Dio _apiDio = Dio();
  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'wortschatzchen_quiz/1.0',
    'Authorization': '',
  };

  // Map<String, String> defaultHeaders = {};
  //'Authorization':' Bearer'}

  final SettingsService _settingsService = SettingsService();

  String get baseUrl => _baseUrl;
  String get authToken => _authToken;
  Dio get apiDio => _apiDio;
  final AppDataProvider _appDataProvider;
  Map<String, String> get defaultHeaders => _defaultHeaders;

  SettingsProvider(this._appDataProvider) {
    _loadSettings();
  }

  void _loadSettings() async {
    _baseUrl = await _settingsService.getBaseUrl();
    _authToken = await _settingsService.getAuthToken();
    _apiDio = await getDio(_baseUrl, _authToken);
    String userToken = 'Bearer$_authToken';
    _defaultHeaders['Authorization'] = userToken;
    _defaultHeaders.putIfAbsent('Authorization', () => userToken);

    notifyListeners();
  }

  Future<Dio> getDio(String baseUrl, authToken) async {
    final dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    dio.interceptors.add(
      TalkerDioLogger(
        talker: this._appDataProvider.talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
          printResponseData: false,
        ),
      ),
    );
    dio.options.baseUrl = baseUrl;

    return dio;
  }

  void loadSettings() {
    _loadSettings();
  }

  void updateSettings(String baseUrl, String authToken) async {
    _baseUrl = baseUrl;
    _authToken = authToken;
    await _settingsService.setBaseUrl(baseUrl);
    await _settingsService.setAuthToken(authToken);
    _loadSettings();
    // _apiDio = getDio(_baseUrl, _authToken);
    // // defaultHeaders['Authorization'] = 'Bearer $_authToken';
    // defaultHeaders.putIfAbsent('Authorization', () => 'Bearer $_authToken');
    // notifyListeners();
  }

  // void toggleTheme(bool value) async {
  //   _isDarkMode = value;
  //   await _settingsService.setIsDarkMode(value);
  //   notifyListeners();
  // }
}
