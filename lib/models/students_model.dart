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
  final String course;
  final String lecturer;
  final String classroom;
  final String startAt;
  final String endAt;
  final DateTime date;

  Jadwal({
    required this.course,
    required this.lecturer,
    required this.classroom,
    required this.startAt,
    required this.endAt,
    required this.date,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      course: json['course'] as String,
      lecturer: json['lecturer'] as String,
      classroom: json['classroom'] as String,
      startAt: json['start_at'] as String,
      endAt: json['end_at'] as String,
      date: DateTime.parse(json['date']),
    );
  }
}

class Matakuliah {
  final int sks;
  final String name;
  final String lecturer;

  Matakuliah({required this.sks, required this.name, required this.lecturer});

  factory Matakuliah.fromJson(Map<String, dynamic> json) {
    return Matakuliah(
      sks: json['sks'] as int,
      name: json['name'] as String,
      lecturer: json['lecturer'] as String,
    );
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
  final String status;
  final DateTime waktu;

  Absensi({required this.status, required this.waktu});

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      status: json['status'] as String,
      waktu: DateTime.parse(json['time'] as String),
    );
  }
}

class MataKuliah {
  final String namaMataKuliah;
  final List<Absensi> daftarAbsensi;

  MataKuliah({required this.namaMataKuliah, required this.daftarAbsensi});

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      namaMataKuliah: json['course'] as String,
      daftarAbsensi: (json['attendances'] as List<dynamic>)
          .map((absensiJson) => Absensi.fromJson(absensiJson))
          .toList(),
    );
  }
}
