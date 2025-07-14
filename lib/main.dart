import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/jadwal_api.dart';
import 'package:flutter_mahasiswa_api/helper/auth_service.dart';
import 'package:flutter_mahasiswa_api/models/students_model.dart';
import 'widget/tab_menu.dart';
import 'screens/pages/absensi_page.dart';
import 'screens/pages/jadwal_page.dart';
import 'screens/pages/matakuliah_page.dart';
import 'screens/pages/nilai_page.dart';
import 'screens/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => const HomePage(),
        '/absensi': (_) => const AbsensiPage(),
        '/jadwal': (_) => const JadwalPage(),
        '/matakuliah': (_) => const MatakuliahPage(),
        '/nilai': (_) => const NilaiPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showNotification = true;
  JadwalMendatang? _jadwalMendatang; // ✅ Tambah state untuk menyimpan jadwal

  @override
  void initState() {
    super.initState();
    _loadJadwalMendatang(); // ✅ Panggil load jadwal saat halaman dimuat
  }

  Future<void> _loadJadwalMendatang() async {
    try {
      final jadwal = await JadwalApi.fetchJadwalMendatang();
      setState(() {
        _jadwalMendatang = jadwal;
        _showNotification = true;
      });
    } catch (e) {
      debugPrint('Gagal memuat jadwal mendatang: $e');
    }
  }

  void _navigate(BuildContext context, String key) {
    switch (key) {
      case 'absensi':
        Navigator.pushNamed(context, '/absensi');
        break;
      case 'jadwal':
        Navigator.pushNamed(context, '/jadwal');
        break;
      case 'matakuliah':
        Navigator.pushNamed(context, '/matakuliah');
        break;
      case 'nilai':
        Navigator.pushNamed(context, '/nilai');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Mahasiswa')),
      body: Column(
        children: [
          // ✅ Update agar hanya muncul jika data tersedia
          if (_showNotification && _jadwalMendatang != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PERINGATAN: Ada jadwal 30 menit lagi:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Matakuliah: ${_jadwalMendatang!.course}'),
                        Text('Dosen: ${_jadwalMendatang!.lecturer}'),
                        Text('Ruangan: ${_jadwalMendatang!.classroom}'),
                        Text(
                          'Status Dosen: ${_jadwalMendatang!.lecturerStatus}',
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showNotification = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(child: TabMenu(onMenuTap: (key) => _navigate(context, key))),
        ],
      ),
    );
  }
}
