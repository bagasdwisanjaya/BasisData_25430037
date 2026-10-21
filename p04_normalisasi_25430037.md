# Dokumen Normalisasi Basis Data - Toko Daring Sentosa BDS

**Nama Praktikan:** Bagas Dwi Sanjaya  
**NIM:** 25430037  
**Kelas:** Kelas B, Ilmu Komputer - Semester 3  
**Mata Kuliah:** Praktikum Basis Data (Semester 3)  
**Tema Proyek:** Toko Daring (Kode: `toko`)  
**Nama Organisasi:** Toko Daring Sentosa BDS  
**Milestone:** 4 - Normalisasi Basis Data Relasional (UNF $\rightarrow$ 1NF $\rightarrow$ 2NF $\rightarrow$ 3NF)  
**Parameter Personalisasi:** $P = (37 \pmod 9) + 1 = 1 + 1 = 2$  
**Tahun Akademik:** 2026/2027  

---

## 1. Dokumen Sumber Fiktif yang Dianalisis

Normalisasi diturunkan secara langsung dari dokumen transaksi operasional riil Toko Daring Sentosa BDS, yaitu lembar **Invoice Pemesanan Daring (*Online Sales Order Invoice*)**:

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
No  Kode Produk   Nama Produk                Kategori     Qty   Harga Satuan   Subtotal (Rp)
--  -----------   ------------------------   ---------    ---   ------------   -------------
1.  PRD-ELK-01    Flashdisk Sandisk 64GB     Elektronik     2     Rp  85.000     Rp 170.000
2.  PRD-ACC-03    Mouse Wireless Logitech    Aksesori       1     Rp 145.000     Rp 145.000
3.  PRD-ACC-09    Kabel Data Type-C 100W     Aksesori       1     Rp  35.000     Rp  35.000
----------------------------------------------------------------------------------------
Total Variasi Item Produk    : 3 Jenis (Maksimal 4 Jenis Item Sesuai P+2)
Subtotal Produk              : Rp 350.000
Diskon Kupon Promo (P = 2%)  : Rp   7.000   (Dihitung dari Parameter P = 2%)
Biaya Ongkos Kirim           : Rp  15.000
----------------------------------------------------------------------------------------
TOTAL TAGIHAN PEMBAYARAN     : Rp 358.000
Nomor Transaksi Pembayaran   : TRX-QRIS-20261011-0037
Nominal Dibayar              : Rp 358.000   [STATUS: LUNAS VERIFIKASI]
========================================================================================
```

---

## 2. Tahap 0: Bentuk Tidak Ternormalisasi (UNF / Unnormalized Form)

Bentuk tidak ternormalisasi (*Unnormalized Form* / UNF) merepresentasikan seluruh atribut yang tertulis pada dokumen invoice apa adanya tanpa pemecahan tabel, di mana masih terdapat kelompok berulang (*repeating group*) pada bagian rincian barang belanjaan.

### Tabel UNF (Memuat Repeating Group)

| Atribut Dokumen Sumber | Keterangan Format Nilai | Sifat Nilai |
| --- | --- | --- |
| `no_pesanan` | `ORD-20261011-0037` | Skalar tunggal |
| `tgl_pesanan` | `2026-10-11 14:35:10` | Skalar tunggal |
| `kode_pelanggan` | `CUST-0037` | Skalar tunggal |
| `nama_pelanggan` | `Bagas Dwi Sanjaya` | Skalar tunggal |
| `email_pelanggan` | `bagas.bds@contoh.id` | Skalar tunggal |
| `no_hp_pelanggan` | `0812-7788-0037` | Skalar tunggal |
| `alamat_kirim_pengiriman` | `Jl. Cendekia No. 37, Kota Metro` | Skalar tunggal |
| **Rincian Barang** *(Repeating Group)* | `{ [PRD-ELK-01, Flashdisk 64GB, Elektronik, 2, 85000], [PRD-ACC-03, Mouse Wireless, Aksesori, 1, 145000], [PRD-ACC-09, Kabel Type-C, Aksesori, 1, 35000] }` | **Koleksi Multi-Nilai (Array/Tuple List)** |
| `diskon_pesanan` | `7000.00` | Skalar tunggal |
| `ongkir_pesanan` | `15000.00` | Skalar tunggal |
| `status_pesanan` | `lunas` | Skalar tunggal |
| `no_transaksi_pembayaran` | `TRX-QRIS-20261011-0037` | Skalar tunggal |
| `metode_pembayaran` | `QRIS / E-WALLET` | Skalar tunggal |
| `nominal_pembayaran` | `358000.00` | Skalar tunggal |
| `no_resi_pengiriman` | `JNE-992384037` | Skalar tunggal |
| `nama_ekspedisi` | `JNE Express (Reguler)` | Skalar tunggal |
| `status_pengiriman` | `dikirim` | Skalar tunggal |

> **Anatomi Masalah UNF:**
> Keberadaan *repeating group* menyebabkan baris data tidak teratur dan tidak dapat dipetakan langsung ke tabel relasional RDBMS karena menyalahi definisi relasi matematis.

---

## 3. Tahap 1: Bentuk Normal Pertama (1NF / First Normal Form)

### 3.1 Aturan Pembentukan 1NF
Sebuah relasi dikatakan memenuhi **Bentuk Normal Pertama (1NF)** jika dan hanya jika:
1. Tidak ada kelompok berulang (*no repeating groups*); setiap baris mewakili entri individual.
2. Setiap perpotongan baris dan kolom hanya memuat tepat satu nilai atomik (*atomic value* / tidak dapat dibagi lagi).
3. Telah ditentukan kunci primer (*primary key*) yang dapat mengidentifikasi setiap baris secara unik.

### 3.2 Penentuan Kunci Primer 1NF
Dengan mendatarkan (*flattening*) kelompok berulang, satu invoice kini dipecah menjadi beberapa baris sesuai banyaknya item barang. Kunci primer yang mampu membedakan setiap baris secara unik adalah **kunci komposit**:
$$\mathbf{PK} = (\mathtt{no\_pesanan}, \mathtt{kode\_produk})$$

### 3.3 Struktur Tabel 1NF
`pesanan_1nf` (
  **`no_pesanan`** [PK],
  **`kode_produk`** [PK],
  `tgl_pesanan`,
  `kode_pelanggan`,
  `nama_pelanggan`,
  `email_pelanggan`,
  `no_hp_pelanggan`,
  `kode_kategori`,
  `nama_kategori`,
  `nama_produk`,
  `harga_jual_master`,
  `qty_detail_pesanan`,
  `harga_satuan_detail_pesanan`,
  `diskon_pesanan`,
  `ongkir_pesanan`,
  `status_pesanan`,
  `no_transaksi_pembayaran`,
  `metode_pembayaran`,
  `nominal_pembayaran`,
  `no_resi_pengiriman`,
  `nama_ekspedisi`,
  `alamat_kirim_pengiriman`,
  `status_pengiriman`
)

### 3.4 Identifikasi Anomali pada 1NF
Pada 1NF, timbul **redundansi berat** karena data pelanggan, alamat, dan nota pesanan diulang sebanyak variasi barang yang dibeli ($3$ kali pada invoice di atas). Hal ini memicu tiga anomali:
1. **Anomali Penyisipan (*Insert Anomaly*):** Produk baru belum dapat didaftarkan ke sistem katalog jika belum pernah ada transaksi pemesanan (`no_pesanan` bernilai `NULL` dilarang karena merupakan bagian dari PK komposit).
2. **Anomali Pembaruan (*Update Anomaly*):** Jika pelanggan mengganti nomor telepon, pembaruan harus dilakukan di seluruh baris pesanan lama. Inkonsistensi data terjadi jika salah satu baris terlewat.
3. **Anomali Penghapusan (*Delete Anomaly*):** Jika satu-satunya pesanan yang memuat produk tertentu dibatalkan, data deskripsi dan harga produk tersebut ikut hilang dari sistem.

---

## 4. Tahap 2: Bentuk Normal Kedua (2NF / Second Normal Form)

### 4.1 Aturan Pembentukan 2NF
Sebuah relasi memenuhi **Bentuk Normal Kedua (2NF)** jika dan hanya jika:
1. Relasi telah memenuhi persyaratan 1NF.
2. Tidak memuat **Dependensi Parsial (*Partial Functional Dependency*)**, artinya seluruh atribut non-kunci wajib bergantung fungsional secara **penuh (*Full Functional Dependency*)** pada seluruh komponen Kunci Primer komposit, bukan hanya pada sebagian kunci primer.

### 4.2 Analisis Dependensi Parsial pada 1NF
Kunci Primer Komposit: $(\mathtt{no\_pesanan}, \mathtt{kode\_produk})$
- $\mathtt{no\_pesanan} \rightarrow \mathtt{tgl\_pesanan}, \mathtt{kode\_pelanggan}, \mathtt{diskon\_pesanan}, \mathtt{ongkir\_pesanan}, \mathtt{status\_pesanan}, \dots$  
  *(Atribut-atribut ini hanya bergantung pada `no_pesanan`, BUKAN pada `kode_produk` $\rightarrow$ **Dependensi Parsial 1**).*
- $\mathtt{kode\_produk} \rightarrow \mathtt{nama\_produk}, \mathtt{kode\_kategori}, \mathtt{nama\_kategori}, \mathtt{harga\_jual\_master}$  
  *(Atribut-atribut katalog hanya bergantung pada `kode_produk`, BUKAN pada `no_pesanan` $\rightarrow$ **Dependensi Parsial 2**).*
- $(\mathtt{no\_pesanan}, \mathtt{kode\_produk}) \rightarrow \mathtt{qty\_detail\_pesanan}, \mathtt{harga\_satuan\_detail\_pesanan}$  
  *(Hanya kuantitas beli dan snapshot harga satuan yang bergantung PENUH pada kedua kunci $\rightarrow$ **Dependensi Penuh**).*

### 4.3 Dekomposisi Menjadi 2NF
Untuk menghilangkan dependensi parsial, relasi dipecah menjadi tiga tabel:

1. **`pesanan_2nf`** (Menampung atribut yang bergantung pada `no_pesanan`):  
   (**`no_pesanan`** [PK], `tgl_pesanan`, `kode_pelanggan`, `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `diskon_pesanan`, `ongkir_pesanan`, `status_pesanan`, `no_transaksi_pembayaran`, `metode_pembayaran`, `nominal_pembayaran`, `no_resi_pengiriman`, `nama_ekspedisi`, `alamat_kirim_pengiriman`, `status_pengiriman`)
2. **`produk_2nf`** (Menampung atribut yang bergantung pada `kode_produk`):  
   (**`kode_produk`** [PK], `nama_produk`, `kode_kategori`, `nama_kategori`, `harga_jual_master`)
3. **`detail_pesanan_2nf`** (Menampung atribut berdependensi penuh):  
   (**`no_pesanan`** [PK,FK], **`kode_produk`** [PK,FK], `qty_detail_pesanan`, `harga_satuan_detail_pesanan`)

---

## 5. Tahap 3: Bentuk Normal Ketiga (3NF / Third Normal Form)

### 5.1 Aturan Pembentukan 3NF
Sebuah relasi memenuhi **Bentuk Normal Ketiga (3NF)** jika dan hanya jika:
1. Relasi telah memenuhi persyaratan 2NF.
2. Tidak memuat **Dependensi Transitif (*Transitive Dependency*)**, artinya tidak ada atribut non-kunci yang bergantung fungsional pada atribut non-kunci lainnya ($X \rightarrow Y$ dan $Y \rightarrow Z$, maka $X \rightarrow Z$ secara tidak langsung melalui atribut penentu bukan-kunci $Y$).

### 5.2 Analisis Dependensi Transitif pada 2NF

1. **Pada Tabel `pesanan_2nf`:**
   - Kunci Primer: `no_pesanan`.
   - Dependensi Transitif Pelanggan:  
     $\mathtt{no\_pesanan} \rightarrow \mathtt{kode\_pelanggan}$, dan $\mathtt{kode\_pelanggan} \rightarrow \mathtt{nama\_pelanggan}, \mathtt{email\_pelanggan}, \mathtt{no\_hp\_pelanggan}$.  
     *(Data profil pelanggan bergantung pada `kode_pelanggan`, bukan intrinsik pada `no_pesanan`).*
   - Dependensi Transitif Transaksi Pembayaran:  
     $\mathtt{no\_pesanan} \rightarrow \mathtt{no\_transaksi\_pembayaran}$, dan $\mathtt{no\_transaksi\_pembayaran} \rightarrow \mathtt{metode\_pembayaran}, \mathtt{nominal\_pembayaran}$.  
     *(Kanal pembayaran berelasi logis finansial 1:0..1 tersendiri).*
   - Dependensi Transitif Logistik Pengiriman:  
     $\mathtt{no\_pesanan} \rightarrow \mathtt{no\_resi\_pengiriman}$, dan $\mathtt{no\_resi\_pengiriman} \rightarrow \mathtt{nama\_ekspedisi}, \mathtt{alamat\_kirim\_pengiriman}, \mathtt{status\_pengiriman}$.  
     *(Pengiriman logistik berelasi logis 1:0..1 tersendiri).*
2. **Pada Tabel `produk_2nf`:**
   - Kunci Primer: `kode_produk`.
   - Dependensi Transitif Kategori:  
     $\mathtt{kode\_produk} \rightarrow \mathtt{kode\_kategori}$, dan $\mathtt{kode\_kategori} \rightarrow \mathtt{nama\_kategori}$.  
     *(Nama kategori ditentukan oleh kode kategori, bukan kode produk individual).*

### 5.3 Dekomposisi Menjadi Skema Relasional 3NF Final

Menghilangkan seluruh dependensi transitif menghasilkan **7 tabel relasional kanonik 3NF**:

1. **`pelanggan`** (Master Data):  
   (`id_pelanggan` [PK], `kode_pelanggan` [UQ], `nama_pelanggan`, `email_pelanggan` [UQ], `no_hp_pelanggan`, `alamat_pelanggan`, `tgl_daftar_pelanggan`)
2. **`kategori`** (Master Klasifikasi):  
   (`id_kategori` [PK], `kode_kategori` [UQ], `nama_kategori`)
3. **`produk`** (Master Katalog Persediaan):  
   (`id_produk` [PK], `kode_produk` [UQ], `nama_produk`, `id_kategori` [FK], `harga_jual_produk`, `stok_produk`, `stok_min_produk`)
4. **`pesanan`** (Header Transaksi Penjualan):  
   (`id_pesanan` [PK], `no_pesanan` [UQ], `tgl_pesanan`, `id_pelanggan` [FK], `diskon_pesanan`, `ongkir_pesanan`, `status_pesanan`)
5. **`detail_pesanan`** (Entitas Asosiatif):  
   (`id_pesanan` [PK,FK], `id_produk` [PK,FK], `qty_detail_pesanan`, `harga_satuan_detail_pesanan`)
6. **`pembayaran`** (Transaksi Finansial Gateway, 1 : 0..1):  
   (`id_pembayaran` [PK], `id_pesanan` [FK,UQ], `no_transaksi_pembayaran` [UQ], `metode_pembayaran`, `tgl_pembayaran`, `nominal_pembayaran`, `status_pembayaran`)
7. **`pengiriman`** (Transaksi Logistik Kurir, 1 : 0..1):  
   (`id_pengiriman` [PK], `id_pesanan` [FK,UQ], `no_resi_pengiriman` [UQ], `nama_ekspedisi`, `alamat_kirim_pengiriman`, `status_pengiriman`, `tgl_kirim_pengiriman`)

---

## 6. Daftar Dependensi Fungsional (Functional Dependencies) Proyek Mandiri

Setiap Dependensi Fungsional (FD) dirumuskan berdasarkan aturan bisnis resmi Toko Daring Sentosa BDS dengan parameter personalisasi NIM $P = 2$:

| Kode FD | Pernyataan Dependensi Fungsional | Determinan Kunci | Atribut yang Ditentukan | Aturan Bisnis Pendukung |
| --- | --- | --- | --- | --- |
| **FD-01** | $\mathtt{kode\_pelanggan} \rightarrow \mathtt{nama}, \mathtt{email}, \mathtt{no\_hp}, \mathtt{alamat}, \mathtt{tgl\_daftar}$ | `kode_pelanggan` | Data identitas dan kontak pelanggan | PB-01 (Registrasi akun pembeli) |
| **FD-02** | $\mathtt{kode\_kategori} \rightarrow \mathtt{nama\_kategori}$ | `kode_kategori` | Nama klasifikasi produk | PB-02 (Katalog produk) |
| **FD-03** | $\mathtt{kode\_produk} \rightarrow \mathtt{nama\_produk}, \mathtt{id\_kategori}, \mathtt{harga\_jual}, \mathtt{stok}, \mathtt{stok\_min}$ | `kode_produk` | Informasi barang, harga katalog, dan stok | PB-02, AB-03, AB-09 (Stok non-negatif) |
| **FD-04** | $\mathtt{no\_pesanan} \rightarrow \mathtt{tgl\_pesanan}, \mathtt{id\_pelanggan}, \mathtt{diskon}, \mathtt{ongkir}, \mathtt{status}$ | `no_pesanan` | Waktu transaksi, pemesan, promo $P=2\%$, kurir | PB-03, AB-01, AB-05 (Diskon promo $P=2\%$) |
| **FD-05** | $(\mathtt{no\_pesanan}, \mathtt{kode\_produk}) \rightarrow \mathtt{qty\_detail\_pesanan}, \mathtt{harga\_satuan\_detail\_pesanan}$ | Kunci Komposit | Kuantitas belanja ($qty \le P+2=4$) dan harga saat checkout | AB-02, AB-04 (Snapshot harga historis) |
| **FD-06** | $\mathtt{no\_transaksi\_pembayaran} \rightarrow \mathtt{id\_pesanan}, \mathtt{metode}, \mathtt{tgl\_bayar}, \mathtt{nominal}, \mathtt{status}$ | `no_transaksi_pembayaran` | Validasi lunas transfer gateway bank | PB-04, AB-07 (Verifikasi nominal lunas) |
| **FD-07** | $\mathtt{no\_resi\_pengiriman} \rightarrow \mathtt{id\_pesanan}, \mathtt{ekspedisi}, \mathtt{alamat\_kirim}, \mathtt{status}, \mathtt{tgl\_kirim}$ | `no_resi_pengiriman` | Pelacakan status pergerakan kurir logistik | PB-05, AB-08 (Integrasi resi kurir unik) |

---

## 7. Analisis Keputusan Nilai Turunan (Derived Attributes)

Sesuai instruksi analisis wajib Modul 4, dilakukan evaluasi mendalam terhadap penanganan atribut turunan matematis dari invoice:

| Elemen Nilai Turunan | Formula Komputasi | Keputusan Desain | Justifikasi Arsitektural & Kaidah Normalisasi |
| --- | --- | :---: | --- |
| `subtotal_item` | `qty * harga_satuan` | **TIDAK DISIMPAN** | Merupakan perkalian murni dua atribut di baris yang sama. Menyimpannya melanggar prinsip normalisasi dan menimbulkan anomali redundansi jika kuantitas diubah. |
| `diskon_pesanan` | Promo kupon $P\% = 2\%$ dari Subtotal | **DISIMPAN** | Disimpan di tabel `pesanan` karena merupakan kebijakan promo bersyarat pada saat checkout. Jika persentase promo berubah di masa depan, diskon yang sudah didapat pembeli tidak boleh berubah. |
| `total_tagihan` | `(SUM(subtotal) - diskon) + ongkir` | **TIDAK DISIMPAN** | Dihitung secara dinamis saat kueri dijalankan. Menyimpan total pada tabel induk rentan menyebabkan inkonsistensi (*data mismatch*) jika salah satu rincian item diubah atau dibatalkan. |
| `harga_satuan_detail_pesanan` | Nilai katalog `harga_jual_produk` saat transaksi | **DISIMPAN (Snapshot)** | Wajib disimpan pada tabel rincian transaksi (**AB-04**) untuk mengisolasi data historis dari kenaikan harga master di masa depan. |

---

## 8. Evaluasi Troubleshooting Umum Modul 4 (Halaman 39 Buku Praktikum)

Dalam menyusun normalisasi ini, dihindari tiga jebakan (*common pitfalls*) yang digariskan pada Halaman 39 Buku Praktikum Basis Data:

1. **Masalah 1: Dependensi disimpulkan semata-mata dari contoh data.**  
   *Evaluasi:* Mahasiswa sering kali menyimpulkan $\mathtt{kode\_produk} \rightarrow \mathtt{harga\_satuan\_detail\_pesanan}$ hanya karena pada contoh data pulpen harganya selalu sama. Dalam dokumen ini, ditegaskan bahwa contoh data hanya dapat membantah dependensi, bukan membuktikannya. Atribut `harga_satuan_detail_pesanan` diputuskan bergantung pada kunci komposit $(\mathtt{no\_pesanan}, \mathtt{kode\_produk})$ karena aturan bisnis **AB-04** menyatakan harga transaksi bersifat snapshot historis.
2. **Masalah 2: Tabel terpecah berlebihan (*over-normalization*).**  
   *Evaluasi:* Tidak semua atribut dijadikan tabel mandiri. Setiap pemisahan diuji dengan menggabungkan kembali tabel dengan kuncinya. Pemisahan hanya dilakukan jika terbukti menghilangkan anomali (*lossless-join decomposition*).
3. **Masalah 3: Kunci pengganti (*surrogate key*) dianggap menyelesaikan normalisasi.**  
   *Evaluasi:* Penambahan kolom `id_pelanggan` atau `id_produk` tidak secara otomatis menjadikan skema berstatus 3NF. Pengujian dependensi fungsional tetap ditelaah menggunakan kunci alami (*natural key*) seperti `kode_pelanggan` dan `kode_produk`.

---

## 9. Kesimpulan

Proses normalisasi dari dokumen sumber Invoice Pemesanan Toko Daring Sentosa BDS berhasil menuntaskan tahapan UNF $\rightarrow$ 1NF $\rightarrow$ 2NF $\rightarrow$ 3NF tanpa kehilangan informasi (*lossless decomposition*). Skema kanonik 3NF yang terbentuk memuat 7 entitas yang selaras 100% dengan rancangan ERD Modul 3, serta siap ditransformasikan menjadi skrip fisik SQL DDL (`CREATE TABLE`) pada Modul 5.

---
*Dokumen ini disusun secara mandiri oleh Bagas Dwi Sanjaya (NIM: 25430037) untuk memenuhi tugas wajib Praktikum Basis Data Modul 4.*
