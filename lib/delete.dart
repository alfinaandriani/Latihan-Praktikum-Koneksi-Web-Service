import 'package:flutter/material.dart'; // Mengimpor paket Material untuk UI.
import 'package:http/http.dart'
    as http; // Mengimpor paket http untuk permintaan HTTP.

void main() =>
    runApp(MaterialApp(home: MyApp())); // Fungsi utama yang memulai aplikasi.

class MyApp extends StatefulWidget {
  // Kelas StatefulWidget untuk manajemen state.
  const MyApp({Key? key}) : super(key: key); // Konstruktor dengan Key opsional.
  @override
  MyAppState createState() => MyAppState(); // Membuat state untuk widget.
}

class MyAppState extends State<MyApp> {
  late Future<int>
      respPost; // Variabel untuk menyimpan status kode respons HTTP.
  String url =
      "http://127.0.0.1:8000/delete_mhs/"; // URL endpoint untuk DELETE request.

  Future<int> fetchData() async {
    // Fungsi async untuk melakukan DELETE request.
    String nim = "13594022"; // NIM mahasiswa yang akan dihapus.
    final response = await http.delete(Uri.parse(
        url + nim)); // Melakukan DELETE request dengan menambahkan NIM.
    return response.statusCode; // Mengembalikan status code dari respons HTTP.
  }

  @override
  void initState() {
    super.initState();
    respPost = Future.value(0); // Inisialisasi awal untuk respPost.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App', // Judul aplikasi.
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'), // Judul AppBar.
        ),
        body: Center(
            child: Column(
          mainAxisSize:
              MainAxisSize.min, // Menetapkan ukuran minimum untuk Column.
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  respPost =
                      fetchData(); // Memanggil fetchData saat tombol ditekan dan memperbarui state.
                });
              },
              child: const Text('Klik untuk delete data'), // Teks pada tombol.
            ),
            Text("Hasil:"), // Teks label untuk menampilkan hasil.
            FutureBuilder<int>(
                future:
                    respPost, // FutureBuilder yang mengikuti Future respPost.
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Memeriksa jika snapshot memiliki data.
                    if (snapshot.data! == 200) {
                      return Text(
                          "Proses delete berhasil!"); // Menampilkan teks jika delete berhasil.
                    }
                    if (snapshot.data! == 0) {
                      return Text(
                          ""); // Menampilkan teks kosong jika respPost masih 0.
                    } else {
                      return Text(
                          "Proses delete gagal"); // Menampilkan teks jika delete gagal.
                    }
                  }
                  return const CircularProgressIndicator(); // Menampilkan spinner loading saat menunggu data.
                })
          ],
        )), // Centered column dalam body Scaffold.
      ), // Scaffold.
    ); // MaterialApp.
  }
}
