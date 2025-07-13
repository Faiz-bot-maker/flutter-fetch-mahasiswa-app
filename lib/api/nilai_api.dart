import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/students_model.dart';

class NilaiApi {
  // Get data nilai
  static Future<List<Nilai>> fetchNilai() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/api/v1/students/grades'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Nilai.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data nilai');
    }
  }
}
