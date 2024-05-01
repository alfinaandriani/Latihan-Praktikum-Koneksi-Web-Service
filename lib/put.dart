import 'package:flutter/material.dart'; // Mengimpor material design library dari Flutter untuk UI.
import 'package:http/http.dart'
    as http; // Mengimpor package http untuk melakukan HTTP requests.

void main() => runApp(MaterialApp(
    home:
        MyApp())); // Fungsi utama yang menjalankan aplikasi dengan widget MyApp.

class MyApp extends StatefulWidget {
  // Mendefinisikan MyApp sebagai StatefulWidget karena state aplikasi akan berubah.
  const MyApp({Key? key})
      : super(key: key); // Constructor untuk MyApp dengan key opsional.
  @override
  MyAppState createState() => MyAppState(); // Membuat state untuk widget MyApp.
}

class MyAppState extends State<MyApp> {
  late Future<int>
      respPost; // Variabel untuk menyimpan status code respons HTTP.
  String url =
      "http://127.0.0.1:8000/update_mhs_put/"; // URL endpoint untuk melakukan PUT request.

  Future<int> fetchData() async {
    // Fungsi async untuk melakukan PUT request.
    String nim = "13594022"; // NIM mahasiswa yang akan di-update.
    final response = await http.put(
        // Melakukan PUT request.
        Uri.parse(url + nim), // Membangun URL dengan menambahkan NIM mahasiswa.
        headers: <String, String>{
          // Menentukan header request.
          'Content-Type':
              'application/json; charset=UTF-8' // Mengatur Content-Type sebagai JSON.
        },
        body: """
      {
      "nim":"13594022",  
      "nama": "Ahmad Aulia2",
      "id_prov": "142",
      "angkatan": "2022",
      "tinggi_badan": 192} """); // Mengirimkan data mahasiswa baru dalam format JSON.
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
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'), // Judul AppBar.
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  respPost =
                      fetchData(); // Memperbarui state respPost dengan hasil dari fetchData().
                });
              },
              child: const Text(
                  'Klik untuk update data (PUT)'), // Teks pada tombol.
            ),
            Text("Hasil:"), // Teks label untuk menampilkan hasil.
            FutureBuilder<int>(
                future: respPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Memeriksa jika snapshot memiliki data.
                    if (snapshot.data! == 200) {
                      return Text(
                          "Proses Update Berhasil!"); // Teks jika proses update berhasil.
                    }
                    if (snapshot.data! == 0) {
                      return Text(""); // Teks kosong jika status code 0.
                    } else {
                      return Text(
                          "Proses insert gagal"); // Teks jika proses update gagal.
                    }
                  }
                  // Menampilkan spinner loading ketika menunggu data.
                  return const CircularProgressIndicator();
                })
          ],
        )), // Column di tengah body.
      ), // Scaffold.
    ); // MaterialApp.
  }
}
