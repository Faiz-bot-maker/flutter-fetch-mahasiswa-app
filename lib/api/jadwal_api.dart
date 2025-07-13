import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/students_model.dart';

class JadwalApi {
  // Get data jadwal
  static Future<List<Jadwal>> fetchJadwal() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/api/v1/students/schedules'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Jadwal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal');
    }
  }
}
