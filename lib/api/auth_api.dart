import 'package:flutter_mahasiswa_api/helper/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApi {
  // Login mahasiswa, return token jika sukses
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Asumsi response: {"token": "..."}
      return data['data']['token'] as String;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  static Future<void> logout() async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('http://localhost:9090/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token.toString(),
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Logout gagal: ${response.body}');
    }
  }
}
