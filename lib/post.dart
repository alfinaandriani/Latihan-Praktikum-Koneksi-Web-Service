import 'package:flutter/material.dart'; // Import package material untuk membangun UI.
import 'package:http/http.dart'
    as http; // Import package http untuk melakukan operasi jaringan seperti GET dan POST.

void main() => runApp(MaterialApp(
    home: MyApp())); // Fungsi utama yang menjalankan aplikasi Flutter.

class MyApp extends StatefulWidget {
  // Mendefinisikan MyApp sebagai StatefulWidget karena state aplikasi akan berubah.
  const MyApp({Key? key})
      : super(key: key); // Constructor MyApp dengan key optional.
  @override
  MyAppState createState() => MyAppState(); // Membuat state untuk widget MyApp.
}

class MyAppState extends State<MyApp> {
  late Future<int>
      respPost; // Future untuk menampung status code dari respons POST.
  String url =
      "http://127.0.0.1:8000/tambah_mhs/"; // URL endpoint untuk POST data.

  Future<int> insertData() async {
    // Fungsi async untuk melakukan POST request.
    // Melakukan POST request dengan header dan body yang didefinisikan.
    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    }, body: """
      {"nim": "13594022",
      "nama": "Sandra Permana",
      "id_prov": "12",
      "angkatan": "2020",
      "tinggi_badan": 190} """);
    return response
        .statusCode; // Mengembalikan status code dari respons (201 jika berhasil).
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
                      insertData(); // Memperbarui state respPost dengan hasil dari insertData().
                });
              },
              child: const Text(
                  'Klik Untuk Insert data (POST)'), // Teks pada tombol.
            ),
            Text("Hasil:"), // Teks label untuk menampilkan hasil.
            FutureBuilder<int>(
                future: respPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Memeriksa jika snapshot memiliki data.
                    if (snapshot.data! == 201) {
                      return Text(
                          "Proses Insert Berhasil!"); // Teks jika proses insert berhasil.
                    }
                    if (snapshot.data! == 0) {
                      return Text(""); // Teks kosong jika status code 0.
                    } else {
                      return Text(
                          "Proses insert gagal"); // Teks jika proses insert gagal.
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
