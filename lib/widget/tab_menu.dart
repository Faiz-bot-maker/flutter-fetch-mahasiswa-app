import 'package:flutter/material.dart';

class TabMenu extends StatelessWidget {
  final void Function(String) onMenuTap;
  const TabMenu({Key? key, required this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {
        'title': 'Absensi',
        'key': 'absensi',
        'icon': Icons.fact_check,
      },
      {
        'title': 'Jadwal',
        'key': 'jadwal',
        'icon': Icons.schedule,
      },
      {
        'title': 'Matakuliah',
        'key': 'matakuliah',
        'icon': Icons.menu_book,
      },
      {
        'title': 'Nilai',
        'key': 'nilai',
        'icon': Icons.grade,
      },
    ];
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final cardHeight = width < 500 ? 110.0 : 130.0;
    final iconSize = width < 500 ? 34.0 : 42.0;
    final fontSize = width < 500 ? 15.0 : 18.0;
    return Container(
      color: const Color(0xFFF5F7FA),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(24),
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: menus.map((menu) {
          return InkWell(
            onTap: () => onMenuTap(menu['key']!),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(menu['icon'], size: iconSize, color: const Color(0xFF223A5E)),
                  const SizedBox(height: 10),
                  Text(
                    menu['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: const Color(0xFF223A5E),
                      letterSpacing: 0.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 3,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BA4FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 