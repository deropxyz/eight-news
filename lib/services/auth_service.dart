// lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _token;
  final String _baseUrl = 'http://45.149.187.204:3000';
  final String _loginPath = '/api/auth/login';

  bool get isAuth => _token != null;
  String? get token => _token;

  /// Melakukan login dan menyimpan token jika berhasil
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl$_loginPath');
    print('🔐 Mencoba login ke: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('📩 Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['body']['data']['token'];

        if (token != null && token.isNotEmpty) {
          _token = token;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          notifyListeners();
        } else {
          throw Exception('Token tidak ditemukan pada respons server.');
        }
      } else {
        throw Exception('Login gagal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception(
        'Terjadi kesalahan saat login. Cek koneksi atau kredensial.',
      );
    }
  }

  /// Cek dan ambil token saat aplikasi dibuka ulang
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('authToken');

    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      notifyListeners();
      print('✅ Auto-login berhasil dengan token tersimpan.');
    } else {
      print('⚠️ Tidak ada token tersimpan.');
    }
  }

  /// Logout dan hapus token
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    notifyListeners();
    print('🚪 Logout sukses, token dihapus.');
  }

  /// Mengambil profil user untuk mendapatkan email
  Future<String?> getUserEmail() async {
    if (token == null || token!.isEmpty) return null;

    final response = await http.get(
      Uri.parse('http://45.149.187.204:3000/api/auth/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['body']['data']['email'];
    } else {
      throw Exception('Gagal mengambil profil user');
    }
  }
}
