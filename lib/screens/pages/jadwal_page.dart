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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double cardPadding = width < 400 ? 10 : width < 600 ? 16 : 20;
          double cardMargin = width < 400 ? 8 : 18;
          double iconSize = width < 400 ? 22 : 28;
          double fontSizeTitle = width < 400 ? 14 : 17;
          double badgeFontSize = width < 400 ? 10 : 12;
          double badgePaddingH = width < 400 ? 6 : 10;
          double badgePaddingV = width < 400 ? 2 : 4;
          return FutureBuilder<List<Jadwal>>(
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
                      Text('Error:   {snapshot.error}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
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
                padding: EdgeInsets.all(cardPadding),
                itemCount: jadwalList.length,
                itemBuilder: (context, index) {
                  final item = jadwalList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: cardMargin),
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
                      padding: EdgeInsets.symmetric(horizontal: cardPadding, vertical: cardPadding * 0.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF38B6FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(width < 400 ? 7 : 10),
                            child: Icon(Icons.schedule, color: Color(0xFF38B6FF), size: iconSize),
                          ),
                          SizedBox(width: width < 400 ? 7 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.course,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeTitle, color: Color(0xFF222B45)),
                                ),
                                SizedBox(height: width < 400 ? 4 : 8),
                                Wrap(
                                  spacing: width < 400 ? 4 : 8,
                                  runSpacing: 4,
                                  children: [
                                    _buildBadge('${item.startAt} - ${item.endAt}', const Color(0xFF60A5FA), icon: Icons.access_time, fontSize: badgeFontSize, paddingH: badgePaddingH, paddingV: badgePaddingV, iconSize: badgeFontSize+2),
                                    _buildBadge('Kelas: ${item.classroom}', const Color(0xFF64748B), fontSize: badgeFontSize, paddingH: badgePaddingH, paddingV: badgePaddingV),
                                  ],
                                ),
                                SizedBox(height: width < 400 ? 2 : 4),
                                Wrap(
                                  spacing: width < 400 ? 4 : 8,
                                  runSpacing: 4,
                                  children: [
                                    _buildBadge('Dosen: ${item.lecturer}', const Color(0xFF38B6FF), fontSize: badgeFontSize, paddingH: badgePaddingH, paddingV: badgePaddingV),
                                    _buildBadge('Tanggal: ${item.date}', const Color(0xFF60A5FA), fontSize: badgeFontSize, paddingH: badgePaddingH, paddingV: badgePaddingV),
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
          );
        },
      ),
    );
  }
}

Widget _buildBadge(String text, Color color, {IconData? icon, double fontSize = 12, double paddingH = 10, double paddingV = 4, double iconSize = 14}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
    decoration: BoxDecoration(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize, color: color.darken(0.2)),
          SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            color: color.darken(0.2),
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
