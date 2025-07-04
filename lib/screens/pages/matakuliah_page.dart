import 'package:flutter/material.dart';
import '../../api/students_api.dart';
import '../../models/students_model.dart';

class MatakuliahPage extends StatelessWidget {
  const MatakuliahPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matakuliah')),
      body: FutureBuilder<List<Matakuliah>>(
        future: StudentsApi.fetchMatakuliah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data matakuliah'));
          }
          final matkulList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matkulList.length,
            itemBuilder: (context, index) {
              final item = matkulList[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(item.nama),
                  subtitle: Text('Kode: \\${item.kode}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 