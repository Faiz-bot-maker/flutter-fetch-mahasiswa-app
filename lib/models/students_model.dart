class Absensi {
  final String tanggal;
  final String status;

  Absensi({required this.tanggal, required this.status});

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      tanggal: json['tanggal'] as String,
      status: json['status'] as String,
    );
  }
}

class Jadwal {
  final String matkul;
  final String jam;

  Jadwal({required this.matkul, required this.jam});

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      matkul: json['matkul'] as String,
      jam: json['jam'] as String,
    );
  }
}

class Matakuliah {
  final String kode;
  final String nama;

  Matakuliah({required this.kode, required this.nama});

  factory Matakuliah.fromJson(Map<String, dynamic> json) {
    return Matakuliah(
      kode: json['kode'] as String,
      nama: json['nama'] as String,
    );
  }
}

class Nilai {
  final String matkul;
  final String nilai;

  Nilai({required this.matkul, required this.nilai});

  factory Nilai.fromJson(Map<String, dynamic> json) {
    return Nilai(
      matkul: json['matkul'] as String,
      nilai: json['nilai'] as String,
    );
  }
}

class AbsensiMatkul {
  final String kode;
  final String namaMatkul;
  final List<bool> kehadiran; // true = hadir, false = tidak hadir
  final int total;

  AbsensiMatkul({
    required this.kode,
    required this.namaMatkul,
    required this.kehadiran,
    required this.total,
  });

  factory AbsensiMatkul.fromJson(Map<String, dynamic> json) {
    return AbsensiMatkul(
      kode: json['kode'] as String,
      namaMatkul: json['namaMatkul'] as String,
      kehadiran: List<bool>.from(json['kehadiran']),
      total: json['total'] as int,
    );
  }
} 