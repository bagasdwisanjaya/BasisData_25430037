# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

**Nama Praktikan:** Bagas Dwi Sanjaya  
**NIM:** 25430037  
**Kelas:** Kelas B, Ilmu Komputer - Semester 3  
**Tanggal:** 30 September 2026  
**Pertemuan** : Satu (1)
**Mata Kuliah:** Praktikum Basis Data (Semester 3)  
**Tema Proyek:** Toko Daring (Kode: `toko`)  
**Milestone:** 2 - Dokumen Kebutuhan Data Proyek Mandiri  
**Tahun Akademik:** 2026/2027 

---

## 1. Latar Belakang dan Aktivitas Organisasi

Koperasi Mahasiswa Sejahtera (Kopma) adalah unit kegiatan usaha mandiri di lingkungan kampus yang menyediakan aneka kebutuhan mahasiswa, meliputi alat tulis kantor (ATK), makanan ringan, dan minuman. Transaksi dapat dilakukan oleh mahasiswa yang terdaftar sebagai anggota koperasi maupun pembeli umum non-anggota. Mahasiswa yang ingin menikmati potongan harga khusus (diskon 5%) wajib mendaftar sebagai anggota aktif dengan menyerahkan data identitas diri.

Pencatatan yang selama ini menggunakan buku manual dan spreadsheet sederhana menimbulkan sejumlah permasalahan krusial:

1. Terjadinya nilai persediaan (stok) minus akibat pencatatan yang terlambat atau tidak terkontrol.
2. Riwayat harga lama hilang atau tertimpa saat harga barang naik, sehingga nota penjualan lampau tidak dapat dihitung ulang dengan benar.
3. Kasir kesulitan mengidentifikasi anggota yang tidak membawa kartu fisik saat berbelanja.
4. Pengurus kesulitan memperoleh laporan omzet berkala, barang paling laku, dan stok barang yang menipis secara akurat dan tepat waktu.

Untuk mengatasi permasalahan tersebut, dirancang basis data relasional operasional (OLTP) yang terpusat dan terkelola dengan baik.

---

## 2. Aktor dan Proses Bisnis

### Aktor Sistem

1. **Kasir**: Melayani transaksi pembayaran di gerai, mendaftarkan anggota baru, dan mencetak nota penjualan.
2. **Petugas Gudang**: Mengelola persediaan fisik, memantau batas minimum stok barang, membuat pesanan pembelian ke pemasok, dan menerima barang datang beserta faktur.
3. **Ketua Koperasi**: Bertindak sebagai pengawas tata kelola usaha, memantau laporan manajerial bulanan, mengelola data mitra pemasok, dan menetapkan status aktif anggota.
4. **Pembeli / Anggota**: Melakukan transaksi pembelian produk di Kopma.

### Tabel Identifikasi Proses Bisnis (PB)

| Kode PB | Proses Bisnis | Aktor Pelaksana | Pemicu (Trigger) | Keluaran (Output) |
| --- | --- | --- | --- | --- |
| **PB-01** | Mendaftarkan Anggota Baru | Kasir | Mahasiswa mengajukan pendaftaran keanggotaan | Data anggota tersimpan, kartu/nomor anggota diterbitkan |
| **PB-02** | Mencatat Transaksi Penjualan | Kasir | Pembeli membawa barang belanjaan ke kasir | Nota penjualan tercetak, stok barang berkurang |
| **PB-03** | Memesan Barang ke Pemasok | Petugas Gudang | Stok barang berada di bawah batas minimum (`stok <= stok_min`) | Surat pesanan pembelian (PO) terbit |
| **PB-04** | Menerima Barang dari Pemasok | Petugas Gudang | Barang pesanan tiba bersama faktur pemasok | Status pembelian menjadi diterima, stok barang bertambah |
| **PB-05** | Menyusun Laporan Bulanan | Ketua Koperasi | Siklus awal bulan | Laporan omzet, barang terlaris, stok menipis, dan anggota aktif |
| **PB-06** | Mengelola Data Mitra Pemasok *(Penyempurnaan)* | Petugas Gudang / Ketua | Adanya kerja sama vendor/pemasok baru | Data master pemasok terdaftar dan terverifikasi |
| **PB-07** | Pemutakhiran Status Anggota *(Penyempurnaan)* | Ketua Koperasi | Evaluasi berkala atau mahasiswa lulus/keluar | Status anggota diperbarui (`aktif` / `non-aktif`) |

---

## 3. Dokumen Sumber yang Dianalisis

### 3.1 Nota Penjualan Kopma (Dokumen Sumber Transaksi Penjualan)

- **Nomor Dokumen**: `PJ-2609-0142`
- **Elemen Data Tersimpan**:
  - Tanggal & Waktu: `26/09/2026 14:15`
  - Kode Kasir: `K01` (Kasir Rina)
  - Nomor Anggota: `A-0457` (Opsional, `NULL` jika pembeli umum)
  - Detail Barang: Kode Barang, Qty, Harga Satuan saat transaksi
- **Elemen Data Turunan (Dihitung)**:
  - Subtotal per baris = `Qty * Harga Satuan`
  - Total Belanja = `SUM(Subtotal) - Diskon`
  - Jumlah Bayar & Uang Kembalian

### 3.2 Faktur Pembelian Pemasok (Dokumen Sumber Pengadaan)

- **Elemen Data**: Nomor Faktur Pemasok, Tanggal Faktur, Kode Pemasok, Kode Barang, Qty Masuk, Harga Beli Satuan (Modal).

---

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Kategori | Elemen Data Utama | Sumber Penggalian |
| --- | --- | --- | --- |
| **Anggota** | Master Data | `id_anggota`, `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`, `tgl_daftar_anggota` | Formulir Pendaftaran |
| **Petugas** | Master Data | `id_petugas`, `kode_petugas`, `nama_petugas`, `peran_petugas` | Wawancara Manajemen |
| **Barang** | Master Data / Katalog | `id_barang`, `kode_barang`, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang` | Daftar Barang & Label Harga |
| **Pemasok** | Master Data | `id_pemasok`, `kode_pemasok`, `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok` | Faktur Pengadaan Vendor |
| **Penjualan** | Transaksi (Header) | `id_penjualan`, `no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `id_anggota`, `bayar_penjualan` | Nota Penjualan |
| **Detail Penjualan** | Transaksi (Asosiatif) | `id_penjualan`, `id_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan` | Rincian Nota Penjualan |
| **Pembelian** | Transaksi (Header) | `id_pembelian`, `no_faktur_pembelian`, `tgl_pembelian`, `id_pemasok`, `status_pembelian` | Faktur Pengadaan |
| **Detail Pembelian** | Transaksi (Asosiatif) | `id_pembelian`, `id_barang`, `qty_detail_pembelian`, `harga_beli_detail_pembelian` | Rincian Faktur Pengadaan |

---

## 5. Aturan Bisnis (Business Rules)

| Kode AB | Pernyataan Aturan Bisnis | Implementasi / Penegakan |
| --- | --- | --- |
| **AB-01** | Setiap nota penjualan memiliki nomor unik (`no_nota_penjualan`) dan wajib memuat minimal satu rincian barang. | `UNIQUE KEY`, Transaksi Database |
| **AB-02** | Transaksi penjualan dapat dilakukan tanpa anggota (pembeli umum); jika pembeli adalah anggota, statusnya harus `aktif` agar berhak mendapatkan diskon 5%. | Kolom `id_anggota NULL`, Logika Aplikasi |
| **AB-03** | Persediaan barang tidak boleh bernilai negatif; transaksi penjualan wajib ditolak jika jumlah beli melebihi stok yang tersedia. | `CHECK (stok_barang >= 0)`, Logika Validasi |
| **AB-04** | Harga satuan pada rincian nota penjualan disimpan pada saat transaksi terjadi dan tidak boleh berubah meskipun harga master barang dinaikkan di masa mendatang. | Kolom `harga_satuan_detail_penjualan` |
| **AB-05** | Nomor Induk Mahasiswa (`nim_anggota`) dan nomor anggota (`no_anggota`) harus unik; kasir dapat mencari data anggota berdasarkan nomor kartu atau NIM. | `UNIQUE KEY` pada masing-masing kolom |
| **AB-06** | Pengadaan barang (pemesanan pembelian) otomatis dipicu ketika stok fisik berada di bawah batas minimum (`stok_barang <= stok_min_barang`). | Pemicu Operasional & Laporan KI-03 |
| **AB-07** | *(Poin Loyalitas)* Anggota aktif berhak memperoleh 1 poin loyalitas untuk setiap kelipatan belanja Rp10.000. | Aturan Loyalty Program |
| **AB-08** | *(Penukaran Poin)* Penukaran 50 poin loyalitas memberikan potongan belanja sebesar Rp5.000, dengan saldo poin tidak boleh negatif. | Aturan Loyalty Program |

---

## 6. Kebutuhan Informasi (KI)

| Kode KI | Kebutuhan Informasi | Pengguna Sasaran | Elemen Data yang Diperlukan |
| --- | --- | --- | --- |
| **KI-01** | Laporan omzet total pendapatan dan jumlah nota penjualan harian serta bulanan. | Ketua Koperasi | `penjualan`, `detail_penjualan` |
| **KI-02** | Daftar 5 (lima) barang terlaris per bulan berdasarkan total kuantitas terjual. | Petugas Gudang & Ketua | `detail_penjualan`, `barang` |
| **KI-03** | Daftar peringatan dini persediaan barang yang berada di bawah atau sama dengan batas minimum stok. | Petugas Gudang | `barang` (`stok_barang <= stok_min_barang`) |
| **KI-04** | Daftar 10 (sepuluh) anggota koperasi dengan akumulasi nilai transaksi belanja terbesar per bulan. | Ketua Koperasi | `anggota`, `penjualan`, `detail_penjualan` |
| **KI-05** | Rekapitulasi perolehan dan penukaran saldo poin loyalitas anggota aktif. | Kasir & Ketua | `anggota`, `penjualan` |

---

## 7. Matriks CRUD (Proses Bisnis terhadap Entitas)

Keterangan: **C** = Create, **R** = Read, **U** = Update, **D** = Delete.

| Proses Bisnis | Petugas | Anggota | Barang | Pemasok | Penjualan | Detail Penjualan | Pembelian | Detail Pembelian |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01** Daftar Anggota | R | **C** | - | - | - | - | - | - |
| **PB-02** Catat Penjualan | R | R | R, **U** | - | **C** | **C** | - | - |
| **PB-03** Pesan ke Pemasok | R | - | R | R | - | - | **C** | **C** |
| **PB-04** Terima Barang | R | - | **U** | R | - | - | **U** | R |
| **PB-05** Laporan Bulanan | R | R | R | R | R | R | R | R |
| **PB-06** Kelola Pemasok | R | - | - | **C, U** | - | - | - | - |
| **PB-07** Mutakhir Status Anggota | R | **U** | - | - | - | - | - | - |

*Catatan Evaluasi*: Seluruh entitas memiliki operasi **C** (Create) dan **R** (Read). Tidak ada entitas "yatim" dalam sistem.

---

## 8. Kamus Data Awal (Data Dictionary)

| Nama Kolom / Atribut | Arti & Keterangan | Format / Tipe Data | Contoh Nilai | Aturan Validasi | Penanggung Jawab (Data Steward) |
| --- | --- | --- | --- | --- | --- |
| `id_petugas` | ID unik internal sistem untuk petugas | Integer, Auto Increment | `1` | Kunci Primer (PK) | Ketua Koperasi |
| `kode_petugas` | Kode unik petugas kasir/gudang/ketua | CHAR(3) | `K01` | Unik, 3 karakter huruf & angka | Ketua Koperasi |
| `nama_petugas` | Nama lengkap petugas | VARCHAR(100) | `Rina Permata` | Wajib diisi (NOT NULL) | Ketua Koperasi |
| `peran_petugas` | Peran operasional petugas di Kopma | ENUM | `'kasir'` | Pilihan: `kasir`, `gudang`, `ketua` | Ketua Koperasi |
| `id_anggota` | ID unik internal anggota koperasi | Integer, Auto Increment | `12` | Kunci Primer (PK) | Ketua Koperasi |
| `no_anggota` | Nomor kartu tanda anggota resmi | VARCHAR(10) | `A-0457` | Format `A-xxxx`, Unik | Ketua Koperasi |
| `nim_anggota` | Nomor Induk Mahasiswa anggota | CHAR(10) | `25430037` | Unik, 10 digit numerik | Ketua Koperasi |
| `nama_anggota` | Nama lengkap mahasiswa anggota | VARCHAR(100) | `Budi Santoso` | Wajib diisi (NOT NULL) | Ketua Koperasi |
| `no_hp_anggota` | Nomor telepon seluler anggota | VARCHAR(15) | `081234567890` | Data Pribadi (UU PDP), Akses Terbatas | Ketua Koperasi |
| `status_anggota` | Status keaktifan anggota koperasi | ENUM | `'aktif'` | Nilai: `aktif`, `non-aktif` | Ketua Koperasi |
| `id_barang` | ID unik internal master barang | Integer, Auto Increment | `1` | Kunci Primer (PK) | Petugas Gudang |
| `kode_barang` | Kode barang (SKU/Barcode) | VARCHAR(10) | `ATK-001` | Unik, format kategori-nomor | Petugas Gudang |
| `nama_barang` | Nama barang yang diperjualbelikan | VARCHAR(100) | `Buku Tulis Sinar Dunia 38` | Wajib diisi (NOT NULL) | Petugas Gudang |
| `kategori_barang` | Kelompok produk | ENUM | `'ATK'` | Nilai: `ATK`, `makanan`, `minuman` | Petugas Gudang |
| `harga_jual_barang` | Harga jual eceran saat ini | DECIMAL(12,2) | `4500.00` | Angka pecahan uang >= 0 | Petugas Gudang |
| `stok_barang` | Jumlah persediaan fisik tersedia | INT | `35` | Angka bulat >= 0 (AB-03) | Petugas Gudang |
| `stok_min_barang` | Batas minimum pemicu pemesanan | INT | `5` | Angka bulat >= 0 (AB-06) | Petugas Gudang |
| `id_penjualan` | ID unik transaksi penjualan | Integer, Auto Increment | `101` | Kunci Primer (PK) | Kasir |
| `no_nota_penjualan` | Nomor struk nota penjualan | CHAR(12) | `PJ-2609-0142` | Format `PJ-YYMM-nnnn`, Unik | Kasir |
| `tgl_penjualan` | Waktu transaksi dilakukan di kasir | DATETIME | `2026-09-26 14:15:00` | Wajib diisi | Kasir |
| `bayar_penjualan` | Uang tunai/nominal yang dibayarkan | DECIMAL(12,2) | `50000.00` | Nominal uang >= total belanja | Kasir |
| `qty_detail_penjualan` | Jumlah barang yang dibeli per baris | SMALLINT | `2` | Angka bulat > 0 | Kasir |
| `harga_satuan_detail_penjualan` | Harga jual satuan saat nota dicetak | DECIMAL(12,2) | `4500.00` | Nominal uang >= 0 (AB-04) | Kasir |

---

## 9. Kebutuhan Non-Fungsional Data

1. **Volume Data**:
   - Diperkirakan melayani rata-rata 150 nota penjualan per hari dengan rata-rata 2–4 item per nota.
   - Pertumbuhan data penjualan berkisar 4.500 baris nota dan 13.500 baris rincian per bulan.
2. **Retensi & Pengarsipan Data**:
   - Data transaksi keuangan operasional wajib disimpan aktif minimal 5 (lima) tahun sesuai standar audit pembukuan koperasi.
3. **Privasi & Keamanan Data Pribadi (UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi)**:
   - Data `no_hp_anggota` dan `nim_anggota` merupakan data pribadi yang dilindungi.
   - Kolom nomor HP disembunyikan (*masked*) dari layar kasir dan hanya dapat diakses utuh oleh Ketua Koperasi.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Kelengkapan (*Completeness*)**: Mencegah adanya nota tanpa rincian barang atau nota tanpa kasir yang bertugas melalui penegakan *foreign key* dan transaksi utuh.
2. **Akurasi (*Accuracy*)**: Menghindari persediaan minus dengan menerapkan *constraint* `CHECK (stok_barang >= 0)`.
3. **Konsistensi Format (*Consistency*)**: Memastikan penyeragaman penulisan format nomor nota `PJ-YYMM-nnnn` dan nomor anggota `A-xxxx`.
4. **Validitas Historis (*Temporal Validity*)**: Menjamin integritas pencatatan akuntansi bahwa perubahan harga barang di masa depan tidak mengubah nilai transaksi historis.

---

## 11. Jawaban Titik Analisis Modul 2

### Titik Analisis 1

> **Pertanyaan**: *Harga barang sudah tersimpan di data barang. Mengapa nota tetap perlu menyimpan harga saat transaksi? Hubungkan jawaban Anda dengan keluhan ketua koperasi dalam kutipan wawancara.*

- **Jawaban**:  
  Harga pada data master `barang` merepresentasikan **harga jual saat ini** yang bersifat dinamis dan fluktuatif sesuai perkembangan pasar. Sebagaimana keluhan ketua koperasi (*"Harga barang sering naik, jadi kami bingung saat melihat nota lama"*), jika nota penjualan hanya mengambil harga dari tabel barang, maka ketika harga pulpen naik dari Rp4.000 menjadi Rp4.500, semua nota penjualan bulan lalu akan ikut berubah secara otomatis saat laporan dihitung ulang. Akibatnya, nilai omzet historis menjadi keliru dan pembukuan keuangan rusak. Oleh karena itu, atribut `harga_satuan_detail_penjualan` wajib disimpan permanen pada tabel transaksi sebagai **rekaman historis tak terubahkan (*immutable snapshot*)** dari harga pada detik transaksi terjadi.

### Titik Analisis 2

> **Pertanyaan**: *Subtotal dan total adalah nilai turunan. Sebutkan satu alasan untuk tidak menyimpannya dan satu alasan yang mungkin membuat total tetap disimpan.*

- **Jawaban**:  
  - **Alasan TIDAK menyimpan**: Untuk mematuhi prinsip normalisasi dan menghindari **inkonsistensi data**. Nilai subtotal dan total dapat dihitung secara dinamis kapan saja melalui rumus matematis `qty * harga_satuan`. Jika nilai total disimpan di tabel database, terdapat risiko kegagalan sinkronisasi (misalnya salah satu baris rincian diubah/dihapus tetapi total pada kepala nota lupa diperbarui), sehingga menghasilkan data anomali.
  - **Alasan TETAP menyimpan**: Demi pertimbangan **kinerja kueri (*query performance*)** dan kesepakatan nilai final pembayaran. Pada sistem basis data berskala besar dengan jutaan baris transaksi, menghitung ulang agregasi `SUM(qty * harga)` setiap kali menampilkan riwayat transaksi akan membebani CPU server. Nilai total yang disimpan juga menjadi bukti legal nominal uang yang telah disepakati dan dibayarkan pembeli pada saat transaksi ditutup.

### Titik Analisis 3

> **Pertanyaan**: *Perhatikan kolom Pemasok pada Tabel 2.6. Tidak ada proses yang memberi huruf C. Apa artinya, dan proses apa yang perlu ditambahkan ke daftar proses bisnis? Periksa juga: siapa yang mengubah status aktif anggota?*

- **Jawaban**:  
  - **Arti kolom Pemasok tanpa huruf C**: Hal ini mengindikasikan adanya celah (*CRUD gap*) atau entitas "yatim", yaitu data pemasok dibutuhkan oleh sistem pengadaan (Read pada PB-03 & PB-04), namun tidak ada proses bisnis terdefinisi yang bertugas memasukkan/mendaftarkan data pemasok baru ke dalam basis data.
  - **Proses bisnis yang perlu ditambahkan**: Perlu ditambahkan proses **PB-06: Mengelola Data Mitra Pemasok** (*Pendaftaran Vendor Baru*) yang dilakukan oleh Petugas Gudang atau Ketua Koperasi untuk menginput (Create), memperbarui alamat/telepon (Update), dan melihat (Read) data pemasok.
  - **Pihak yang mengubah status aktif anggota**: Status aktif anggota diubah oleh **Ketua Koperasi** (selaku penanggung jawab data keanggotaan) melalui proses **PB-07: Pemutakhiran Status Anggota**, yang dilakukan saat rapat evaluasi semester atau ketika mahasiswa menyelesaikan studi/lulus.

---

## 12. Hasil Latihan dan Modifikasi (Bagian E)

### 12.1 Penambahan Fitur Poin Loyalitas (Latihan E.1)

1. **Elemen Data Baru**:
   - Pada entitas Anggota: `poin_loyalitas_anggota INT DEFAULT 0`.
   - Pada entitas Penjualan: `poin_didapat_penjualan INT DEFAULT 0`, `poin_digunakan_penjualan INT DEFAULT 0`.
2. **Aturan Bisnis Tambahan**:
   - `AB-07`: Setiap kelipatan belanja Rp10.000, anggota aktif memperoleh 1 poin loyalitas.
   - `AB-08`: Anggota dapat menukarkan 50 poin loyalitas untuk mendapatkan potongan harga sebesar Rp5.000. Saldo poin tidak boleh bernilai negatif.
3. **Kebutuhan Informasi Tambahan**:
   - `KI-05`: Rekapitulasi perolehan dan penukaran poin loyalitas per anggota per bulan.
4. **Pembaruan Matriks CRUD**:
   - Proses `PB-02` (Catat Penjualan) kini melakukan **Update (U)** pada entitas `Anggota` untuk menambah poin yang diperoleh atau mengurangi poin yang ditukarkan.

### 12.2 Perbaikan Tiga Pernyataan Kebutuhan Kabur agar Dapat Diuji (Latihan E.2)

1. **Pernyataan Kabur (a)**: *"data anggota harus aman"*  
   - **Rumusan Perbaikan yang Dapat Diuji**:  
     > *"Atribut `no_hp_anggota` dan `nim_anggota` diklasifikasikan sebagai data pribadi sensitif sesuai UU PDP No. 27/2022; data ini hanya boleh dibaca (*SELECT*) oleh akun dengan peran Ketua Koperasi, disamarkan (*masked* berupa `0812****0037`) saat diakses oleh peran Kasir, dan setiap akses baca dicatat dalam riwayat audit log."*
2. **Pernyataan Kabur (b)**: *"sistem harus cepat mencari barang"*  
   - **Rumusan Perbaikan yang Dapat Diuji**:  
     > *"Pencarian barang berdasarkan `kode_barang` atau awalan `nama_barang` pada tabel master berisi hingga 10.000 baris data harus menghasilkan keluaran dalam waktu eksekusi kurang dari 150 milidetik pada penggunaan indeks B-Tree tanpa memicu pemindaian tabel menyeluruh (*full table scan*)."*
3. **Pernyataan Kabur (c)**: *"laporan stok harus akurat"*  
   - **Rumusan Perbaikan yang Dapat Diuji**:  
     > *"Nilai `stok_barang` pada tabel barang harus selalu konsisten dan sama persis dengan perhitungan: `stok_awal + SUM(qty_pembelian_diterima) - SUM(qty_penjualan_selesai)`, diverifikasi menggunakan transaksi ACID dua arah, serta divalidasi oleh batasan server `CHECK (stok_barang >= 0)`."*
