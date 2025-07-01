  import 'package:flutter/material.dart';
import '../../api/students_api.dart';
import '../../models/students_model.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal')),
      body: FutureBuilder<List<Jadwal>>(
        future: StudentsApi.fetchJadwal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data jadwal'));
          }
          final jadwalList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jadwalList.length,
            itemBuilder: (context, index) {
              final item = jadwalList[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(item.matkul),
                  subtitle: Text('Jam: \\${item.jam}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 