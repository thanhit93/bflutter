/*
 * Developed by Nhan Cao on 10/24/19 5:19 PM.
 * Last modified 10/8/19 3:49 PM.
 * Copyright (c) 2019 Beesight Soft. All rights reserved.
 */

import 'package:bflutter_poc/global.dart';
import 'package:http/http.dart' as http;

class Api {
  // @nhancv 10/7/2019: Create api instance
  Api._private();

  static final Api _instance = Api._private();

  factory Api() => _instance;

  // @nhancv 10/7/2019: Get base url by env
  final String apiBaseUrl = Global().env.apiBaseUrl;

  /// @nhancv 10/7/2019: Search user request
  Future<http.Response> searchUsers(String query) {
    String url = '$apiBaseUrl/search/users?q=$query';
    print(url);
    return http.get(url);
  }

  /// @nhancv 10/7/2019: Get user info request
  Future<http.Response> getUserInfo(String username) {
    String url = '$apiBaseUrl/users/$username';
    print(url);
    return http.get(url);
  }
}
