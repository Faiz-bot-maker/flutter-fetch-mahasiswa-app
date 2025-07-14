// import 'package:flutter/material.dart';
// import 'package:flutter_mahasiswa_api/models/students_model.dart';
// import '../../api/absensi_api.dart'; // Import API

// class AbsensiPage extends StatelessWidget {
//   const AbsensiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Absensi')),
//       body: FutureBuilder<List<MataKuliah>>(
//         future: AbsensiApi.fetchAbsensi(), // Fetch data dari API
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Tidak ada data absensi'));
//           }

//           final mataKuliahList = snapshot.data!;
//           final width = MediaQuery.of(context).size.width;
//           final fontSize = width < 500 ? 10.0 : 13.0;
//           final iconSize = width < 500 ? 16.0 : 20.0;
//           final cellPadding = width < 500 ? 4.0 : 8.0;

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: DataTable(
//                   headingRowColor: MaterialStateProperty.all(
//                     const Color(0xFFB3E5FC),
//                   ),
//                   dataRowColor: MaterialStateProperty.all(Colors.white),
//                   columnSpacing: width < 500 ? 8 : 16,
//                   columns: [
//                     DataColumn(
//                       label: Padding(
//                         padding: EdgeInsets.all(cellPadding),
//                         child: Text(
//                           'Mata Kuliah',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ...List.generate(
//                       mataKuliahList.first.daftarAbsensi.length,
//                       (i) => DataColumn(
//                         label: Padding(
//                           padding: EdgeInsets.all(cellPadding),
//                           child: Text(
//                             '${i + 1}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontSize,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   rows: List.generate(mataKuliahList.length, (rowIdx) {
//                     final mataKuliah = mataKuliahList[rowIdx];
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.all(cellPadding),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.book,
//                                   color: Colors.blueAccent,
//                                   size: iconSize,
//                                 ),
//                                 const SizedBox(width: 2),
//                                 Flexible(
//                                   child: Text(
//                                     mataKuliah.namaMataKuliah,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: fontSize,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         ...mataKuliah.daftarAbsensi.map((kehadiran) {
//                           return DataCell(
//                             Padding(
//                               padding: EdgeInsets.all(cellPadding),
//                               child: kehadiran.status.toLowerCase() == 'hadir'
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: iconSize,
//                                     )
//                                   : Icon(
//                                       Icons.cancel,
//                                       color: Colors.redAccent,
//                                       size: iconSize,
//                                     ),
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/absensi_api.dart';
import 'package:flutter_mahasiswa_api/models/students_model.dart';

class AbsensiPage extends StatelessWidget {
  const AbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi')),
      body: FutureBuilder<List<MataKuliah>>(
        future: AbsensiApi.fetchAbsensi(), // Fetch data dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data absensi'));
          }

          final mataKuliahList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mataKuliahList.length,
            itemBuilder: (context, index) {
              final mataKuliah = mataKuliahList[index];
              final totalHadir = mataKuliah.daftarAbsensi
                  .where((k) => k.status.toLowerCase() == 'hadir')
                  .length;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(mataKuliah.namaMataKuliah),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pertemuan: ${mataKuliah.daftarAbsensi.length}',
                      ),
                      Text('Total Hadir: $totalHadir'),
                      const SizedBox(height: 8),
                      ...mataKuliah.daftarAbsensi.map((kehadiran) {
                        return Row(
                          children: [
                            kehadiran.status.toLowerCase() == 'hadir'
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.cancel, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              '${kehadiran.waktu.toString().split('.')[0]} - ${kehadiran.status}',
                            ),
                          ],
                        );
                      }),
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
