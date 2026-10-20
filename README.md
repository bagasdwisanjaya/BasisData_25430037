# Praktikum Basis Data - Repositori Proyek: basisdata-25430037

Repositori ini berisi seluruh artefak pekerjaan praktikum mata kuliah **Basis Data (Semester 3)** Program Studi Ilmu Komputer, Fakultas Ilmu Komputer, Universitas Muhammadiyah Metro, tahun akademik 2026/2027. Praktikum ini berbasis proyek dan disinkronkan dengan Standar Kompetensi Kerja Nasional Indonesia (SKKNI) Bidang Data Management.

---

## Identitas Praktikan

- **Nama Mahasiswa** : Bagas Dwi Sanjaya
- **NIM** : 25430037
- **Kelas** : Kelas B, Ilmu Komputer - Semester 3
- **Program Studi** : Ilmu Komputer
- **Fakultas** : Fakultas Ilmu Komputer
- **Perguruan Tinggi** : Universitas Muhammadiyah Metro
- **Dosen Pengampu** : Dedi Irawan, S.Kom., M.T.I.
- **Tahun Akademik** : 2026/2027

---

## Identitas Proyek

- **Tema Proyek** : **Toko Daring** *(penugasan proyek praktikum)*
- **Kode Tema** : `toko`
- **Nama Organisasi Fiktif** : **Toko Daring Sentosa BDS** *(memuat inisial nama: BDS)*
- **Lingkup Layanan Organisasi** :
  > **Toko Daring Sentosa BDS** adalah platform ritel daring berbasis web yang melayani pemesanan, pembelian, dan pengiriman aneka perlengkapan komputasi, aksesori teknologi, serta alat penunjang belajar mahasiswa. Lingkup layanan organisasi mencakup: (1) pengelolaan katalog produk terstruktur lengkap dengan kategori, harga satuan, dan batas minimum stok; (2) pengelolaan keranjang belanja dan pemesanan daring oleh pelanggan terdaftar maupun pembeli umum; (3) verifikasi pembayaran transaksi; serta (4) pemrosesan pemenuhan pesanan dan pelacakan pengiriman kurir hingga ke alamat tujuan pelanggan. Lingkup proses bisnis ini menjadi fondasi penyusunan dokumen kebutuhan data pada Modul 2 hingga implementasi basis data relasional utuh pada modul-modul berikutnya.

---

## Standar Penamaan Objek dan Lingkungan Kerja

Mengacu pada *Tabel P.3 Standar Penamaan Berkas dan Objek Basis Data* pada Buku Praktikum:

| Objek | Standar Penamaan | Implementasi di Proyek Ini |
| --- | --- | --- |
| **Repositori GitHub** | `basisdata-<NIM>` | `basisdata-25430037` |
| **Basis Data Praktik (Kopma)** | `kopma_<3d>` | `kopma_037` |
| **Basis Data Proyek** | `<kode_tema>_<3d>` | `toko_037` |
| **Akun Kerja Praktik** | `mhs_<3d>` | `mhs_037` |
| **Akun Tamu Praktik** | `tamu_<3d>` | `tamu_037` |
| **Akun Pengembang Proyek** | `dev_<3d>` | `dev_037` |
| **Skrip SQL Lingkungan** | `p01_lingkungan_<NIM>.sql` | `p01_lingkungan_25430037.sql` |

---

## Struktur Direktori Repositori

```text
basisdata-25430037/
├── .gitignore                          # Konfigurasi pengabaian berkas kredensial & sistem
├── README.md                           # Dokumentasi identitas praktikan dan proyek
├── p01_lingkungan_25430037.sql         # Skrip DDL lingkungan idempotent Modul 1
├── p02_kebutuhan_data_kopma_25430037.md # Analisis kebutuhan data studi kasus Kopma Modul 2
├── p02_kebutuhan_data_25430037.md       # Dokumen kebutuhan data proyek Toko Daring Modul 2
├── p03_erd_kopma_25430037.drawio       # Berkas sumber diagram ERD Kopma Modul 3
├── p03_erd_kopma_25430037.png          # Visualisasi gambar diagram ERD Kopma Modul 3
├── p03_erd_25430037.drawio             # Berkas sumber diagram ERD Proyek Toko Daring Modul 3
├── p03_erd_25430037.png                # Visualisasi gambar diagram ERD Proyek Toko Daring Modul 3
├── p05_ddl_kopma_25430037.sql          # Skrip DDL fisik & penegakan constraint Kopma Modul 5
├── p05_ddl_25430037.sql                # Skrip DDL fisik proyek Toko Daring (P=2) Modul 5
└── laporan/                            # Berkas laporan per pertemuan
    ├── p01_laporan_25430037.md         # Laporan praktikum Pertemuan 1
    ├── p02_laporan_25430037.md         # Laporan praktikum Pertemuan 2
    ├── p03_laporan_25430037.md         # Laporan praktikum Pertemuan 3
    ├── p05_laporan_25430037.md         # Laporan praktikum Pertemuan 5
    └── img/                            # Tangkapan layar bukti pelaksanaan praktikum
```

---

## Petunjuk Penggunaan Skrip SQL Lingkungan

Skrip `p01_lingkungan_25430037.sql` dirancang bersifat **idempotent**, yaitu menggunakan klausa `IF NOT EXISTS` sehingga aman dieksekusi berkali-kali tanpa menghasilkan galat (*error*).

### 1. Menjalankan Skrip melalui CLI (Command Prompt / XAMPP Shell)

Pastikan layanan MariaDB pada XAMPP Control Panel sudah berstatus **Running** di port 3306.

```bash
# Jalankan skrip sebagai akun administrator (root)
mysql -u root -p < p01_lingkungan_25430037.sql
```

### 2. Menguji Akses Akun Pengembang Proyek (`dev_037`)

Masuk ke MariaDB menggunakan akun pengembang proyek:

```bash
mysql -u dev_037 -p
```

Uji hak akses untuk membuktikan prinsip *Least Privilege*:

```sql
-- Memeriksa basis data yang dapat diakses (hanya information_schema dan toko_037)
SHOW DATABASES;

-- Berhasil membuka basis data proyek:
USE toko_037;

-- Ditolak membuka basis data latihan Kopma (menghasilkan ERROR 1044):
USE kopma_037;
```

### 3. Menjalankan Skrip DDL Modul 5 (Kopma dan Toko Daring)

Skrip DDL Modul 5 bersifat idempoten dan dapat dieksekusi menggunakan akun masing-masing:

```bash
# Menjalankan DDL Kopma menggunakan akun mhs_037
mysql -u mhs_037 -p kopma_037 < p05_ddl_kopma_25430037.sql

# Menjalankan DDL Proyek Toko Daring menggunakan akun dev_037
mysql -u dev_037 -p toko_037 < p05_ddl_25430037.sql
```

---
*Dikembangkan oleh Bagas Dwi Sanjaya (NIM 25430037) untuk Praktikum Basis Data Semester 3.*
