import 'package:flutter/material.dart'; // Mengimpor paket untuk desain material dari Flutter.
import 'package:image_picker/image_picker.dart'; // Mengimpor paket untuk memilih gambar dari galeri atau kamera.
import 'package:dio/dio.dart'; // Mengimpor paket Dio untuk melakukan permintaan HTTP.
import 'package:http_parser/http_parser.dart'; // Mengimpor paket untuk parsing data HTTP.

void main() {
  runApp(const MyApp()); // Memulai aplikasi dengan widget MyApp.
}

class MyApp extends StatefulWidget {
  // Mendeklarasikan kelas MyApp yang merupakan StatefulWidget.
  const MyApp({super.key}); // Konstruktor kelas MyApp dengan key opsional.
  @override
  State<MyApp> createState() => _MyAppState(); // Membuat state untuk MyApp.
}

class _MyAppState extends State<MyApp> {
  // Kelas state untuk MyApp.
  String namaImage =
      ""; // String untuk menyimpan nama file gambar yang diunggah.

  final dio = Dio(); // Membuat instance Dio untuk permintaan HTTP.

  Future<String> uploadFile(List<int> file, String fileName) async {
    // Fungsi untuk mengunggah file.
    print("mulai"); // Mencetak log 'mulai'.
    FormData formData = FormData.fromMap({
      // Membuat data form untuk permintaan HTTP.
      "file":
          MultipartFile.fromBytes(file, // Menambahkan file sebagai multipart.
              filename: fileName,
              contentType: MediaType("image", "png")),
    });
    var response = await dio.post("http://127.0.0.1:8000/uploadimage",
        data: formData); // Mengirim permintaan POST ke server.

    print(response.statusCode); // Mencetak status kode dari respons.
    if (response.statusCode == 200) {
      // Jika respons berhasil (status 200),
      setState(() {
        namaImage = fileName; // Menyimpan nama file ke state.
      });
    }
    return fileName; // Mengembalikan nama file.
  }

  Future<void> _getImageFromGallery() async {
    // Fungsi untuk mengambil gambar dari galeri.
    print("get image"); // Mencetak 'get image'.
    final picker = ImagePicker(); // Membuat instance picker.
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery); // Memilih gambar dari galeri.
    final bytes =
        await pickedImage?.readAsBytes(); // Mengubah gambar menjadi byte.
    if (pickedImage != null) {
      print("mulai upload"); // Mencetak 'mulai upload'.
      await uploadFile(
          bytes as List<int>, pickedImage.name); // Memanggil fungsi uploadFile.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membangun UI aplikasi.
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'), // Judul AppBar.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            namaImage != ""
                ? Image.network(
                    // Menampilkan gambar jika ada.
                    'http://127.0.0.1:8000/getimage/$namaImage',
                    height: 200,
                  )
                : const Text(
                    "Image Tidak Tersedia"), // Menampilkan teks jika gambar tidak tersedia.
            const SizedBox(height: 20),
            ElevatedButton(
              // Tombol untuk memilih gambar.
              onPressed: _getImageFromGallery,
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    ));
  }
}
