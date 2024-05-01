import 'package:flutter/material.dart'; // Mengimpor library Material untuk membangun interface pengguna.
import 'package:http/http.dart'
    as http; // Mengimpor library http untuk melakukan permintaan jaringan.

void main() => runApp(
    MaterialApp(home: MyApp())); // Fungsi utama yang menjalankan aplikasi.

class MyApp extends StatefulWidget {
  // Mendefinisikan kelas MyApp sebagai StatefulWidget karena memerlukan state.
  const MyApp({Key? key}) : super(key: key); // Constructor dengan key opsional.
  @override
  MyAppState createState() => MyAppState(); // Membuat state untuk widget.
}

class MyAppState extends State<MyApp> {
  late Future<int>
      respPost; // Variabel untuk menyimpan status code dari respons HTTP.
  String url =
      "http://127.0.0.1:8000/update_mhs_patch/"; // URL endpoint untuk melakukan PATCH request.

  Future<int> fetchData() async {
    // Fungsi async untuk melakukan PATCH request.
    String nim = "13594022"; // Identifikasi NIM yang akan diupdate.
    final response = await http.patch(
        Uri.parse(url +
            nim), // Melakukan PATCH request dengan menambahkan NIM ke URL.
        headers: <String, String>{
          // Menentukan header request.
          'Content-Type':
              'application/json; charset=UTF-8' // Mengatur Content-Type sebagai JSON.
        },
        body: """
      {
      "nama": "Sandra Aulia"} """); // Mengirimkan hanya data nama dalam body request.
    return response
        .statusCode; // Mengembalikan status code dari respons (200 jika berhasil).
  }

  @override
  void initState() {
    super.initState();
    respPost = Future.value(0); // Inisialisasi respPost dengan nilai awal 0.
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
              MainAxisSize.min, // Kolom dengan ukuran minimum yang diperlukan.
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  respPost =
                      fetchData(); // Memperbarui state respPost dengan hasil dari fetchData().
                });
              },
              child: const Text(
                  'Klik untuk update data (patch)'), // Teks pada tombol.
            ),
            Text("Hasil:"), // Teks label untuk menampilkan hasil.
            FutureBuilder<int>(
                future:
                    respPost, // FutureBuilder untuk menangani data Future dari respPost.
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Memeriksa jika snapshot memiliki data.
                    if (snapshot.data! == 200) {
                      return Text(
                          "Proses Update patch Berhasil!"); // Teks jika proses update berhasil.
                    }
                    if (snapshot.data! == 0) {
                      return Text(""); // Teks kosong jika status code 0.
                    } else {
                      return Text(
                          "Proses insert gagal"); // Teks jika proses update gagal.
                    }
                  }
                  return const CircularProgressIndicator(); // Menampilkan spinner loading ketika menunggu data.
                })
          ],
        )), // Kolom di tengah body.
      ), // Scaffold.
    ); // MaterialApp.
  }
}
