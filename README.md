# Portfolio Mobile App - Rayhan Fairuz Aqram

**Nama** : Rayhan Fairuz Aqram <br>
**NPM** : 2506586186 <br>
**Kelas** : PBP D <br>
**Tautan GitHub** : [https://github.com/rayyouw/myportofolio-mobile](https://github.com/rayyouw/myportofolio-mobile) <br>

---

# 1. Documentation

### Deskripsi Proyek
Proyek ini adalah aplikasi mobile portofolio pribadi berbasis Flutter yang dikembangkan secara bertahap pada mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fakultas Ilmu Komputer, Universitas Indonesia. Aplikasi ini merupakan perluasan dari website portofolio Django ke platform mobile.

---
### Perkembangan Mingguan (Weekly Progress)

#### **Tutorial 08: Basic Flutter**
- Menyiapkan lingkungan pengembangan (Flutter SDK dan IDE) dan membuat proyek `myportofolio_mobile`.
- Memisahkan widget halaman utama ke `lib/menu.dart` dari file bootstrap `lib/main.dart`.
- Mengubah `MyHomePage` menjadi `StatelessWidget`.
- Menyusun widget `InfoCard` dan `ItemCard` beserta model `ItemHomepage`.

#### **Tugas 7: Basic Flutter**
- Mengganti data contoh dengan identitas pemilik portofolio (NPM, nama, dan kelas) pada 3 `InfoCard`.
- Menambahkan atribut `Color color` pada model `ItemHomepage` sehingga warna kartu ditentukan oleh data, bukan oleh rantai `if-else` di widget.
- Membuat 5 `ItemCard` dengan ikon dan warna berbeda: View Projects (biru), Add Project (hijau), View Skills (oranye), View Education (ungu), dan Logout (merah).
- Menampilkan `SnackBar` bertuliskan "You pressed the [Button Name] button!" ketika tombol ditekan, dengan warna latar sesuai tombol.
- Membungkus halaman dengan `SingleChildScrollView` agar tidak overflow pada layar kecil.
- Menambahkan doc comment pada `ItemHomepage`, `MyHomePage`, `InfoCard`, dan `ItemCard`.
- Memperbarui widget test agar memverifikasi identitas baru dan SnackBar.
- `flutter analyze` menampilkan *No issues found* dan `flutter test` lulus.

---

# 2. Reflective Questions

### Assignment 7

1. **Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child bekerja antar widget!**

   *Widget tree* adalah struktur pohon dari seluruh widget yang menyusun tampilan aplikasi. Setiap widget dapat memiliki satu atau lebih widget anak (*child/children*), dan widget tersebut menjadi *parent* bagi anaknya. Akar pohon adalah widget yang diberikan ke `runApp()`, yaitu `MyApp`, yang bercabang ke `MaterialApp`, lalu `Scaffold`, kemudian `AppBar` dan `body`, dan seterusnya. Pada hubungan parent-child, parent memberikan batasan ukuran (*constraints*) dan menentukan posisi anaknya, sedangkan anak menentukan ukurannya sendiri di dalam batasan tersebut. Data dan tema juga mengalir dari parent ke turunannya. Ketika state berubah, Flutter hanya membangun ulang bagian pohon yang terdampak.

2. **Sebutkan seluruh widget yang digunakan pada proyek ini dan jelaskan fungsinya!**

   - `MaterialApp`: root aplikasi yang mengatur tema, judul, dan halaman awal (`home`).
   - `Scaffold`: kerangka halaman Material Design (app bar dan body).
   - `AppBar`: bilah judul di bagian atas halaman.
   - `Text`: menampilkan teks.
   - `SingleChildScrollView`: membuat konten dapat di-scroll agar tidak overflow.
   - `Padding`: memberi jarak di sekeliling widget.
   - `Column` dan `Row`: menyusun anak secara vertikal dan horizontal.
   - `Center`: menengahkan anaknya.
   - `SizedBox`: memberi jarak atau ukuran tetap.
   - `GridView.count`: menampilkan item dalam grid dengan jumlah kolom tetap (3 kolom).
   - `Card`: kartu dengan elevasi yang membungkus isi `InfoCard`.
   - `Container`: pembungkus dengan ukuran dan padding.
   - `Material`: permukaan Material dengan warna dan sudut membulat untuk `ItemCard`.
   - `InkWell`: area yang dapat disentuh dengan efek ripple dan callback `onTap`.
   - `Icon`: menampilkan ikon.
   - `SnackBar` dan `ScaffoldMessenger`: menampilkan pesan singkat di bagian bawah layar.
   - Widget buatan sendiri: `MyApp` (root), `MyHomePage` (halaman utama), `InfoCard` (kartu identitas), dan `ItemCard` (kartu tombol aksi).

3. **Apa fungsi `MaterialApp`? Jelaskan mengapa widget ini sering digunakan sebagai widget root!**

   `MaterialApp` membungkus aplikasi dengan fitur-fitur Material Design, seperti tema (`ThemeData`), `Navigator` untuk routing antarhalaman, lokalisasi, dan judul aplikasi. Widget seperti `Scaffold`, `AppBar`, `SnackBar`, dan `ScaffoldMessenger` membutuhkan `MaterialApp` sebagai ancestor agar dapat berfungsi. Karena itu `MaterialApp` umum dipakai sebagai root: seluruh widget di bawahnya otomatis mendapat tema dan layanan yang konsisten tanpa konfigurasi manual.

4. **Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita memilih salah satunya?**

   `StatelessWidget` tidak menyimpan state yang berubah. Tampilannya hanya bergantung pada properti yang diberikan oleh parent, sehingga tidak berubah dengan sendirinya. `StatefulWidget` memiliki objek `State` yang bertahan antar rebuild, dan tampilannya dapat diperbarui dengan memanggil `setState()`. Pilih `StatelessWidget` untuk tampilan statis, seperti `InfoCard`, `ItemCard`, dan `MyHomePage` pada proyek ini. Pilih `StatefulWidget` ketika tampilan harus berubah akibat interaksi atau data, misalnya counter, input form, checkbox, atau animasi.

5. **Apa itu `BuildContext` dan mengapa penting pada Flutter? Bagaimana penggunaannya di dalam method `build`?**

   `BuildContext` adalah penanda lokasi sebuah widget di dalam widget tree. Melalui context, widget dapat mencari ancestor-nya dan membaca data dari pohon di atasnya. Pada proyek ini, `Theme.of(context)` dipakai untuk mengambil warna tema, `MediaQuery.of(context)` untuk mengambil lebar layar pada `InfoCard`, dan `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar` pada `ItemCard`. Context diberikan Flutter sebagai parameter `build(BuildContext context)`, sehingga setiap widget mengetahui posisinya di pohon dan dapat mengakses layanan milik ancestor-nya.

6. **Jelaskan konsep hot reload pada Flutter dan perbedaannya dengan hot restart! Kapan kita tidak bisa mengandalkan hot reload?**

   *Hot reload* menyuntikkan kode yang berubah ke Dart VM yang sedang berjalan lalu membangun ulang widget tree tanpa menghilangkan state aplikasi, sehingga prosesnya sangat cepat. *Hot restart* memuat ulang seluruh kode dan mereset state ke kondisi awal (`main()` dijalankan lagi), tetapi tidak perlu build ulang penuh. Hot reload tidak cukup dan kita harus melakukan hot restart ketika mengubah `main()`, mengubah nilai variabel global atau `static` yang sudah terinisialisasi, mengubah enum atau tipe, atau mengubah `StatelessWidget` menjadi `StatefulWidget`. Full restart (stop lalu run ulang) diperlukan ketika mengubah kode native Android/iOS, menambah dependensi pada `pubspec.yaml`, mengubah aset, atau mengubah konfigurasi dan izin platform.

---

# 3. AI Disclosure

### Tutorial 08 & Tugas 7
Saya menggunakan **Claude Code (Anthropic)** di VS Code sebagai bantuan selama mengerjakan tugas ini, dengan rincian sebagai berikut:

**Bagian yang dibantu AI:**
1. Menambahkan atribut `color` pada `ItemHomepage` dan menerapkan `item.color` pada `ItemCard`.
2. Menambahkan doc comment, tombol tambahan (View Skills dan View Education), `SingleChildScrollView`, serta `SnackBar` berwarna.

**Strategi prompting:** Saya memberikan instruksi yang jelas dan spesifik agar AI dapat membantu menyelesaikan tugas-tugas yang bersifat repetitif secara lebih efisien. Hasil yang diberikan kemudian diperiksa dan disesuaikan kembali agar tetap sesuai dengan kebutuhan proyek.

**Keterbatasan AI yang saya temukan**: AI awalnya tidak dapat menjalankan `flutter analyze` karena Flutter belum ada di `PATH`. Saya memasang Flutter dan memverifikasi hasilnya sendiri sebelum percaya pada klaim "tidak ada isu".
