# Panduan Praktikum Mandiri Modul 1 dan Modul 2 Basis Data

Panduan lengkap ini menggabungkan seluruh langkah kerja, instruksi praktis di Windows, tata cara pembuatan basis data dan akun pengguna, hingga penyusunan dokumen kebutuhan data dan pengambilan tangkapan layar (*screenshot*) untuk **Modul 01** dan **Modul 02**.

---

## Identitas Praktikan dan Proyek

| Komponen | Rincian Mahasiswa |
| --- | --- |
| **Nama Lengkap** | Bagas Dwi Sanjaya |
| **NIM** | 25430037 |
| **Kelas** | Kelas B, S1 Ilmu Komputer |
| **Semester / Tahun Akademik** | 3 (Tiga) / 2026/2027 |
| **Perguruan Tinggi** | Universitas Muhammadiyah Metro |
| **Dosen Pengampu** | Dedi Irawan, S.Kom., M.T.I. |
| **Tema Proyek Mandiri** | Toko Daring (Toko Daring Sentosa BDS) |
| **Digit Unik NIM** | 3 Digit Terakhir: `037` \| 2 Digit Terakhir: `37` |
| **Parameter Personalisasi** | $P = (37 \pmod 9) + 1 = 1 + 1 = 2$ |

---

## Bagian 1: Persiapan Lingkungan di Windows

Sebelum memulai, pastikan perangkat lunak XAMPP dan Git sudah terpasang di sistem operasi Windows Anda.

### 1.1 Menjalankan Layanan XAMPP

1. Buka aplikasi **XAMPP Control Panel** (disarankan klik kanan lalu pilih *Run as administrator*).
2. Cari baris **Apache** dan klik tombol **Start**.
3. Cari baris **MySQL** dan klik tombol **Start**.
4. Pastikan latar belakang nama modul berubah warna menjadi **hijau** yang menandakan layanan sedang berjalan (*Running*) pada port standar (Apache di port 80/443, MySQL di port 3306).

### 1.2 Membuka Terminal XAMPP Shell

Cara paling cepat, praktis, dan bebas galat untuk membuka baris perintah MariaDB di Windows tanpa perlu mengatur *System Environment Variables*:

1. Di panel sebelah kanan **XAMPP Control Panel**, klik tombol **Shell**.
2. Jendela konsol Windows (CMD) akan terbuka dengan direktori aktif XAMPP.
3. Di konsol ini, seluruh perintah seperti `mysql`, `mysqldump`, dan `php` langsung dapat dipanggil.

### 1.3 Cara Mengambil dan Menyimpan Tangkapan Layar di Windows

Setiap langkah percobaan yang memerlukan bukti foto wajib disimpan ke dalam folder:
`basis_data(clien)\laporan\img\`

**Cara Cepat Snipping Tool Windows:**

1. Tekan kombinasi tombol **`Windows + Shift + S`** secara bersamaan.
2. Layar akan sedikit meredup. Seret (*drag*) kursor mouse untuk memilih area jendela konsol atau browser.
3. Klik jendela pratinjau yang muncul di pojok kanan bawah layar.
4. Klik tombol **Save** (atau tekan **`Ctrl + S`**).
5. Arahkan folder penyimpanan ke: `...\basis_data(clien)\laporan\img\`
6. Beri nama file persis sesuai nama yang ditentukan (ekstensi `.png`).

---

## Bagian 2: Panduan Lengkap Modul 01

Modul 01 berfokus pada persiapan RDBMS MariaDB 10.4, konfigurasi mode SQL ketat, pembuatan basis data, pembagian hak akses (*privileges*), pengujian galat otorisasi, pengamanan phpMyAdmin, dan version control Git.

---

### Langkah 1.1: Memeriksa Versi MariaDB dan User Aktif

**Target Screenshot:** `laporan/img/p01_version_user.png`

1. Di XAMPP Shell, hubungkan ke server MariaDB sebagai akun administrator utama (`root`):

   ```cmd
   mysql -u root
   ```

2. Jalankan kueri berikut di prompt `MariaDB [(none)]>`:

   ```sql
   SELECT VERSION(), CURRENT_USER();
   ```

3. **Penjelasan:** Kueri ini memverifikasi bahwa server MariaDB versi 10.4 sedang berjalan dan sesi Anda terautentikasi sebagai pengguna `root@localhost`.

4. **Tindakan:** Ambil tangkapan layar tabel output terminal tersebut, lalu simpan sebagai `laporan/img/p01_version_user.png`.

---

### Langkah 1.2: Memeriksa Variabel SQL Mode (Strict Mode)

**Target Screenshot:** `laporan/img/p01_sql_mode.png`

1. Masih di terminal MariaDB, jalankan:

   ```sql
   SELECT @@sql_mode;
   ```

2. **Penjelasan:** Pastikan output memuat nilai `STRICT_TRANS_TABLES` dan `NO_ENGINE_SUBSTITUTION`. Mode ketat ini menjamin bahwa jika ada data yang tidak valid (misal teks melebihi panjang kolom atau tipe data tidak cocok), MariaDB akan langsung menolak transaksi dan memunculkan galat alih-alih memotong data secara diam-diam (*silent truncation*).

3. **Tindakan:** Ambil tangkapan layar output tersebut dan simpan sebagai `laporan/img/p01_sql_mode.png`.

---

### Langkah 1.3: Tata Cara Pembuatan Database dan Akun Pengguna

Bagian ini menjelaskan logika di balik pembuatan basis data dan akun pengguna berorientasi proyek.

#### A. Penjelasan Perintah Pembuatan Basis Data

Kita membuat dua basis data:

1. `kopma_037`: Untuk studi kasus Koperasi Mahasiswa.
2. `toko_037`: Untuk proyek mandiri Toko Daring Sentosa BDS.

Kueri SQL yang digunakan:

```sql
CREATE DATABASE IF NOT EXISTS `kopma_037`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `toko_037`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

- **Mengapa menggunakan `IF NOT EXISTS`?** Agar skrip bersifat idempoten (jika database sudah ada, perintah tidak akan menghasilkan galat kegagalan).
- **Mengapa menggunakan `utf8mb4`?** Karakter set `utf8mb4` adalah standar internasional yang mendukung seluruh karakter Unicode 4-byte penuh, termasuk aksara asing dan karakter emoji modern.
- **Mengapa `utf8mb4_unicode_ci`?** Menjamin aturan pengurutan (*sorting*) dan pencocokan teks yang akurat secara linguistik serta *case-insensitive* (`A` sama dengan `a`).

#### B. Penjelasan Perintah Pembuatan Pengguna (User Accounts)

Prinsip keamanan *Principle of Least Privilege* mewajibkan kita memisahkan akun pengguna sesuai tanggung jawabnya:

```sql
-- 1. Akun Mahasiswa untuk praktikum Koperasi (hak kelola kopma_037)
CREATE USER IF NOT EXISTS 'mhs_037'@'localhost' IDENTIFIED BY 'MhsKopma#2026';

-- 2. Akun Tamu untuk hak baca saja (SELECT)
CREATE USER IF NOT EXISTS 'tamu_037'@'localhost' IDENTIFIED BY 'TamuKopma#2026';

-- 3. Akun Pengembang untuk proyek Toko Daring (hak kelola toko_037)
CREATE USER IF NOT EXISTS 'dev_037'@'localhost' IDENTIFIED BY 'TokoDev#25430037';
```

#### C. Penjelasan Perintah Pemberian Hak Akses (GRANT Privileges)

```sql
-- Berikan hak penuh DDL dan DML pada kopma_037 kepada mhs_037
GRANT ALL PRIVILEGES ON `kopma_037`.* TO 'mhs_037'@'localhost';

-- Berikan HANYA hak baca (SELECT) pada kopma_037 kepada tamu_037
GRANT SELECT ON `kopma_037`.* TO 'tamu_037'@'localhost';

-- Berikan hak penuh DDL dan DML pada toko_037 kepada dev_037
GRANT ALL PRIVILEGES ON `toko_037`.* TO 'dev_037'@'localhost';

-- Segarkan hak akses di memori server
FLUSH PRIVILEGES;
```

#### D. Cara Menjalankan Skrip Pembuatan Database Secara Otomatis

Anda tidak perlu mengetik perintah-perintah di atas satu per satu. File [p01_lingkungan_25430037.sql](file:///home/rizky/Documents/basis_data(clien)/p01_lingkungan_25430037.sql) telah dipersiapkan.

**Cara Eksekusi di XAMPP Shell:**

1. Keluar dari MariaDB jika masih di dalam prompt: ketik `exit;`.
2. Jalankan perintah impor berikut (ganti path sesuai lokasi folder proyek di komputer Anda):

   ```cmd
   mysql -u root < "C:\path\ke\basis_data(clien)\p01_lingkungan_25430037.sql"
   ```

   *Atau jika Anda sedang berada di prompt `MariaDB [(none)]>`:*

   ```sql
   SOURCE C:/path/ke/basis_data(clien)/p01_lingkungan_25430037.sql;
   ```

---

### Langkah 1.4: Menguji Bukti Isolasi Akun Mahasiswa (`mhs_037`)

**Target Screenshot:** `laporan/img/p01_show_databases_mhs.png`

1. Di XAMPP Shell, lakukan login sebagai akun mahasiswa:

   ```cmd
   mysql -u mhs_037 -p
   ```

2. Masukkan kata sandi: `MhsKopma#2026` lalu Enter.
3. Jalankan perintah:

   ```sql
   SHOW DATABASES;
   ```

4. **Amati:** Server MariaDB menyembunyikan database lain dan hanya menampilkan `information_schema` dan `kopma_037`.
5. **Tindakan:** Ambil screenshot dan simpan sebagai `laporan/img/p01_show_databases_mhs.png`.
6. Ketik `exit;` untuk keluar.

---

### Langkah 1.5: Menguji Bukti Isolasi Akun Pengembang (`dev_037`)

**Target Screenshot:** `laporan/img/p01_show_databases_dev.png`

1. Di XAMPP Shell, lakukan login sebagai akun developer:

   ```cmd
   mysql -u dev_037 -p
   ```

2. Masukkan kata sandi: `TokoDev#25430037` lalu Enter.
3. Jalankan perintah:

   ```sql
   SHOW DATABASES;
   ```

4. **Amati:** Server hanya menampilkan `information_schema` dan `toko_037` (database koperasi tersembunyi).
5. **Tindakan:** Ambil screenshot dan simpan sebagai `laporan/img/p01_show_databases_dev.png`.
6. Ketik `exit;` untuk keluar.

---

### Langkah 1.6: Memicu dan Mendokumentasikan Galat 1044

**Target Screenshot:** `laporan/img/p01_galat_1044.png`

1. Login kembali sebagai akun mahasiswa:

   ```cmd
   mysql -u mhs_037 -p
   ```

   (Password: `MhsKopma#2026`)

2. Coba buat database baru atau akses database proyek lain:

   ```sql
   CREATE DATABASE coba_database;
   ```

3. **Pesan Galat:** Server menolak dengan pesan:
   `ERROR 1044 (42000): Access denied for user 'mhs_037'@'localhost' to database 'coba_database'`
4. **Penjelasan:** Galat 1044 adalah galat pada tingkat **Otorisasi Database**. Identitas akun Anda sah, tetapi akun tidak memiliki wewenang membuat basis data baru.
5. **Tindakan:** Ambil screenshot pesan galat ini dan simpan sebagai `laporan/img/p01_galat_1044.png`.
6. Ketik `exit;` untuk keluar.

---

### Langkah 1.7: Memicu dan Mendokumentasikan Galat 1142

**Target Screenshot:** `laporan/img/p01_galat_1142.png`

1. Login sebagai akun tamu:

   ```cmd
   mysql -u tamu_037 -p
   ```

   (Password: `TamuKopma#2026`)

2. Masuk ke database koperasi dan coba buat tabel:

   ```sql
   USE kopma_037;
   CREATE TABLE uji_tabel (id INT);
   ```

3. **Pesan Galat:** Server menolak dengan pesan:
   `ERROR 1142 (42000): CREATE command denied to user 'tamu_037'@'localhost' for table 'uji_tabel'`
4. **Penjelasan:** Galat 1142 adalah galat pada tingkat **Otorisasi Objek/Perintah Tabel**. Akun tamu memiliki akses ke database `kopma_037`, tetapi hak perintah yang diberikan hanya `SELECT`. Perintah `CREATE` atau `INSERT` ditolak secara tegas.
5. **Tindakan:** Ambil screenshot pesan galat ini dan simpan sebagai `laporan/img/p01_galat_1142.png`.
6. Ketik `exit;` untuk keluar.

---

### Langkah 1.8: Mengonfigurasi Keamanan phpMyAdmin (Cookie Auth)

**Target Screenshot:** `laporan/img/p01_phpmyadmin_cookie.png`

1. Buka File Explorer Windows, tuju ke folder:
   `C:\xampp\phpMyAdmin\`
2. Buka berkas `config.inc.php` menggunakan Notepad atau VS Code.
3. Cari baris berikut:

   ```php
   $cfg['Servers'][$i]['auth_type'] = 'config';
   ```

4. Ubah menjadi:

   ```php
   $cfg['Servers'][$i]['auth_type'] = 'cookie';
   ```

   *(Pastikan baris `$cfg['Servers'][$i]['user']` bernilai string kosong `''`)*.
5. Simpan file `config.inc.php`.
6. Buka browser web (Google Chrome / Microsoft Edge) lalu buka alamat:
   `http://localhost/phpmyadmin/`
7. phpMyAdmin kini menampilkan halaman formulir login interaktif yang meminta pengguna memasukkan nama pengguna dan kata sandi.
8. **Tindakan:** Ambil screenshot halaman formulir login tersebut dan simpan sebagai `laporan/img/p01_phpmyadmin_cookie.png`.

---

### Langkah 1.9: Riwayat Git Commit dan Push

**Target Screenshot:** `laporan/img/p01_git_push.png`

1. Buka jendela Git Bash atau Command Prompt di dalam folder proyek (`basis_data(clien)`).
2. Lakukan pemeriksaan dan pengunggahan repositori ke GitHub:

   ```cmd
   git status
   git add .
   git commit -m "p01: penyiapan lingkungan dan skrip basis data"
   git push origin main
   ```

3. **Tindakan:** Ambil screenshot terminal yang memperlihatkan teks proses push ke repositori GitHub Anda (`Writing objects: 100% ... To https://github.com/...`). Simpan sebagai `laporan/img/p01_git_push.png`.

---

## Bagian 3: Panduan Lengkap Modul 02

Modul 02 berfokus pada rekayasa kebutuhan data, identifikasi proses bisnis riil, perumusan aturan bisnis, penyusunan kamus data, matriks CRUD, dan personalisasi parameter numerik berbasis NIM.

Seluruh data analisis proyek Toko Daring Sentosa BDS telah tersusun rapi dalam file [p02_kebutuhan_data_25430037.md](file:///home/rizky/Documents/basis_data(clien)/p02_kebutuhan_data_25430037.md).

**Cara Membuka Tampilan Pratinjau Visual di VS Code:**

1. Buka VS Code pada folder proyek `basis_data(clien)`.
2. Buka file `p02_kebutuhan_data_25430037.md`.
3. Tekan tombol **`Ctrl + Shift + V`** untuk membuka tab *Markdown Preview* yang menampilkan tabel dan rumus matematika secara estetis.

---

### Langkah 2.1: Menghitung dan Mendokumentasikan Parameter Personalisasi ($P$)

**Target Screenshot:** `laporan/img/p02_parameter_p.png`

Sesuai aturan buku panduan praktikum, setiap mahasiswa wajib memiliki nilai parameter unik yang diturunkan dari 2 digit terakhir NIM untuk mencegah plagiarisme:

- **NIM:** `25430037` $\rightarrow$ 2 digit terakhir = `37`.
- **Rumus:** $P = (NIM \pmod 9) + 1$
- **Perhitungan:**
  $$37 \pmod 9 = 1$$
  $$P = 1 + 1 = \mathbf{2}$$

**Penerapan Nilai $P = 2$ pada Aturan Bisnis Toko Daring Sentosa BDS:**

1. **Batas Variasi Item Pesanan Unik ($P + 2$):** $2 + 2 = \mathbf{4}$ item produk unik per nota belanja (AB-04).
2. **Diskon Promosi Pembelian ($P\%$):** $\mathbf{2\%}$ potongan harga untuk transaksi pelanggan aktif (AB-05).
3. **Target Volume Transaksi Harian Rata-rata ($40 + 5P$):** $40 + (5 \times 2) = \mathbf{50}$ transaksi per hari.

**Tindakan:**
Pada *Markdown Preview* file `p02_kebutuhan_data_25430037.md`, scroll ke bagian **1.2 Parameter Personalisasi Berbasis NIM**. Ambil screenshot area formula dan tabel batasannya, lalu simpan sebagai `laporan/img/p02_parameter_p.png`.

---

### Langkah 2.2: Mendokumentasikan 6 Proses Bisnis Inti Toko Daring

**Target Screenshot:** `laporan/img/p02_tabel_pb_toko.png`

Toko Daring Sentosa BDS memproses alur perdagangan elektronik melalui 6 proses bisnis terstruktur:

1. **PB-01 Manajemen Akun dan Otentikasi Pelanggan:** Pendaftaran pembeli/penjual, validasi email unik, penyimpanan hash kata sandi, dan pengelolaan alamat pengiriman.
2. **PB-02 Manajemen Katalog dan Inventaris Produk:** Kurasi produk oleh admin/penjual, penetapan kategori hierarkis, pembaruan harga modal dan harga jual, serta pengawasan stok minimum.
3. **PB-03 Pemesanan dan Reservasi Keranjang Belanja:** Checkout keranjang, pembuatan nomor invoice unik (`INV/YYYYMMDD/037/XXXX`), penguncian stok sementara (*stock reservation*), dan penghitungan subtotal.
4. **PB-04 Verifikasi Pembayaran Transaksi:** Pembayaran via transfer/Virtual Account, konfirmasi bukti bayar, validasi status `LUNAS`, dan pembatalan otomatis jika melewati batas 24 jam.
5. **PB-05 Pengiriman dan Pelacakan Pesanan:** Penetapan nomor resi ekspedisi (JNE, J&T, SiCepat), perhitungan ongkos kirim berdasarkan berat total barang (gram), dan pembaharuan status transit kurir.
6. **PB-06 Penyelesaian Pesanan dan Ulasan Produk:** Konfirmasi penerimaan paket oleh pembeli, pencairan dana pesanan, dan pemberian rating bintang (1–5) beserta teks ulasan.

**Tindakan:**
Pada *Markdown Preview*, scroll ke bagian **2. Identifikasi Proses Bisnis Toko Daring Sentosa BDS**. Ambil screenshot tabel ringkasan keenam proses bisnis tersebut, lalu simpan sebagai `laporan/img/p02_tabel_pb_toko.png`.

---

### Langkah 2.3: Mendokumentasikan Matriks Keterlacakan Hak Akses CRUD

**Target Screenshot:** `laporan/img/p02_matriks_crud_toko.png`

Matriks CRUD memetakan relasi antara 7 entitas data dengan 6 proses bisnis:

| Entitas Data | PB-01 Akun | PB-02 Katalog | PB-03 Pesanan | PB-04 Bayar | PB-05 Kirim | PB-06 Ulasan/Selesai |
| --- | :---: | :---: | :---: | :---: | :---: | :---: |
| `pengguna` | **C, R, U, D\*** | **R** | **R** | **R** | **R** | **R** |
| `kategori` | - | **C, R, U, D** | **R** | - | - | - |
| `produk` | - | **C, R, U, D\*** | **R, U** *(stok)* | - | **R** | **R** |
| `pesanan` | - | - | **C, R** | **R, U** | **R, U** | **R, U** |
| `item_pesanan` | - | - | **C, R** | **R** | **R** | **R** |
| `pembayaran` | - | - | **C** *(tagihan)* | **R, U** *(lunas)* | **R** | **R** |
| `pengiriman` | - | - | - | - | **C, R, U** | **R, U** |

*\*Keterangan: Tanda D\* mengindikasikan operasi Soft Delete (mengubah flag status aktif menjadi 'NONAKTIF') guna melindungi keutuhan data transaksi historis.*

**Tindakan:**
Pada *Markdown Preview*, scroll ke bagian **4. Matriks Keterlacakan CRUD**. Ambil screenshot tabel matriks CRUD tersebut, lalu simpan sebagai `laporan/img/p02_matriks_crud_toko.png`.

---

### Langkah 2.4: Mendokumentasikan Kamus Data Teknis Proyek

**Target Screenshot:** `laporan/img/p02_kamus_data_toko.png`

Kamus data memuat spesifikasi teknis dari 28 elemen data yang mencakup seluruh entitas Toko Daring Sentosa BDS. Salah satu contoh entitas terpenting adalah `pesanan` dan `item_pesanan`:

| Elemen Data | Nama Atribut | Tipe Data Konseptual | Wajib/Opsional | Deskripsi Semantik |
| --- | --- | --- | :---: | --- |
| ID Pesanan | `id_pesanan` | String (25) | Wajib (PK) | Format invoice: `INV/YYYYMMDD/037/XXXX` |
| ID Pengguna | `id_pengguna` | String (15) | Wajib (FK) | Relasi ke entitas `pengguna` pembeli |
| Tanggal Pesan | `tanggal_pesanan` | DateTime | Wajib | Waktu checkout transaksi dilakukan |
| Total Belanja | `total_harga_produk` | Desimal (12,2) | Wajib | Akumulasi subtotal seluruh item barang |
| Ongkos Kirim | `ongkos_kirim` | Desimal (12,2) | Wajib | Biaya pengantaran kurir logistik |
| Potongan Diskon | `potongan_diskon` | Desimal (12,2) | Wajib | Diskon promo belanja member ($P\% = 2\%$) |
| Total Tagihan | `total_bayar` | Desimal (12,2) | Wajib | Kalkulasi: `(total_produk + ongkir) - diskon` |
| Status Pesanan | `status_pesanan` | Enum | Wajib | Nilai: MENUNGGU, DIPROSES, DIKIRIM, SELESAI, BATAL |

**Pembedahan Snapshot Harga:**
Atribut `item_pesanan.harga_satuan_saat_transaksi` wajib dicatat saat transaksi terjadi. Nilai ini **tidak boleh** mengambil langsung secara dinamis dari tabel master `produk`, karena bila harga produk naik di kemudian hari, total pembukuan nota belanja lama tidak boleh ikut berubah.

**Tindakan:**
Pada *Markdown Preview*, scroll ke bagian **5. Kamus Data (Data Dictionary) Proyek**. Ambil screenshot bagian tabel kamus data transaksi tersebut, lalu simpan sebagai `laporan/img/p02_kamus_data_toko.png`.

---

## Bagian 4: Menautkan Gambar ke Dokumen Laporan Akhir

Setelah ke-12 gambar telah berhasil Anda simpan di dalam folder `laporan/img/`:

1. Buka berkas [laporan/p01_laporan_25430037.md](file:///home/rizky/Documents/basis_data(clien)/laporan/p01_laporan_25430037.md):
   - Pastikan seluruh tag gambar memuat path yang benar:
     - `![Verifikasi Versi MariaDB dan Current User](img/p01_version_user.png)`
     - `![Pemeriksaan SQL Mode](img/p01_sql_mode.png)`
     - `![Tampilan SHOW DATABASES untuk Akun mhs_037](img/p01_show_databases_mhs.png)`
     - `![Tampilan SHOW DATABASES untuk Akun dev_037](img/p01_show_databases_dev.png)`
     - `![Pengujian Galat 1044](img/p01_galat_1044.png)`
     - `![Pengujian Galat 1142](img/p01_galat_1142.png)`
     - `![Halaman Login phpMyAdmin Cookie Authentication](img/p01_phpmyadmin_cookie.png)`
     - `![Bukti Git Commit dan Push](img/p01_git_push.png)`
   - Lengkapi URL repositori GitHub dan commit hash Anda di tabel **Bab 10 Bukti Git**.

2. Buka berkas [laporan/p02_laporan_25430037.md](file:///home/rizky/Documents/basis_data(clien)/laporan/p02_laporan_25430037.md):
   - Masukkan kembali path gambar di bagian Bab 6:
     - `![Perhitungan Parameter Personalisasi P](img/p02_parameter_p.png)`
     - `![Daftar Proses Bisnis Toko Daring](img/p02_tabel_pb_toko.png)`
     - `![Matriks CRUD Toko Daring Sentosa BDS](img/p02_matriks_crud_toko.png)`
     - `![Kamus Data Toko Daring Sentosa BDS](img/p02_kamus_data_toko.png)`
   - Lengkapi URL repositori GitHub Anda di tabel **Bab 10 Bukti Git**.

3. Simpan seluruh berkas di VS Code.
4. Lakukan komit akhir di Git Bash / CMD:

   ```cmd
   git add .
   git commit -m "docs: perbarui seluruh screenshot bukti praktikum modul 1 dan modul 2"
   git push origin main
   ```

Selamat! Seluruh rangkaian praktikum Modul 01 dan Modul 02 kini telah Anda kuasai dan terdokumentasikan dengan standar akademik sempurna.
