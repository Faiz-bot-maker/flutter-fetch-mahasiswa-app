import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/nilai_api.dart';
import 'package:flutter_mahasiswa_api/api/matkul_api.dart';
import '../../models/students_model.dart';

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Nilai Akademik',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF667eea),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          NilaiApi.fetchNilai(),
          MatkulApi.fetchMatakuliah(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data![0] == null || (snapshot.data![0] as List).isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grade_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada data nilai',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final nilaiList = snapshot.data![0] as List<Nilai>;
          final matkulList = snapshot.data![1] as List<Matakuliah>;

          // Mapping nama matakuliah ke SKS
          final sksMap = {for (var m in matkulList) m.name: m.sks};

          // Hitung total sks dan ipk
          double totalSks = 0;
          double totalBobot = 0;
          for (final n in nilaiList) {
            final sks = sksMap[n.courseName] ?? 0;
            final gradePoint = double.tryParse(_getGradePoint(n.totalScore)) ?? 0.0;
            totalSks += sks;
            totalBobot += gradePoint * sks;
          }
          final ipk = totalSks > 0 ? (totalBobot / totalSks) : 0.0;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF48BB78), Color(0xFFF8F9FA)],
                    stops: [0.0, 0.3],
                  ),
                ),
                child: Column(
                  children: [
                    // Debug info - remove this later
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Total Mata Kuliah: ${nilaiList.length}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: nilaiList.length,
                        itemBuilder: (context, index) {
                          final item = nilaiList[index];
                          final isSmall = MediaQuery.of(context).size.width < 400;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getCourseColor(index),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.grade,
                                  color: _getScoreColor(item.totalScore),
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                item.courseName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getScoreColor(item.totalScore),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${isSmall ? 'AM' : 'Angka Mutu'}: ${_getGradePoint(item.totalScore)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getScoreColor(item.totalScore),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${isSmall ? 'HM' : 'Huruf Mutu'}: ${_getGradeLetter(item.totalScore)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: item.components.map((component) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4299E1).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.assessment,
                                          size: 16,
                                          color: Color(0xFF4299E1),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          component.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2D3748),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getComponentScoreColor(component.grade),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          component.grade.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // SKS dan IPK di kanan bawah
              Positioned(
                bottom: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'SKS: ${totalSks.toInt()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'IPK: ${ipk.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF38B2AC),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getCourseColor(int index) {
    final colors = [
      const Color(0xFF48BB78), // Green
      const Color(0xFF4299E1), // Blue
      const Color(0xFFED8936), // Orange
      const Color(0xFFE53E3E), // Red
      const Color(0xFF9F7AEA), // Purple
      const Color(0xFF38B2AC), // Teal
      const Color(0xFFF56565), // Red
      const Color(0xFF6C63FF), // Purple
    ];
    return colors[index % colors.length];
  }

  Color _getScoreColor(double score) {
    if (score >= 85) {
      return const Color(0xFF48BB78); // Green - A (4.0)
    } else if (score >= 80) {
      return const Color(0xFF38B2AC); // Teal - A- (3.7)
    } else if (score >= 75) {
      return const Color(0xFF4299E1); // Blue - B+ (3.5)
    } else if (score >= 70) {
      return const Color(0xFF6C63FF); // Purple - B (3.0)
    } else if (score >= 65) {
      return const Color(0xFFED8936); // Orange - C+ (2.5)
    } else if (score >= 60) {
      return const Color(0xFFF56565); // Red - C (2.0)
    } else if (score >= 55) {
      return const Color(0xFFE53E3E); // Dark Red - D (1.5)
    } else {
      return const Color(0xFF2D3748); // Dark Gray - E (0.0)
    }
  }

Color _getComponentScoreColor(double score) {
  if (score >= 85) {
    return const Color(0xFF48BB78); // Green
  } else if (score >= 75) {
    return const Color(0xFF4299E1); // Orange
  } else if (score >= 65) {
    return const Color(0xFFED8936); // Red
  } else {
    return const Color(0xFFE53E3E); // Red
  }
  }

  String _getGradeLetter(double score) {
    if (score >= 85) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 65) return 'C+';
    if (score >= 60) return 'C';
    if (score >= 55) return 'D';
    return 'E';
  }

  String _getGradePoint(double score) {
    if (score >= 85) return '4.0';
    if (score >= 80) return '3.7';
    if (score >= 75) return '3.5';
    if (score >= 70) return '3.0';
    if (score >= 65) return '2.5';
    if (score >= 60) return '2.0';
    if (score >= 55) return '1.5';
    return '0.0';
  }
}
