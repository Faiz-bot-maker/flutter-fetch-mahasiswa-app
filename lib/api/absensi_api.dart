import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/students_model.dart';

class AbsensiApi {
  // Get data absensi per
  static Future<List<Absensi>> fetchAbsensi() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/api/v1/students/attendances'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body); // decode JSON
      return data.map((e) => Absensi.fromJson(e)).toList(); // parsing ke model
    } else {
      throw Exception('Gagal memuat data absensi'); // error handling
    }
  }
}
