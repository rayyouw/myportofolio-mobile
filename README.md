# Portfolio Mobile App - Rayhan Fairuz Aqram

**Nama** : Rayhan Fairuz Aqram <br>
**NPM** : 2506586186 <br>
**Kelas** : PBP D <br>
**Tautan GitHub** : [https://github.com/rayyouw/myportofolio-mobile](https://github.com/rayyouw/myportofolio-mobile) <br>

---

# 1. Documentation

### Deskripsi Proyek
Proyek ini adalah aplikasi mobile portofolio pribadi berbasis Flutter yang dikembangkan secara bertahap pada mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fakultas Ilmu Komputer, Universitas Indonesia. Aplikasi ini merupakan perluasan dari website portofolio Django ke platform mobile.

### Cara Menjalankan (Setup)
```bash
git clone https://github.com/rayyouw/myportofolio-mobile.git
cd myportofolio-mobile
flutter pub get
flutter analyze          # harus menampilkan "No issues found!"
flutter test             # menjalankan semua unit test dan widget test
flutter run -d chrome    # menjalankan aplikasi di browser (setara runserver pada Django)
```
Saat aplikasi berjalan, tekan `r` untuk hot reload dan `R` untuk hot restart.

### Struktur Proyek
```
lib/
├── main.dart                  # titik masuk dan tema aplikasi
├── models/education.dart      # model data Education
├── state/education_store.dart # ChangeNotifier berisi daftar Education
├── utils/                     # validators.dart dan formatters.dart
├── screens/                   # menu, project_form, education_form, education_list
└── widgets/                   # left_drawer, project_card, form_text_field, date_field
```

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

#### **Tutorial 09: Navigation, Layouts, Forms, and Input Elements**
- Membuat `LeftDrawer` (header, Home, Add Project) dan memasangnya pada halaman utama dan form.
- Membuat `ProjectFormPage` dengan `Form`, `GlobalKey<FormState>`, `TextFormField`, `DropdownButtonFormField`, validasi, dan `AlertDialog` ringkasan.
- Menambahkan navigasi `Navigator.push()` dari kartu Add Project dan `pushReplacement()` dari drawer.
- Refactor struktur: `screens/` untuk halaman dan `widgets/` untuk komponen (`ItemCard` dipindah ke `project_card.dart`).

#### **Tugas 8: Navigation, Layouts, Forms, and Input Elements**
Bagian portofolio yang dipilih adalah **Education**.
- **Form baru** `lib/screens/education_form.dart` (`StatefulWidget`, `Form`, `GlobalKey<FormState>`) dengan 7 input: institusi (`TextFormField`), jenjang (`DropdownButtonFormField`), jurusan, tanggal mulai dan selesai (`showDatePicker()`), IPK (keyboard angka), dan deskripsi.
- **Validasi** sesuai aturan model: wajib isi dan tidak boleh hanya spasi, batas panjang, IPK 0.00-4.00, tanggal wajib dipilih, dan tanggal selesai tidak boleh sebelum tanggal mulai.
- **Navigasi**: kartu *Add Education* di Home (`Navigator.push()`), serta opsi *Add Education* dan *View Education* di drawer. Drawer yang sama dipakai di semua halaman, dan opsi *Home* mengembalikan pengguna ke halaman utama.
- **Dialog ringkasan** menampilkan seluruh data setelah validasi lolos, dengan tombol *OK* dan *View List*.
- **Fitur tambahan**: checkbox "Still studying here" (menonaktifkan tanggal selesai), tombol *Reset*, konfirmasi *Discard changes?* saat keluar dengan input yang belum disimpan (`PopScope`), halaman daftar `EducationListPage` dengan hapus entri (state dibagikan melalui `ChangeNotifier`), dan validasi URL pada form Add Project.
- **Kualitas kode**: validasi dipisah ke `Validators` (dipakai oleh kedua form), widget bersama `FormTextField` dan `DateField`, serta doc comment pada kelas baru.
- **Pengujian**: `test/validators_test.dart` (unit test) dan `test/education_form_test.dart` (validasi, dialog, checkbox, konfirmasi keluar, navigasi kartu dan drawer). `flutter analyze` menampilkan *No issues found* dan `flutter test` lulus.

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

### Assignment 8

1. **Jelaskan perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Method mana yang membuka form dari kartu aksi? Bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama?**

   Navigator mengelola halaman (*route*) sebagai sebuah *stack*. `push()` menambahkan route baru di atas stack sehingga halaman sebelumnya tetap ada di bawahnya dan pengguna dapat kembali. `pop()` membuang route teratas dan menampilkan route di bawahnya. `pushReplacement()` mengganti route teratas dengan route baru, sehingga halaman lama hilang dari stack dan tidak bisa dikembalikan dengan tombol Back. Kartu aksi *Add Education* memakai `Navigator.push()` agar pengguna dapat kembali ke Home dengan tombol Back sistem. Opsi *Home* di drawer memakai `pushReplacement()` dengan `MaterialPageRoute(builder: (context) => MyHomePage())`. Form saat itu digantikan oleh halaman utama sehingga stack tidak menumpuk halaman setiap kali pengguna berpindah lewat drawer. Ini juga berguna di Chrome yang tidak punya tombol Back sistem.

2. **Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` menjaga struktur halaman tetap konsisten? Berikan satu contoh warna tema yang dipakai di lebih dari satu halaman.**

   `Scaffold` adalah kerangka standar setiap halaman: `appBar` untuk judul, `drawer` untuk menu samping, dan `body` untuk isi. Karena semua halaman (Home, Add Project, Add Education, daftar Education) memakai kerangka yang sama dan menyisipkan `LeftDrawer` yang sama, pengguna selalu menemukan navigasi di tempat yang sama dan perilaku menu tidak berubah. Perubahan menu cukup dilakukan di satu file. Contoh warna tema: `Colors.indigo` dipakai sebagai warna `AppBar` pada form Add Project, form Add Education, dan daftar Education, sebagai latar `DrawerHeader`, serta pada tombol *Save*. Halaman utama memakai `colorScheme.primary`, yang diturunkan dari seed indigo yang sama pada `ThemeData`.

3. **Mengapa layout ini dipilih untuk form? Jelaskan fungsi widget spasi dan scroll saat ruang layar terbatas.**

   Form disusun sebagai `Column` di dalam `SingleChildScrollView`, dan setiap input dibungkus `Padding` agar jaraknya seragam. `Column` cocok karena field ditumpuk dari atas ke bawah. `SingleChildScrollView` membuat seluruh field dan tombol *Save* tetap bisa dijangkau pada layar sempit atau saat keyboard terbuka. Tanpa itu, `Column` akan *overflow*. `keyboardDismissBehavior: onDrag` menutup keyboard ketika form digulir. `Padding` dan `SizedBox` memberi jarak agar input tidak menempel. Tombol *Reset* dan *Save* diletakkan dalam `Row` di tengah. Pada halaman daftar dipakai `ListView.builder` dengan padding bawah agar kartu terakhir tidak tertutup tombol *Add Education*.

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Save ditekan? Berikan satu contoh nilai yang ditolak form dan jelaskan mengapa memilih widget input atau tipe keyboard saja tidak cukup.**

   `GlobalKey<FormState>` yang dipasang pada `Form` memberi akses ke `FormState` dari luar widget, sehingga tombol Save dapat memanggil `validate()` dan `reset()`. Setiap `TextFormField` memiliki `validator` yang mengembalikan `null` jika nilai valid atau pesan error jika tidak. Ketika *Save* ditekan, `validate()` menjalankan semua `validator` dan menampilkan pesan error di bawah field yang bermasalah. Fungsi ini mengembalikan `true` hanya jika semuanya valid, dan baru saat itu data disimpan dan dialog ditampilkan. Contoh nilai yang ditolak: IPK `4.5` (di luar rentang 0.00-4.00), nama institusi `"   "` (hanya spasi), atau tanggal selesai yang lebih awal dari tanggal mulai. Memilih widget atau tipe keyboard saja tidak cukup karena itu hanya memengaruhi cara pengguna mengetik. Keyboard angka tetap mengizinkan `4.5` atau `9.99`, input dapat ditempel dari clipboard, dan pada web pengguna dapat mengetik apa saja. Aturan model hanya bisa dijamin oleh validasi eksplisit.

---

# 3. AI Disclosure

### Tutorial 08 & Tugas 7
Saya menggunakan **Claude Code (Anthropic)** di VS Code sebagai bantuan selama mengerjakan tugas ini, dengan rincian sebagai berikut:

**Bagian yang dibantu AI:**
1. Menambahkan atribut `color` pada `ItemHomepage` dan menerapkan `item.color` pada `ItemCard`.
2. Menambahkan doc comment, tombol tambahan (View Skills dan View Education), `SingleChildScrollView`, serta `SnackBar` berwarna.

**Strategi prompting:** Saya memberikan instruksi yang jelas dan spesifik agar AI dapat membantu menyelesaikan tugas-tugas yang bersifat repetitif secara lebih efisien. Hasil yang diberikan kemudian diperiksa dan disesuaikan kembali agar tetap sesuai dengan kebutuhan proyek.

**Keterbatasan AI yang saya temukan**: AI awalnya tidak dapat menjalankan `flutter analyze` karena Flutter belum ada di `PATH`. Saya memasang Flutter dan memverifikasi hasilnya sendiri sebelum percaya pada klaim "tidak ada isu".

### Tutorial 09 & Tugas 8
Saya kembali menggunakan **Claude Code (Anthropic)** di VS Code. Pada tugas ini saya meminta AI membuat rencana (*outline*) terlebih dahulu berdasarkan rubrik, memilih bagian *Education* dan fitur tambahan, baru kemudian meminta implementasi.

**Bagian yang dibantu AI:**
1. Tutorial 09: `LeftDrawer`, `ProjectFormPage`, navigasi kartu dan drawer, serta refactor ke `screens/` dan `widgets/`.
2. Tugas 8: `EducationFormPage`, `EducationListPage`, model `Education`, `EducationStore` (`ChangeNotifier`), `Validators`, `FormTextField`, dan `DateField`.
3. Fitur tambahan: checkbox "Still studying here", tombol Reset, konfirmasi keluar dengan `PopScope`, dan validasi URL pada form project.
4. Unit test dan widget test, serta draf jawaban README.

**Strategi prompting:** (1) Saya menempelkan instruksi tutorial dan halaman tugas, lalu meminta outline untuk mencapai nilai 4/4 pada setiap kriteria rubrik. (2) Saya menentukan pilihan (section Education, fitur ekstra maksimal, commit langsung di `main`, jangan di-*push* dulu). (3) Saya meminta implementasi lengkap beserta pengujian, lalu memeriksa hasilnya.

**Keterbatasan AI dan perbaikan yang ditemukan:**
- Pada sesi sebelumnya AI mengira Flutter tidak tersedia karena tidak ada di `PATH` terminal. Kali ini AI menemukan Flutter di `C:\src\flutter`, sehingga `flutter analyze` dan `flutter test` benar-benar dijalankan.
- Widget test menemukan *overflow* 78 piksel pada `DrawerHeader` bawaan tutorial ketika teks membungkus. Perbaikannya adalah `FittedBox` untuk judul dan `maxLines: 2` untuk subjudul.
- Tutorial memakai `onChanged` untuk menyimpan nilai, sehingga `reset()` tidak mengosongkan variabel. Kode diganti dengan `TextEditingController` dan `clear()` saat form direset.
- `AppBar` yang memiliki `drawer` menampilkan ikon menu, bukan tombol Back. Karena itu kembali ke Home dilakukan lewat tombol Back sistem atau opsi *Home* di drawer.
- Tampilan sesungguhnya (bentuk date picker, tampilan di layar ponsel) tetap perlu diuji manual di Chrome atau emulator, karena AI hanya menguji lewat widget test.
- Draf jawaban refleksi saya baca ulang dan sesuaikan dengan kode yang benar-benar ada di proyek.
