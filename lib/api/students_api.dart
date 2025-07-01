import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/students_model.dart';

class StudentsApi {
  // Get data absensi per matkul
  static Future<List<AbsensiMatkul>> fetchAbsensiMatkul() async {
    final response = await http.get(Uri.parse('api/mahasiswa/absensi'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body); // decode JSON
      return data.map((e) => AbsensiMatkul.fromJson(e)).toList(); // parsing ke model
    } else {
      throw Exception('Gagal memuat data absensi'); // error handling
    }
  }

  // Get data jadwal
  static Future<List<Jadwal>> fetchJadwal() async {
    final response = await http.get(Uri.parse('api/mahasiswa/jadwal'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Jadwal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal');
    }
  }

  // Get daftar matakuliah
  static Future<List<Matakuliah>> fetchMatakuliah() async {
    final response = await http.get(Uri.parse('api/mahasiswa/matakuliah'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Matakuliah.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data matakuliah');
    }
  }

  // Get data nilai
  static Future<List<Nilai>> fetchNilai() async {
    final response = await http.get(Uri.parse('api/mahasiswa/nilai'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Nilai.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data nilai');
    }
  }

  // Login mahasiswa, return token jika sukses
  static Future<String> loginMahasiswa(String username, String password) async {
    final response = await http.post(
      Uri.parse('api/mahasiswa/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Asumsi response: {"token": "..."}
      return data['token'] as String;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }
} 