import 'package:flutter/material.dart';
import 'package:flutter_mahasiswa_api/api/nilai_api.dart';
import '../../models/students_model.dart';

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nilai')),
      body: FutureBuilder<List<Nilai>>(
        future: NilaiApi.fetchNilai(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
                child: ExpansionTile(
                  leading: const Icon(Icons.grade),
                  title: Text(item.courseName),
                  subtitle: Text('Total Score: ${item.totalScore}'),
                  children: item.components.map((component) {
                    return ListTile(
                      title: Text(component.name),
                      trailing: Text(component.score.toString()),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
