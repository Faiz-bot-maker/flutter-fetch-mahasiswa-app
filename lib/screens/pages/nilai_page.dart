import 'package:flutter/material.dart';
import '../../api/students_api.dart';
import '../../models/students_model.dart';

class NilaiPage extends StatelessWidget {
  const NilaiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nilai')),
      body: FutureBuilder<List<Nilai>>(
        future: StudentsApi.fetchNilai(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data nilai'));
          }
          final nilaiList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final item = nilaiList[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.grade),
                  title: Text(item.matkul),
                  trailing: Text(item.nilai, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 