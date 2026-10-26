# healthybite

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# HealthyBite 🌿

HealthyBite adalah aplikasi mobile berbasis Flutter yang membantu pengguna menemukan berbagai resep makanan. Aplikasi ini dirancang untuk pengguna yang ingin mencari inspirasi makanan, termasuk untuk kebutuhan bulking maupun diet.

Data resep diperoleh dari [TheMealDB API](https://www.themealdb.com/api.php).

## ✨ Fitur Utama

- **Daftar Resep:** Menampilkan berbagai resep makanan dari API.
- **Pencarian Resep:** Membantu pengguna menemukan resep berdasarkan kata kunci.
- **Kategori Tujuan:** Menyediakan pilihan kategori Semua, Bulking, dan Diet untuk membantu eksplorasi resep.
- **Detail Resep:** Menampilkan informasi resep, bahan-bahan, dan petunjuk memasak yang tersedia.
- **Indikator Loading:** Memberikan informasi saat data sedang dimuat.
- **Penanganan Error:** Menampilkan kondisi ketika data gagal dimuat.
- **Refresh Data:** Memungkinkan pengguna memuat ulang daftar resep.

> **Catatan:** Kategori Bulking dan Diet merupakan bantuan pencarian inspirasi makanan, bukan rekomendasi gizi yang terverifikasi. Kesesuaian resep dengan kebutuhan nutrisi pengguna tetap perlu diperiksa secara terpisah.

## 🛠️ Teknologi yang Digunakan

- **Flutter** — framework untuk pengembangan aplikasi mobile.
- **Dart** — bahasa pemrograman yang digunakan Flutter.
- **HTTP package** — untuk melakukan permintaan HTTP ke API.
- **TheMealDB API** — sumber data resep makanan.

## 📂 Struktur Proyek

```text
healthybite/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── recipe.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   └── detail_page.dart
│   └── services/
│       └── recipe_service.dart
├── test/
├── web/
├── windows/
├── linux/
├── macos/
├── pubspec.yaml
└── README.md
```

**Catatan struktur:** Implementasi utama aplikasi saat ini berada di `lib/main.dart`. Folder `models`, `pages`, dan `services` juga tersedia sebagai berkas terpisah. Pastikan struktur dan pembagian kode diselaraskan jika implementasi aplikasi dipisahkan ke berkas-berkas tersebut.

## 🚀 Cara Menjalankan Aplikasi

### Persyaratan

- Flutter SDK
- Dart SDK yang sesuai dengan versi Flutter
- Visual Studio Code atau editor lain
- Emulator Android atau perangkat yang terhubung, jika menjalankan aplikasi di Android

### Langkah-langkah

1. Clone repository:

   ```bash
   git clone https://github.com/riskarjby/healthybite.git
   ```

2. Masuk ke direktori proyek:

   ```bash
   cd healthybite
   ```

3. Unduh dependensi:

   ```bash
   flutter pub get
   ```

4. Periksa perangkat yang tersedia:

   ```bash
   flutter devices
   ```

5. Jalankan aplikasi:

   ```bash
   flutter run
   ```

### Menjalankan Pengujian

Untuk menjalankan pengujian proyek, gunakan:

```bash
flutter test
```

Untuk memeriksa potensi masalah pada kode:

```bash
flutter analyze
```

## 🌐 Sumber Data API

HealthyBite menggunakan TheMealDB API untuk mengambil data resep makanan.

Dokumentasi API: https://www.themealdb.com/api.php

Ketersediaan data bergantung pada respons dan koneksi ke layanan API.

## 🎓 Informasi Proyek

HealthyBite dikembangkan sebagai proyek praktikum mata kuliah **Pemrograman Mobile**.

- **Nama Proyek:** HealthyBite
- **Platform:** Mobile
- **Framework:** Flutter
- **Bahasa Pemrograman:** Dart
- **Sumber Data:** TheMealDB API

## 📄 Lisensi

Proyek ini dibuat untuk keperluan pembelajaran. Ketentuan penggunaan data dan aset dari layanan pihak ketiga mengikuti ketentuan masing-masing penyedia.

