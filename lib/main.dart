import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/helper/auth_service.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: TabMenu(onMenuTap: (key) => _navigate(context, key)),
    );
  }
}
