import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/auth_api.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF667eea), // Modern blue-purple gradient start
          onPrimary: Colors.white,
          secondary: Color(0xFF764ba2), // Modern blue-purple gradient end
          onSecondary: Colors.white,
          error: Color(0xFFe74c3c),
          onError: Colors.white,
          background: Color(0xFFf8fafc), // Light gray background
          onBackground: Color(0xFF1a202c),
          surface: Colors.white,
          onSurface: Color(0xFF1a202c),
        ),
        scaffoldBackgroundColor: Color(0xFFf8fafc),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF667eea),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1a202c)),
          bodyMedium: TextStyle(color: Color(0xFF1a202c)),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a202c),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF667eea)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF667eea),
          foregroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                ),
              ),
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
  JadwalMendatang? _jadwalMendatang;

  @override
  void initState() {
    super.initState();
    _loadJadwalMendatang();
  }

  Future<void> _loadJadwalMendatang() async {
    try {
      final jadwal = await JadwalApi.fetchJadwalMendatang();
      setState(() {
        _jadwalMendatang = jadwal;
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

  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Color(0xFF667eea)),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        await AuthApi.logout(); // panggil logout ke server
      } catch (e) {
        debugPrint('Logout gagal ke server: $e');
      }

      await AuthService.clearToken();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Mahasiswa'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea).withOpacity(0.1), Color(0xFFf8fafc)],
          ),
        ),
        child: Column(
          children: [
            NotifJadwalMendatang(jadwal: _jadwalMendatang),
            Expanded(
              child: TabMenu(onMenuTap: (key) => _navigate(context, key)),
            ),
          ],
        ),
      ),
    );
  }
}

// Ubah NotifJadwalMendatang agar selalu tampil dan tidak bisa ditutup
class NotifJadwalMendatang extends StatelessWidget {
  final JadwalMendatang? jadwal;
  const NotifJadwalMendatang({super.key, required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: (jadwal != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notification_important,
                      color: Color(0xFFe67e22),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Jadwal Mendatang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFe67e22),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Matakuliah: ${jadwal!.course}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text('Dosen: ${jadwal!.lecturer}'),
                Text('Ruangan: ${jadwal!.classroom}'),
                Text('Status: ${jadwal!.lecturerStatus}'),
              ],
            )
          : Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF27ae60), size: 24),
                SizedBox(width: 12),
                Text(
                  'Tidak ada jadwal hari ini',
                  style: TextStyle(
                    color: Color(0xFF27ae60),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}
