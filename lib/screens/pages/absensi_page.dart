import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/absensi_api.dart';
import 'package:flutter_mahasiswa_api/models/students_model.dart';

class AbsensiPage extends StatelessWidget {
  const AbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Color(0xFF667eea),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<MataKuliah>>(
        future: AbsensiApi.fetchAbsensi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF667eea)));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Error:  ${snapshot.error}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.blue[100]),
                  const SizedBox(height: 16),
                  Text('Tidak ada data absensi', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }

          final mataKuliahList = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(mataKuliahList.length, (index) {
                final mataKuliah = mataKuliahList[index];
                final totalHadir = mataKuliah.daftarAbsensi.where((k) => k.status.toLowerCase() == 'hadir').length;

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF38B6FF).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.book, color: Color(0xFF38B6FF), size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                mataKuliah.namaMataKuliah,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF222B45)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildBadge('Total Hadir: $totalHadir', const Color(0xFF4ADE80)),
                            const SizedBox(width: 8),
                            _buildBadge('Pertemuan: ${mataKuliah.daftarAbsensi.length}', const Color(0xFF60A5FA)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Judul Daftar Kehadiran
                        Row(
                          children: [
                            Icon(Icons.history, size: 16, color: const Color(0xFF64748B)),
                            const SizedBox(width: 6),
                            Text(
                              'Daftar Kehadiran',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Daftar Kehadiran
                        if (mataKuliah.daftarAbsensi.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: const Color(0xFF64748B)),
                                const SizedBox(width: 8),
                                Text(
                                  'Belum ada data kehadiran',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...mataKuliah.daftarAbsensi.map((kehadiran) {
                            final hadir = kehadiran.status.toLowerCase() == 'hadir';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: hadir ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: hadir ? const Color(0xFF4ADE80).withOpacity(0.2) : const Color(0xFFF87171).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    hadir ? Icons.check_circle : Icons.cancel,
                                    color: hadir ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _formatDateTime(kehadiran.waktu),
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  _buildSmallBadge(
                                    hadir ? 'Hadir' : 'Tidak Hadir',
                                    hadir ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color.darken(0.2),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// Tambahkan helper function untuk format tanggal
String _formatDateTime(DateTime dateTime) {
  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  
  final dayName = days[dateTime.weekday - 1];
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = months[dateTime.month - 1];
  final year = dateTime.year;
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  
  return '$dayName, $day $month $year, $hour:$minute';
}

// Tambahkan helper function untuk badge kecil
Widget _buildSmallBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color.darken(0.3),
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
    ),
  );
}
