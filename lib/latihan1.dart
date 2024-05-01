import 'dart:convert'; // Mengimpor paket Dart untuk konversi data JSON

void main() {
  // Data JSON yang disimpan sebagai string
  String jsonString = '''
  {
    "mahasiswa": {
      "nama": "Alfina Andriani",
      "nim": "22082010018",
      "prodi": "Sistem Informasi",
      "universitas": "UPN Veteran Jawa Timur"
    },
    "transkrip": [
      {
        "kode_mk": "SI231110",
        "nama_mk": "Desain Manajemen Jaringan",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode_mk": "SI231119",
        "nama_mk": "Interaksi Manusia Komputer",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode_mk": "SI231114",
        "nama_mk": "Pemrograman Desktop",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode_mk": "SI231115",
        "nama_mk": "Administrasi Basis Data",
        "sks": 3,
        "nilai": "A"
      }
    ]
  }
  ''';

  // Menguraikan JSON ke dalam objek Map untuk memudahkan akses data
  Map<String, dynamic> parsedJson = jsonDecode(jsonString);

  // Mengakses array transkrip dari JSON
  List<dynamic> transkrip = parsedJson['transkrip'];

  double totalNilai = 0.0;
  int totalSks = 0;

  // Fungsi untuk mengonversi nilai huruf ke angka
  double nilaiKeAngka(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0; // untuk nilai yang tidak dikenal atau gagal
    }
  }

  // Perhitungan total nilai dan total SKS
  for (var mataKuliah in transkrip) {
    int sks = mataKuliah['sks'];
    String nilai = mataKuliah['nilai'];
    totalSks += sks;
    totalNilai += nilaiKeAngka(nilai) * sks;
  }

  // Menghitung IPK
  double ipk = totalNilai / totalSks;

  // Menampilkan IPK
  print(
      "IPK dari ${parsedJson['mahasiswa']['nama']} adalah ${ipk.toStringAsFixed(2)}");
}
