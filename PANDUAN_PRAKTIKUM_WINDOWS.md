# Panduan Praktik Mandiri Basis Data di Windows

Panduan ini disusun langkah demi langkah khusus untuk pengguna sistem operasi **Windows** dengan menggunakan **XAMPP**, **Command Prompt / XAMPP Shell**, **Browser**, dan **VS Code**.

Seluruh tangkapan layar (*screenshot*) disimpan ke dalam folder:
`laporan/img/`

---

## Persiapan Alat di Windows

1. **Buka XAMPP Control Panel** (klik kanan *Run as Administrator* jika perlu).
2. Pastikan modul **Apache** dan **MySQL** berstatus **Running** (tombol *Start* sudah diklik dan berwarna hijau).
3. Untuk membuka terminal MariaDB paling cepat dan tanpa perlu mengatur `PATH` Windows:
   - Pada **XAMPP Control Panel**, klik tombol **Shell** di panel sebelah kanan.
   - Jendela terminal hitam akan terbuka dengan direktori aktif XAMPP.

> **Tips Mengambil Screenshot di Windows:**
> Tekan kombinasi tombol **`Windows + Shift + S`**, lalu seret mouse untuk memilih area jendela terminal/browser. Buka aplikasi Paint atau klik notifikasi Snipping Tool, lalu simpan (*Save As*) format **PNG** langsung ke dalam folder:
> `basis_data(clien)\laporan\img\`

---

## Modul 01: Langkah Praktik dan Pengambilan Screenshot

---

### Langkah 1: Cek Versi MariaDB dan User Aktif

**Nama File Screenshot:** `p01_version_user.png`

1. Di XAMPP Shell, masuk ke MariaDB sebagai root:

   ```cmd
   mysql -u root
   ```

2. Jalankan kueri:

   ```sql
   SELECT VERSION(), CURRENT_USER();
   ```

3. **Ambil Screenshot:**
   - Sorot jendela terminal yang menampilkan output tabel versi MariaDB (misal: `10.4.32-MariaDB`) dan `root@localhost`.
   - Simpan dengan nama: `laporan/img/p01_version_user.png`.

---

### Langkah 2: Cek Variabel SQL Mode (Strict Mode)

**Nama File Screenshot:** `p01_sql_mode.png`

1. Masih di terminal MariaDB yang sama, jalankan:

   ```sql
   SELECT @@sql_mode;
   ```

2. **Ambil Screenshot:**
   - Sorot jendela terminal yang menampilkan isi `@@sql_mode` (terdapat `STRICT_TRANS_TABLES`, `NO_ENGINE_SUBSTITUTION`, dll).
   - Simpan dengan nama: `laporan/img/p01_sql_mode.png`.

---

### Langkah 3: Eksekusi Skrip Penyiapan Database dan Akun

Jalankan file SQL yang sudah disiapkan agar database dan semua user terbuat secara otomatis:

1. Keluar dari mysql (ketik `exit;`), lalu di XAMPP Shell jalankan perintah berikut (sesuaikan path folder proyek Anda):

   ```cmd
   mysql -u root < "C:\path\ke\basis_data(clien)\p01_lingkungan_25430037.sql"
   ```

   *Atau* jika masih di dalam MariaDB (`MariaDB [(none)]>`):

   ```sql
   SOURCE C:/path/ke/basis_data(clien)/p01_lingkungan_25430037.sql;
   ```

2. Perintah ini akan membuat:
   - Database `kopma_037` dan `toko_037`
   - User `mhs_037` (password: `MhsKopma#2026`)
   - User `tamu_037` (password: `TamuKopma#2026`)
   - User `dev_037` (password: `TokoDev#25430037`)

---

### Langkah 4: Uji Isolasi Akun Mahasiswa (`mhs_037`)

**Nama File Screenshot:** `p01_show_databases_mhs.png`

1. Di XAMPP Shell, login sebagai akun mahasiswa:

   ```cmd
   mysql -u mhs_037 -p
   ```

2. Masukkan kata sandi: `MhsKopma#2026` lalu tekan Enter.
3. Jalankan kueri:

   ```sql
   SHOW DATABASES;
   ```

4. **Ambil Screenshot:**
   - Perhatikan bahwa yang muncul hanya `information_schema` dan `kopma_037` (database `toko_037` tidak terlihat).
   - Simpan dengan nama: `laporan/img/p01_show_databases_mhs.png`.
5. Keluar: ketik `exit;`.

---

### Langkah 5: Uji Isolasi Akun Pengembang (`dev_037`)

**Nama File Screenshot:** `p01_show_databases_dev.png`

1. Di XAMPP Shell, login sebagai akun developer:

   ```cmd
   mysql -u dev_037 -p
   ```

2. Masukkan kata sandi: `TokoDev#25430037` lalu tekan Enter.
3. Jalankan kueri:

   ```sql
   SHOW DATABASES;
   ```

4. **Ambil Screenshot:**
   - Perhatikan bahwa yang muncul hanya `information_schema` dan `toko_037` (database `kopma_037` tidak terlihat).
   - Simpan dengan nama: `laporan/img/p01_show_databases_dev.png`.
5. Keluar: ketik `exit;`.

---

### Langkah 6: Pemicuan Galat 1044 (Access Denied to Database)

**Nama File Screenshot:** `p01_galat_1044.png`

1. Login kembali sebagai akun `mhs_037`:

   ```cmd
   mysql -u mhs_037 -p
   ```

   (Password: `MhsKopma#2026`)

2. Coba buat database baru atau akses database lain:

   ```sql
   CREATE DATABASE coba_database;
   ```

   *Atau:*

   ```sql
   USE toko_037;
   ```

3. Server MariaDB akan menolak dan menampilkan pesan:
   `ERROR 1044 (42000): Access denied for user 'mhs_037'@'localhost' to database 'coba_database'`
4. **Ambil Screenshot:**
   - Tangkap pesan error merah/putih tersebut di terminal.
   - Simpan dengan nama: `laporan/img/p01_galat_1044.png`.
5. Keluar: ketik `exit;`.

---

### Langkah 7: Pemicuan Galat 1142 (Command Denied for Table)

**Nama File Screenshot:** `p01_galat_1142.png`

1. Login sebagai akun tamu `tamu_037`:

   ```cmd
   mysql -u tamu_037 -p
   ```

   (Password: `TamuKopma#2026`)

2. Pilih database koperasi:

   ```sql
   USE kopma_037;
   ```

3. Coba buat tabel baru (akun tamu hanya memiliki hak `SELECT` baca saja):

   ```sql
   CREATE TABLE uji_tabel (id INT);
   ```

4. Server MariaDB akan menolak dan menampilkan pesan:
   `ERROR 1142 (42000): CREATE command denied to user 'tamu_037'@'localhost' for table 'uji_tabel'`
5. **Ambil Screenshot:**
   - Tangkap pesan error tersebut di terminal.
   - Simpan dengan nama: `laporan/img/p01_galat_1142.png`.
6. Keluar: ketik `exit;`.

---

### Langkah 8: Konfigurasi Keamanan phpMyAdmin (Auth Type Cookie)

**Nama File Screenshot:** `p01_phpmyadmin_cookie.png`

1. Buka File Explorer di Windows, tuju ke folder:
   `C:\xampp\phpMyAdmin\`
2. Buka berkas `config.inc.php` menggunakan Notepad atau VS Code.
3. Cari baris:

   ```php
   $cfg['Servers'][$i]['auth_type'] = 'config';
   ```

4. Ubah menjadi:

   ```php
   $cfg['Servers'][$i]['auth_type'] = 'cookie';
   ```

   *(Pastikan baris `$cfg['Servers'][$i]['user']` dikosongkan `''`)*.
5. Simpan file `config.inc.php`.
6. Buka browser (Chrome / Edge / Firefox) dan buka URL:
   `http://localhost/phpmyadmin/`
7. phpMyAdmin sekarang akan meminta Username dan Password (form login aman).
8. **Ambil Screenshot:**
   - Tangkap halaman form login phpMyAdmin di peramban web Anda.
   - Simpan dengan nama: `laporan/img/p01_phpmyadmin_cookie.png`.

---

### Langkah 9: Git Push ke GitHub

**Nama File Screenshot:** `p01_git_push.png`

1. Buka Git Bash atau CMD di dalam folder proyek Anda (`basis_data(clien)`).
2. Periksa status dan lakukan push:

   ```cmd
   git status
   git add .
   git commit -m "p01: penyiapan lingkungan dan skrip basis data"
   git push origin main
   ```

3. **Ambil Screenshot:**
   - Tangkap layar terminal yang memperlihatkan proses pengunggahan objek Git (`Writing objects: 100% ... To https://github.com/...`).
   - Simpan dengan nama: `laporan/img/p01_git_push.png`.

---

## Modul 02: Pengambilan Screenshot Dokumen Analisis

Sesuai panduan Buku Praktikum, bukti pekerjaan Modul 02 adalah visualisasi dari dokumen kebutuhan data proyek Toko Daring Sentosa BDS.

Cara termudah dan paling rapi di Windows:

1. Buka folder proyek di **VS Code**.
2. Buka berkas: `p02_kebutuhan_data_25430037.md`.
3. Tekan tombol **`Ctrl + Shift + V`** di VS Code untuk membuka tampilan pratinjau (*Markdown Preview*).

---

### Langkah 10: Formulasi Parameter Personalisasi $P$

**Nama File Screenshot:** `p02_parameter_p.png`

1. Pada Markdown Preview `p02_kebutuhan_data_25430037.md`, scroll ke bagian:
   **1.2 Parameter Personalisasi Berbasis NIM**
2. **Ambil Screenshot:**
   - Tangkap kotak rumus:
     $$P = (37 \pmod 9) + 1 = 1 + 1 = 2$$
     beserta daftar batasan bisnisnya ($P+2 = 4$ item unik, diskon $2\%$, 50 transaksi/hari).
   - Simpan dengan nama: `laporan/img/p02_parameter_p.png`.

---

### Langkah 11: Tabel Proses Bisnis Toko Daring

**Nama File Screenshot:** `p02_tabel_pb_toko.png`

1. Scroll ke bagian:
   **2. Identifikasi Proses Bisnis Toko Daring Sentosa BDS**
2. **Ambil Screenshot:**
   - Tangkap tabel ringkasan 6 proses bisnis (PB-01 Manajemen Akun hingga PB-06 Penyelesaian Pesanan).
   - Simpan dengan nama: `laporan/img/p02_tabel_pb_toko.png`.

---

### Langkah 12: Matriks Keterlacakan Hak Akses CRUD

**Nama File Screenshot:** `p02_matriks_crud_toko.png`

1. Scroll ke bagian:
   **4. Matriks Keterlacakan CRUD (Create, Read, Update, Delete)**
2. **Ambil Screenshot:**
   - Tangkap tabel matriks CRUD yang menghubungkan 7 entitas (`pengguna`, `kategori`, `produk`, `pesanan`, dll.) dengan 6 proses bisnis.
   - Simpan dengan nama: `laporan/img/p02_matriks_crud_toko.png`.

---

### Langkah 13: Kamus Data Teknis Proyek

**Nama File Screenshot:** `p02_kamus_data_toko.png`

1. Scroll ke bagian:
   **5. Kamus Data (Data Dictionary) Proyek**
2. **Ambil Screenshot:**
   - Tangkap tabel kamus data (misalnya bagian entitas transaksi `pesanan` dan `item_pesanan` lengkap dengan tipe data dan batasannya).
   - Simpan dengan nama: `laporan/img/p02_kamus_data_toko.png`.

---

## Langkah Terakhir: Menghubungkan Gambar ke Laporan

Setelah Anda selesai mengambil ke-12 gambar dan menyimpannya di folder `laporan/img/`:

1. Buka berkas `laporan/p01_laporan_25430037.md`:
   - Pastikan tag gambar tertulis: `![Keterangan](img/nama_file.png)`
   - Isi URL repositori GitHub dan Commit Hash Anda pada tabel Bab 10.
2. Buka berkas `laporan/p02_laporan_25430037.md`:
   - Pastikan tag gambar tertulis:
     - `![Perhitungan Parameter Personalisasi P](img/p02_parameter_p.png)`
     - `![Daftar Proses Bisnis Toko Daring](img/p02_tabel_pb_toko.png)`
     - `![Matriks CRUD Toko Daring Sentosa BDS](img/p02_matriks_crud_toko.png)`
     - `![Kamus Data Toko Daring Sentosa BDS](img/p02_kamus_data_toko.png)`
   - Isi URL GitHub Anda pada tabel Bab 10.
3. Jalankan `git add .`, `git commit -m "docs: perbarui bukti screenshot praktikum"`, lalu `git push origin main`.
