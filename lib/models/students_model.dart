// class Absensi {
//   final String tanggal;
//   final String status;

//   Absensi({required this.tanggal, required this.status});

//   factory Absensi.fromJson(Map<String, dynamic> json) {
//     return Absensi(
//       tanggal: json['tanggal'] as String,
//       status: json['status'] as String,
//     );
//   }
// }

class Jadwal {
  final String matkul;
  final String jam;

  Jadwal({required this.matkul, required this.jam});

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(matkul: json['matkul'] as String, jam: json['jam'] as String);
  }
}

class Matakuliah {
  final int sks;
  final String name;

  Matakuliah({required this.sks, required this.name});

  factory Matakuliah.fromJson(Map<String, dynamic> json) {
    return Matakuliah(sks: json['sks'] as int, name: json['name'] as String);
  }
}

class Nilai {
  final String courseName;
  final double totalScore;
  final List<Component> components;

  Nilai({
    required this.courseName,
    required this.totalScore,
    required this.components,
  });

  factory Nilai.fromJson(Map<String, dynamic> json) {
    var componentsJson = json['components'] as List;
    List<Component> componentsList = componentsJson
        .map((component) => Component.fromJson(component))
        .toList();

    return Nilai(
      courseName: json['course_name'] as String,
      totalScore: json['total_score'] as double,
      components: componentsList,
    );
  }
}

class Component {
  final String name;
  final double score;

  Component({required this.name, required this.score});

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      name: json['name'] as String,
      score: json['score'] as double,
    );
  }
}

class Absensi {
  final String kode;
  final String nama;
  final List<bool> kehadiran; // true = hadir, false = tidak hadir
  final int total;

  Absensi({
    required this.kode,
    required this.nama,
    required this.kehadiran,
    required this.total,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      kode: json['kode'] as String,
      nama: json['nama'] as String,
      kehadiran: List<bool>.from(json['kehadiran']),
      total: json['total'] as int,
    );
  }
}
