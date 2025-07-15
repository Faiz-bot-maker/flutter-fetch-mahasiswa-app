import 'package:flutter/material.dart';

class TabMenu extends StatelessWidget {
  final void Function(String) onMenuTap;
  const TabMenu({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {
        'title': 'Absensi', 
        'key': 'absensi', 
        'icon': Icons.fact_check,
        'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
        'iconColor': Colors.white
      },
      {
        'title': 'Jadwal', 
        'key': 'jadwal', 
        'icon': Icons.schedule,
        'gradient': [Color(0xFFf093fb), Color(0xFFf5576c)],
        'iconColor': Colors.white
      },
      {
        'title': 'Matakuliah', 
        'key': 'matakuliah', 
        'icon': Icons.menu_book,
        'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
        'iconColor': Colors.white
      },
      {
        'title': 'Nilai', 
        'key': 'nilai', 
        'icon': Icons.grade,
        'gradient': [Color(0xFF43e97b), Color(0xFF38f9d7)],
        'iconColor': Colors.white
      },
    ];
    
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final cardHeight = width < 400 ? 110.0 : width < 500 ? 130.0 : 160.0;
    final iconSize = width < 400 ? 28.0 : width < 500 ? 36.0 : 48.0;
    double fontSize = (width * 0.045).clamp(10.0, 18.0);
    final isSmall = width < 400;
    final double cardPadding = width < 350 ? 8 : width < 500 ? 12 : 20;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: menus.map((menu) {
          return InkWell(
            onTap: () => onMenuTap(menu['key']!),
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: menu['gradient'],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: menu['gradient'][0].withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              height: cardHeight,
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            menu['icon'],
                            size: iconSize,
                            color: menu['iconColor'],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            menu['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
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
