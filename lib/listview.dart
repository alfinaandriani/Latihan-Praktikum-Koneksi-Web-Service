import 'package:flutter/material.dart'; // Mengimpor paket material untuk mengembangkan antarmuka pengguna.
import 'package:http/http.dart'
    as http; // Mengimpor paket http untuk permintaan jaringan.
import 'dart:convert'; // Mengimpor dart:convert untuk mengubah data JSON.

class PopulasiTahun {
  // Kelas untuk menyimpan data populasi per tahun.
  int tahun; // Variabel untuk menyimpan tahun.
  int populasi; // Variabel untuk menyimpan jumlah populasi.
  PopulasiTahun(
      {required this.tahun,
      required this.populasi}); // Constructor yang menerima tahun dan populasi.
}

class Populasi {
  // Kelas untuk menyimpan daftar data populasi per tahun.
  List<PopulasiTahun> ListPop =
      <PopulasiTahun>[]; // List untuk menyimpan objek PopulasiTahun.

  Populasi(Map<String, dynamic> json) {
    // Constructor yang menerima JSON dan mengonversinya.
    var data = json["data"]; // Mengakses array "data" dari JSON.
    for (var val in data) {
      // Loop melalui setiap item dalam array data.
      var tahun =
          int.parse(val["Year"]); // Mengonversi tahun dari String ke Integer.
      var populasi = val[
          "Population"]; // Mengambil populasi yang sudah dalam format Integer.
      ListPop.add(PopulasiTahun(
          tahun: tahun,
          populasi: populasi)); // Menambahkan objek PopulasiTahun ke list.
    }
  }

  factory Populasi.fromJson(Map<String, dynamic> json) {
    // Factory constructor untuk menginisialisasi Populasi dari JSON.
    return Populasi(json); // Memanggil constructor utama.
  }
}

void main() {
  runApp(MyApp()); // Fungsi utama untuk menjalankan aplikasi.
}

class MyApp extends StatefulWidget {
  // StatefulWidget untuk aplikasi MyApp.
  @override
  State<StatefulWidget> createState() {
    // Membuat state untuk widget.
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // State class untuk MyApp.
  late Future<Populasi>
      futurePopulasi; // Future untuk menyimpan hasil pengambilan data populasi.

  String url =
      "https://datausa.io/api/data?drilldowns=Nation&measures=Population"; // URL API untuk mendapatkan data.

  Future<Populasi> fetchData() async {
    // Fungsi untuk mengambil data dari API.
    final response =
        await http.get(Uri.parse(url)); // Melakukan permintaan GET ke URL.

    if (response.statusCode == 200) {
      // Jika respons HTTP adalah 200 OK.
      return Populasi.fromJson(jsonDecode(
          response.body)); // Mengurai JSON dan menginisialisasi objek Populasi.
    } else {
      // Jika status code bukan 200.
      throw Exception(
          'Gagal load'); // Membuat exception jika pengambilan data gagal.
    }
  }

  @override
  void initState() {
    // Inisialisasi state.
    super.initState();
    futurePopulasi = fetchData(); // Memanggil fetchData saat inisialisasi.
  }

  @override
  Widget build(BuildContext context) {
    // Membangun UI aplikasi.
    return MaterialApp(
        title: 'coba http',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('coba http'), // AppBar dengan judul.
          ),
          body: Center(
            child: FutureBuilder<Populasi>(
              // FutureBuilder untuk menangani data Future.
              future: futurePopulasi, // Future yang dimonitor.
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Jika data tersedia.
                  return Center(
                    child: ListView.builder(
                      // ListView untuk menampilkan data.
                      itemCount: snapshot.data!.ListPop
                          .length, // Jumlah item berdasarkan data yang diterima.
                      itemBuilder: (context, index) {
                        // Membangun tampilan untuk setiap item.
                        return Container(
                            decoration: BoxDecoration(
                                border: Border.all()), // Dekorasi container.
                            padding: const EdgeInsets.all(
                                14), // Padding di dalam container.
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.ListPop[index].tahun
                                      .toString()), // Menampilkan tahun.
                                  Text(snapshot.data!.ListPop[index].populasi
                                      .toString()), // Menampilkan populasi.
                                ]));
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Jika terjadi kesalahan.
                  return Text('${snapshot.error}'); // Menampilkan error.
                }
                // Tampilkan spinner jika data belum siap.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
