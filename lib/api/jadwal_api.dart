import 'package:flutter_mahasiswa_api/helper/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/students_model.dart';

class JadwalApi {
  // Get data jadwal
  static Future<List<Jadwal>> fetchJadwal() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:9090/api/v1/student/schedules'),
      headers: {'Authorization': token.toString()},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Akses array matakuliah dari properti 'data'
      final List<dynamic> data = jsonResponse['data'];

      return data.map((e) => Jadwal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal');
    }
  }

  static Future<JadwalMendatang> fetchJadwalMendatang() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:9090/api/v1/student/schedules/coming'),
      headers: {'Authorization': token.toString()},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Akses array matakuliah dari properti 'data'
      return JadwalMendatang.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Gagal memuat data jadwal');
    }
  }
}
