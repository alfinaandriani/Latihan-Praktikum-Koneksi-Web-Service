import 'package:flutter/material.dart'; // Mengimpor material design library dari Flutter untuk membangun UI
import 'package:http/http.dart'
    as http; // Mengimpor paket untuk melakukan HTTP requests
import 'dart:convert'; // Mengimpor paket Dart untuk konversi data JSON
import 'package:url_launcher/url_launcher.dart'; // Mengimpor paket untuk meluncurkan URL di browser atau aplikasi pihak ketiga

// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(MyApp());
}

// Widget MyApp yang merupakan root dari aplikasi
class MyApp extends StatelessWidget {
  // Metode build yang membangun widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universitas di Indonesia', // Judul aplikasi
      home: UniversitasListPage(), // Menentukan homepage aplikasi
    );
  }
}

// Mendefinisikan struktur data untuk Universitas
class Universitas {
  final String name; // Nama universitas
  final String website; // Website universitas

  // Constructor yang meminta parameter nama dan website
  Universitas({required this.name, required this.website});

  // Factory constructor untuk membuat instance University dari data JSON
  factory Universitas.fromJson(Map<String, dynamic> json) {
    return Universitas(
      name: json['name'] ?? "Nama Tidak Tersedia",
      website: json['web_pages'] != null && json['web_pages'].isNotEmpty
          ? json['web_pages'][0] // Mengambil URL pertama dari array web_pages
          : "Situs Web Tidak Tersedia", // Default jika tidak ada website
    );
  }
}

// Widget stateful untuk halaman list universitas
class UniversitasListPage extends StatefulWidget {
  @override
  _UniversitasListPageState createState() => _UniversitasListPageState();
}

// State untuk UniversitasListPage
class _UniversitasListPageState extends State<UniversitasListPage> {
  late Future<List<Universitas>>
      futureUniversities; // Future untuk menyimpan daftar universitas

  // Fungsi untuk mengambil data universitas dari API
  Future<List<Universitas>> fetchUniversities() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    // Memeriksa jika response berhasil
    if (response.statusCode == 200) {
      // Decode response body menjadi JSON
      List jsonResponse = json.decode(response.body);
      // Mengonversi JSON menjadi daftar universitas
      return jsonResponse.map((data) => Universitas.fromJson(data)).toList();
    } else {
      // Melemparkan exception jika gagal mengambil data
      throw Exception('Gagal memuat universitas');
    }
  }

  // Inisialisasi state
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi fetchUniversities saat state diinisialisasi
    futureUniversities = fetchUniversities();
  }

  // Membangun UI halaman daftar universitas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(
        title: Text("Universitas di Indonesia"),
      ),
      // Body menggunakan FutureBuilder untuk menampilkan data atau loading indikator
      body: FutureBuilder<List<Universitas>>(
        future: futureUniversities,
        builder: (context, snapshot) {
          // Menampilkan loading indikator jika data belum siap
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            // Menampilkan error jika terjadi kesalahan saat fetch data
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          // ListView yang menampilkan data universitas
          return ListView.separated(
            // Tentukan jumlah item dalam ListView berdasarkan panjang data yang diterima dari Future.
            itemCount: snapshot.data?.length ?? 0,
            // Tentukan jumlah item dalam ListView berdasarkan panjang data yang diterima dari Future.
            separatorBuilder: (context, index) => Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              var university = snapshot.data![index];
              // ListTile untuk setiap universitas.
              return ListTile(
                title: Center(child: Text(university.name)),
                subtitle: Center(
                  // Widget GestureDetector digunakan untuk menangkap gestur tap
                  child: GestureDetector(
                    // Fungsi onTap diatur untuk memanggil _launchURL ketika teks URL diklik
                    onTap: () => _launchURL(university.website),
                    child: Text(
                      university.website,
                      // Untuk mengatur desain link website universitas
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fungsi untuk membuka URL di browser eksternal atau aplikasi yang sesuai.
  void _launchURL(String url) async {
    // Cek apakah URL dapat dibuka.
    if (await canLaunch(url)) {
      // Buka URL jika valid dan dapat diakses.
      await launch(url);
    } else {
      // Lempar eksepsi jika URL tidak dapat dibuka.
      throw 'Could not launch $url';
    }
  }
}
