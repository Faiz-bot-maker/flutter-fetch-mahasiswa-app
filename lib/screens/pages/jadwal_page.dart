import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/jadwal_api.dart';
import '../../models/students_model.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Color(0xFF667eea),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Jadwal>>(
        future: JadwalApi.fetchJadwal(),
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
                  Icon(Icons.schedule, size: 64, color: Colors.blue[100]),
                  const SizedBox(height: 16),
                  Text('Tidak ada data jadwal', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }
          final jadwalList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: jadwalList.length,
            itemBuilder: (context, index) {
              final item = jadwalList[index];
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF38B6FF).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.schedule, color: Color(0xFF38B6FF), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.course,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF222B45)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildBadge('${item.startAt} - ${item.endAt}', const Color(0xFF60A5FA), icon: Icons.access_time),
                                const SizedBox(width: 8),
                                _buildBadge('Kelas: ${item.classroom}', const Color(0xFF64748B)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildBadge('Dosen: ${item.lecturer}', const Color(0xFF38B6FF)),
                                const SizedBox(width: 8),
                                _buildBadge('Tanggal: ${item.date}', const Color(0xFF60A5FA)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget _buildBadge(String text, Color color, {IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: color.darken(0.2)),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            color: color.darken(0.2),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
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
