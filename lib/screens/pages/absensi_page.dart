// import 'package:flutter/material.dart';
// import '../../api/students_api.dart';
// import '../../models/students_model.dart';

// class AbsensiPage extends StatelessWidget {
//   const AbsensiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6FAFF),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB3E5FC),
//         elevation: 0,
//         title: Row(
//           children: const [
//             Icon(Icons.school, color: Colors.blueAccent),
//             SizedBox(width: 8),
//             Text(
//               'Absensi Mata Kuliah',
//               style: TextStyle(color: Colors.black87),
//             ),
//           ],
//         ),
//         iconTheme: const IconThemeData(color: Colors.blueAccent),
//       ),
//       body: FutureBuilder<List<Absensi>>(
//         future: StudentsApi.fetchAbsensi(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: \\${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Tidak ada data absensi'));
//           }
//           final data = snapshot.data!;
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
//                   headingRowColor: WidgetStateProperty.all(
//                     const Color(0xFFB3E5FC),
//                   ),
//                   dataRowColor: WidgetStateProperty.all(Colors.white),
//                   columnSpacing: width < 500 ? 8 : 16,
//                   columns: [
//                     DataColumn(
//                       label: Padding(
//                         padding: EdgeInsets.all(cellPadding),
//                         child: Text(
//                           'No',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Padding(
//                         padding: EdgeInsets.all(cellPadding),
//                         child: Text(
//                           'Kode',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Padding(
//                         padding: EdgeInsets.all(cellPadding),
//                         child: Text(
//                           'Nama Mata Kuliah',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ...List.generate(
//                       16,
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
//                     DataColumn(
//                       label: Padding(
//                         padding: EdgeInsets.all(cellPadding),
//                         child: Text(
//                           'Total',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   rows: List.generate(data.length, (rowIdx) {
//                     final matkul = data[rowIdx];
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.all(cellPadding),
//                             child: Text(
//                               '${rowIdx + 1}',
//                               style: TextStyle(fontSize: fontSize),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.all(cellPadding),
//                             child: Text(
//                               matkul.kode,
//                               style: TextStyle(fontSize: fontSize),
//                             ),
//                           ),
//                         ),
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
//                                     matkul.namaMatkul,
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
//                         ...List.generate(16, (i) {
//                           final hadir = matkul.kehadiran.length > i
//                               ? matkul.kehadiran[i]
//                               : false;
//                           return DataCell(
//                             Padding(
//                               padding: EdgeInsets.all(cellPadding),
//                               child: hadir
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
//                         }),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.all(cellPadding),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.emoji_events,
//                                   color: Colors.amber,
//                                   size: iconSize - 2,
//                                 ),
//                                 const SizedBox(width: 2),
//                                 Text(
//                                   matkul.total.toString(),
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontSize,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
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
