# Dokumen Kebutuhan Data - Toko Daring Sentosa BDS

**Nama Praktikan:** Bagas Dwi Sanjaya  
**NIM:** 25430037  
**Kelas:** Kelas B, Ilmu Komputer- Semester 3  
**Tanggal:** 30 September 2026  
**Pertemuan:** Satu (1)  
**Mata Kuliah:** Praktikum Basis Data (Semester 3)  
**Tema Proyek:** Toko Daring (Kode: `toko`)  
**Milestone:** 2 - Dokumen Kebutuhan Data Proyek Mandiri  
**Tahun Akademik:** 2026/2027  

---

## 1. Latar Belakang dan Aktivitas Organisasi

**Toko Daring Sentosa BDS** adalah entitas bisnis ritel berbasis digital yang melayani pemesanan, pembelian, dan pengiriman perlengkapan komputasi, aksesori teknologi, serta perlengkapan belajar mahasiswa secara daring. Dalam operasionalnya, pelanggan dapat menjelajahi katalog produk, memasukkan produk ke keranjang belanja, melakukan pemesanan (*checkout*), memilih metode pembayaran, serta memantau status pengiriman paket hingga barang diterima.

Aktivitas utama organisasi meliputi:

1. Pengelolaan master katalog produk, penetapan kategori, dan pemeliharaan persediaan stok barang secara waktu nyata (*real-time*).
2. Penerimaan pemesanan belanja daring dari pelanggan terdaftar maupun pembeli tamu (*guest*).
3. Penerimaan dan verifikasi pembayaran pesanan melalui kanal transfer bank, dompet digital (*e-wallet*), maupun gerai ritel.
4. Pemrosesan logistik pesanan, pengemasan (*packing*), penyerahan ke jasa ekspedisi/kurir, serta penerbitan nomor resi pengiriman.
5. Penyusunan laporan berkala untuk memantau omzet penjualan, produk terlaris, persediaan stok menipis, dan efisiensi pengiriman.

---

## 2. Aktor dan Proses Bisnis

### Aktor Sistem

1. **Pelanggan**: Menjelajahi katalog, memilih barang, membuat pesanan (*checkout*), melakukan pembayaran, dan melacak paket pengiriman.
2. **Admin Penjualan / Operasional**: Mengelola katalog produk, memverifikasi ketersediaan stok, dan memperbarui status pesanan.
3. **Staf Keuangan**: Memverifikasi bukti/pemberitahuan pembayaran transaksi yang masuk.
4. **Petugas Gudang & Pengiriman**: Menyiapkan dan mengemas pesanan fisik, mencetak label alamat pengiriman, dan menyerahkan paket ke pihak ekspedisi kurir.
5. **Pimpinan / Pemilik Toko**: Memantau laporan kinerja operasional, penjualan, dan tren pergerakan produk.

### Tabel Identifikasi Proses Bisnis (PB)

| Kode PB | Proses Bisnis | Aktor Pelaksana | Pemicu (Trigger) | Keluaran (Output) |
| --- | --- | --- | --- | --- |
| **PB-01** | Registrasi & Pengelolaan Akun Pelanggan | Pelanggan | Calon pembeli mendaftar akun baru di aplikasi | Profil pelanggan tersimpan, kredensial aktif |
| **PB-02** | Pengelolaan Master Katalog Produk | Admin Operasional | Adanya produk baru, perubahan harga, atau pengadaan stok | Data produk tersimpan di katalog, stok fisik diperbarui |
| **PB-03** | Pembuatan Pesanan Belanja (*Checkout*) | Pelanggan | Pelanggan menekan tombol *checkout* pesanan | Dokumen invoice pemesanan terbit, stok produk dicadangkan |
| **PB-04** | Pembayaran & Verifikasi Transaksi | Pelanggan & Staf Keuangan | Pelanggan menyelesaikan transfer pembayaran | Transaksi pembayaran tervalidasi, status pesanan menjadi `lunas` |
| **PB-05** | Pemenuhan & Pengiriman Pesanan | Petugas Gudang | Pesanan lunas siap dikemas dan diserahkan ke kurir | Nomor resi tercatat, status pengiriman menjadi `dikirim` |
| **PB-06** | Penyusunan Laporan Penjualan & Kinerja | Pimpinan / Manajer | Awal pekan atau awal bulan | Laporan omzet, produk *best seller*, dan performa kurir |

---

## 3. Dokumen Sumber yang Dianalisis

### Dokumen Sumber Fiktif: Invoice Pesanan Daring (*Online Sales Order Invoice*)

```text
========================================================================================
                                 TOKO DARING SENTOSA BDS
                         Jl. Melati No. 37, Kota Metro, Lampung
                            Surel: support@tokosentosabds.co.id
========================================================================================
INVOICE PEMESANAN: ORD-20261011-0037                    TANGGAL: 11/10/2026 14:35:10
STATUS: LUNAS                                           METODE BAYAR: QRIS / E-WALLET
----------------------------------------------------------------------------------------
DATA PEMESAN:
ID Pelanggan : CUST-0037                                Telepon : 0812-7788-0037
Nama         : Bagas Dwi Sanjaya                        Email   : bagas.bds@contoh.id
Alamat Kirim : Jl. Cendekia No. 37, Iringmulyo, Kota Metro, Lampung (Kode Pos: 34112)
Kurir        : JNE Express (Reguler)                    No. Resi: JNE-992384037
----------------------------------------------------------------------------------------
RINCIAN BARANG PESANAN:
No  Kode Produk   Nama Produk                Qty   Harga Satuan     Subtotal (Rp)
--  -----------   ------------------------   ---   ------------     -------------
1.  PRD-ELK-01    Flashdisk Sandisk 64GB       2     Rp  85.000       Rp 170.000
2.  PRD-ACC-03    Mouse Wireless Logitech      1     Rp 145.000       Rp 145.000
3.  PRD-ACC-09    Kabel Data Type-C 100W       1     Rp  35.000       Rp  35.000
----------------------------------------------------------------------------------------
Total Jumlah Item Produk : 3 Jenis (Maksimal 4 Jenis Item / Transaksi Sesuai P+2)
Subtotal Produk          : Rp 350.000
Diskon Kupon Promo (2%)  : Rp   7.000   (Dihitung dari Parameter P = 2%)
Biaya Ongkos Kirim       : Rp  15.000
----------------------------------------------------------------------------------------
TOTAL TAGIHAN PEMBAYARAN : Rp 358.000
Nominal Dibayar          : Rp 358.000   [STATUS: LUNAS VERIFIKASI]
========================================================================================
```

### Pembedahan Elemen Data Dokumen Sumber

1. **Elemen Kepala Dokumen (Disimpan di tabel `pesanan`)**:
   - `no_pesanan`: `ORD-20261011-0037` (Kunci unik transaksi)
   - `tgl_pesanan`: `2026-10-11 14:35:10`
   - `id_pelanggan`: Relasi ke pelanggan pemesan
   - `diskon_pesanan`: `7000.00` (Potongan kupon promo $P\%$)
   - `ongkir_pesanan`: `15000.00`
   - `status_pesanan`: `lunas` / `dikirim`
2. **Elemen Rincian Barang (Disimpan di tabel `detail_pesanan`)**:
   - `id_produk`, `qty_detail_pesanan`, `harga_satuan_detail_pesanan` (Disimpan permanen saat transaksi berlangsung).
3. **Elemen Data Turunan (Tidak disimpan di tabel fisik master/detail)**:
   - `subtotal_item` = `qty_detail_pesanan * harga_satuan_detail_pesanan`
   - `total_tagihan` = `(SUM(subtotal_item) - diskon_pesanan) + ongkir_pesanan`
4. **Elemen Pembayaran (Disimpan di tabel `pembayaran`)**:
   - `no_transaksi_pembayaran`, `metode_pembayaran`, `waktu_bayar`, `nominal_pembayaran`, `status_pembayaran`.
5. **Elemen Pengiriman (Disimpan di tabel `pengiriman`)**:
   - `no_resi_pengiriman`, `nama_ekspedisi`, `alamat_tujuan_pengiriman`, `status_pengiriman`.

---

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Kategori | Elemen Data Utama | Deskripsi Peran |
| --- | --- | --- | --- |
| **Pelanggan** | Master Data | `id_pelanggan`, `kode_pelanggan`, `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `alamat_pelanggan`, `tgl_daftar_pelanggan` | Menyimpan data pembeli terdaftar |
| **Kategori Produk** | Master Referensi | `id_kategori`, `kode_kategori`, `nama_kategori` | Klasifikasi kelompok barang dagangan |
| **Produk** | Master Katalog | `id_produk`, `kode_produk`, `nama_produk`, `id_kategori`, `harga_jual_produk`, `stok_produk`, `stok_min_produk` | Katalog barang dan informasi stok gudang |
| **Pesanan** | Transaksi (Header) | `id_pesanan`, `no_pesanan`, `tgl_pesanan`, `id_pelanggan`, `diskon_pesanan`, `ongkir_pesanan`, `status_pesanan` | Rekaman kepala transaksi belanja |
| **Detail Pesanan** | Transaksi (Asosiatif) | `id_pesanan`, `id_produk`, `qty_detail_pesanan`, `harga_satuan_detail_pesanan` | Rincian komoditas produk yang dipesan |
| **Pembayaran** | Transaksi | `id_pembayaran`, `id_pesanan`, `no_transaksi_pembayaran`, `metode_pembayaran`, `tgl_pembayaran`, `nominal_pembayaran`, `status_pembayaran` | Bukti penerimaan kas pembayaran transaksi |
| **Pengiriman** | Transaksi Logistik | `id_pengiriman`, `id_pesanan`, `no_resi_pengiriman`, `nama_ekspedisi`, `alamat_kirim_pengiriman`, `status_pengiriman`, `tgl_kirim_pengiriman` | Pemantauan resi dan perjalanan paket kurir |

---

## 5. Aturan Bisnis (Business Rules)

| Kode AB | Pernyataan Aturan Bisnis | Mekanisme Penegakan |
| --- | --- | --- |
| **AB-01** | Setiap pesanan belanja memiliki kode transaksi unik (`no_pesanan`) berformat `ORD-YYYYMMDD-XXXX` dan wajib memiliki minimal 1 item rincian produk. | `UNIQUE KEY`, Transaksi Database |
| **AB-02** | Batas maksimal variasi item produk berbeda dalam 1 pesanan adalah **$P + 2 = 4$ jenis barang** guna menjaga kapasitas volume standar kemasan paket ritel. | Logika Validasi Aplikasi & Transaksi |
| **AB-03** | Jumlah kuantitas produk yang dipesan (`qty_detail_pesanan`) harus lebih besar dari 0 dan tidak boleh melebihi stok gudang yang tersedia saat itu (`stok_produk >= qty`). | `CHECK (qty > 0)`, Pengecekan Stok |
| **AB-04** | Harga satuan produk pada rincian pesanan dicatat dan disimpan permanen pada saat transaksi dibuat, serta tidak terpengaruh oleh kenaikan harga katalog produk di masa depan. | Atribut `harga_satuan_detail_pesanan` |
| **AB-05** | Pelanggan berhak memperoleh potongan kupon belanja promo sebesar **$P\% = 2\%$** dari subtotal nilai produk belanjaan. | Perhitungan Nilai Diskon |
| **AB-06** | Nomor Induk Pelanggan (`kode_pelanggan`) dan alamat surat elektronik (`email_pelanggan`) harus unik di seluruh sistem. | `UNIQUE KEY` |
| **AB-07** | Status pesanan hanya dapat diubah menjadi `diproses` setelah pembayaran berhasil diverifikasi dengan nominal bayar sama persis dengan total tagihan pesanan. | Validasi Keuangan |
| **AB-08** | Setiap paket pengiriman yang diserahkan ke pihak kurir wajib memiliki nomor resi unik (`no_resi_pengiriman`) yang tidak boleh duplikat. | `UNIQUE KEY (no_resi_pengiriman)` |
| **AB-09** | Stok persediaan produk di gudang tidak boleh bernilai negatif dalam kondisi apa pun. | `CONSTRAINT ck_produk_stok CHECK (stok_produk >= 0)` |

---

## 6. Kebutuhan Informasi (KI)

| Kode KI | Kebutuhan Informasi | Pengguna Sasaran | Elemen Data yang Diperlukan |
| --- | --- | --- | --- |
| **KI-01** | Laporan ringkasan total omzet penjualan, total diskon, dan jumlah pesanan berhasil per hari dan per bulan. | Pimpinan Toko | `pesanan`, `detail_pesanan`, `pembayaran` |
| **KI-02** | Daftar 5 (lima) produk terlaris (*best seller*) berdasarkan akumulasi volume penjualan kuantitas barang dalam satu bulan. | Admin & Pimpinan | `detail_pesanan`, `produk` |
| **KI-03** | Laporan peringatan dini stok produk kritis (*low stock alert*) yang berada di bawah atau sama dengan batas minimum stok gudang. | Petugas Gudang | `produk` (`stok_produk <= stok_min_produk`) |
| **KI-04** | Pemantauan daftar pesanan aktif yang siap dikirim beserta nomor resi, ekspedisi kurir, dan alamat tujuan pengiriman. | Petugas Gudang / Kurir | `pesanan`, `pengiriman`, `pelanggan` |
| **KI-05** | Rekapitulasi daftar 10 pelanggan paling aktif dengan akumulasi nominal transaksi belanja terbesar (analisis loyalitas pelanggan). | Manajer Pemasaran | `pelanggan`, `pesanan`, `detail_pesanan` |

---

## 7. Matriks CRUD (Proses Bisnis terhadap Entitas)

Keterangan: **C** = Create, **R** = Read, **U** = Update, **D** = Delete.

| Proses Bisnis | Pelanggan | Kategori Produk | Produk | Pesanan | Detail Pesanan | Pembayaran | Pengiriman |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01** Registrasi & Akun Pelanggan | **C, U** | - | - | R | - | - | - |
| **PB-02** Kelola Katalog & Stok | - | **C, R, U** | **C, R, U** | - | - | - | - |
| **PB-03** Buat Pesanan (*Checkout*) | R | R | R, **U** | **C** | **C** | - | - |
| **PB-04** Pembayaran & Verifikasi | R | - | - | **U** | R | **C, U** | - |
| **PB-05** Pemenuhan & Kirim Pesanan | R | - | - | **U** | R | R | **C, U** |
| **PB-06** Laporan & Analitik Kinerja | R | R | R | R | R | R | R |

*Evaluasi Tata Kelola*: Seluruh entitas memiliki operasi **C** (Create) dan **R** (Read). Tidak ada entitas "yatim", dan seluruh interaksi proses bisnis berjalan harmonis.

---

## 8. Kamus Data Awal (Data Dictionary)

| No | Nama Kolom / Atribut | Arti & Keterangan | Format / Tipe Data | Contoh Nilai | Aturan Validasi | Penanggung Jawab (Data Steward) |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `id_pelanggan` | ID unik internal sistem pelanggan | INT, Auto Increment | `1` | Kunci Primer (PK) | Admin Penjualan |
| 2 | `kode_pelanggan` | Kode unik kartu anggota pelanggan | VARCHAR(12) | `CUST-0037` | Unik, Format `CUST-xxxx` | Admin Penjualan |
| 3 | `nama_pelanggan` | Nama lengkap pembeli | VARCHAR(100) | `Bagas Dwi Sanjaya` | Wajib diisi (NOT NULL) | Admin Penjualan |
| 4 | `email_pelanggan` | Surel login dan notifikasi pelanggan | VARCHAR(100) | `bagas.bds@contoh.id` | Unik, Format email valid | Admin Penjualan |
| 5 | `no_hp_pelanggan` | Nomor telepon/WhatsApp pembeli | VARCHAR(15) | `081277880037` | Data Pribadi (UU PDP), Valid | Admin Penjualan |
| 6 | `alamat_pelanggan` | Alamat domisili tetap pelanggan | TEXT | `Jl. Cendekia No. 37, Kota Metro` | Data Pribadi, Lengkap | Admin Penjualan |
| 7 | `id_kategori` | ID unik internal kategori | SMALLINT, AI | `1` | Kunci Primer (PK) | Admin Katalog |
| 8 | `nama_kategori` | Nama klasifikasi produk | VARCHAR(50) | `Aksesoris Komputer` | Wajib diisi | Admin Katalog |
| 9 | `id_produk` | ID unik master produk | INT, Auto Increment | `10` | Kunci Primer (PK) | Petugas Gudang |
| 10 | `kode_produk` | SKU/Barcode produk | VARCHAR(20) | `PRD-ACC-03` | Unik, Format kategori-id | Petugas Gudang |
| 11 | `nama_produk` | Nama produk barang dagangan | VARCHAR(150) | `Mouse Wireless Logitech M170` | Wajib diisi | Petugas Gudang |
| 12 | `harga_jual_produk` | Harga patokan jual katalog saat ini | DECIMAL(12,2) | `145000.00` | Angka uang >= 0 | Admin Katalog |
| 13 | `stok_produk` | Jumlah stok barang fisik tersedia | INT | `45` | Angka bulat >= 0 (AB-09) | Petugas Gudang |
| 14 | `stok_min_produk` | Ambang batas aman stok minimum | INT | `5` | Angka bulat >= 0 (KI-03) | Petugas Gudang |
| 15 | `id_pesanan` | ID unik internal pesanan | INT, Auto Increment | `101` | Kunci Primer (PK) | Admin Penjualan |
| 16 | `no_pesanan` | Nomor invoice transaksi pesanan | VARCHAR(25) | `ORD-20261011-0037` | Unik (AB-01) | Admin Penjualan |
| 17 | `tgl_pesanan` | Waktu saat pemesanan dibuat | DATETIME | `2026-10-11 14:35:10` | Wajib diisi | Admin Penjualan |
| 18 | `diskon_pesanan` | Nilai nominal potongan kupon promo | DECIMAL(12,2) | `7000.00` | Nilai promo P% = 2% (AB-05) | Admin Penjualan |
| 19 | `ongkir_pesanan` | Biaya kirim tarif kurir ekspedisi | DECIMAL(12,2) | `15000.00` | Angka uang >= 0 | Petugas Logistik |
| 20 | `status_pesanan` | Status siklus hidup pesanan | ENUM | `'lunas'` | `menunggu`, `lunas`, `dikirim`, `selesai`, `batal` | Admin Penjualan |
| 21 | `qty_detail_pesanan` | Jumlah unit barang yang dipesan | SMALLINT | `2` | Angka bulat > 0 (AB-03) | Admin Penjualan |
| 22 | `harga_satuan_detail_pesanan` | Harga jual produk saat checkout | DECIMAL(12,2) | `85000.00` | Angka uang >= 0 (AB-04) | Admin Penjualan |
| 23 | `no_transaksi_pembayaran` | Nomor referensi bayar perbankan | VARCHAR(50) | `PAY-20261011-77881` | Unik per transaksi bayar | Staf Keuangan |
| 24 | `metode_pembayaran` | Kanal pembayaran yang dipilih | VARCHAR(30) | `QRIS ShopeePay` | Pilihan terverifikasi | Staf Keuangan |
| 25 | `nominal_pembayaran` | Jumlah rupiah yang disetor | DECIMAL(12,2) | `358000.00` | Harus sama dengan total tagihan | Staf Keuangan |
| 26 | `no_resi_pengiriman` | Nomor resi pelacakan ekspedisi | VARCHAR(40) | `JNE-992384037` | Unik resmi kurir (AB-08) | Petugas Logistik |
| 27 | `nama_ekspedisi` | Nama perusahaan kurir logistik | VARCHAR(50) | `JNE Express Reguler` | Wajib diisi | Petugas Logistik |
| 28 | `status_pengiriman` | Status pergerakan paket barang | ENUM | `'dikirim'` | `diproses`, `dikirim`, `diterima` | Petugas Logistik |

---

## 9. Kebutuhan Non-Fungsional dan Perhitungan Parameter Personal ($P$)

### 9.1 Perhitungan Parameter Personal Berbasis NIM

Sesuai pedoman buku praktikum Modul 2 bagian Petunjuk Tugas Mandiri:

- **NIM Mahasiswa**: `25430037`
- **Dua Digit Terakhir NIM**: $37$
- **Perhitungan Rumus Parameter $P$**:
  $$P = (2\text{ digit terakhir NIM} \pmod 9) + 1$$
  $$P = (37 \pmod 9) + 1$$
  $$P = 1 + 1 = \mathbf{2}$$

### 9.2 Penerapan Parameter $P = 2$ pada Batasan Bisnis Proyek

1. **Batas Maksimal Variasi Item per Transaksi**:
   $$\text{Maksimal Item} = P + 2 = 2 + 2 = \mathbf{4}\text{ jenis produk berbeda per transaksi invoice.}$$
2. **Persentase Kupon Diskon Belanja Toko**:
   $$\text{Diskon Promo} = P\% = \mathbf{2\%}\text{ dari subtotal nilai belanja produk.}$$
3. **Perkiraan Rata-Rata Volume Transaksi Harian**:
   $$\text{Estimasi Transaksi Harian} = 40 + (5 \times P) = 40 + (5 \times 2) = \mathbf{50}\text{ transaksi pemesanan per hari.}$$

### 9.3 Kebutuhan Non-Fungsional Teknis & Pelindungan Data Pribadi

1. **Volume dan Kapasitas Data**:
   - Dengan 50 transaksi per hari dan rata-rata 3 rincian produk per transaksi, sistem menampung sekitar 1.500 transaksi pesanan dan 4.500 baris rincian barang per bulan.
2. **Retensi Data**:
   - Seluruh data transaksi penjualan, audit pembayaran, dan histori pengiriman disimpan sekurang-kurangnya 5 (lima) tahun guna kepatuhan perpajakan dan audit pembukuan niaga elektronik.
3. **Pelindungan Data Pribadi (UU No. 27 Tahun 2022)**:
   - Data `no_hp_pelanggan`, `email_pelanggan`, dan `alamat_pelanggan` diklasifikasikan sebagai data pribadi pembeli.
   - Hak akses data pribadi dibatasi secara ketat (*Least Privilege*): pihak kurir/pengiriman hanya melihat nama, nomor kontak, dan alamat penerima; staf keuangan hanya melihat bukti nominal bayar tanpa akses data alamat; sedangkan data mentah nomor kontak disamarkan dari publik.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Kelengkapan (*Completeness*)**:
   - Memastikan tidak ada transaksi pesanan yang "menggantung" tanpa adanya rincian barang yang dibeli (dicegah melalui transaksi atomik).
2. **Akurasi & Integritas (*Accuracy & Integrity*)**:
   - Mencegah inkonsistensi stok barang melalui constraint server `CHECK (stok_produk >= 0)`.
   - Menghindari selisih nominal pembayaran dengan memvalidasi kesamaan `nominal_pembayaran` terhadap `total_pesanan` sebelum pesanan diserahkan ke bagian gudang.
3. **Konsistensi Format (*Consistency*)**:
   - Memastikan format nomor resi kurir dan invoice terstandar, serta alamat email pelanggan divalidasi pola sintaksnya (`regex/@`).
4. **Validitas Historis (*Historical Fidelity*)**:
   - Memastikan harga beli pada saat transaksi disimpan permanen di tabel rincian pesanan sehingga laporan keuangan masa lalu tidak berubah saat harga master produk disesuaikan.
