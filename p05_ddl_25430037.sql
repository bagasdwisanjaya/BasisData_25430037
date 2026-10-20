-- ==============================================================================
-- BUKU PRAKTIKUM BASIS DATA - SEMESTER 3 (UM METRO 2026/2027)
-- Modul 5: DDL dan Tipe Data
-- Tugas Mandiri: Milestone Proyek 5 - Desain Fisik DDL Toko Daring
-- File        : p05_ddl_25430037.sql
-- Praktikan   : Bagas Dwi Sanjaya (NIM: 25430037)
-- Kelas       : Kelas B, Ilmu Komputer - Semester 3
-- Basis Data  : toko_037
-- Tema Proyek : Toko Daring (Toko Daring Sentosa BDS)
-- Parameter P : P = (37 mod 9) + 1 = 2 (Diskon 2%, Maks Variasi Item = 4)
-- RDBMS Target: MariaDB 10.4.32 / MySQL 8.0 (Engine: InnoDB)
-- Karakteristik: Idempotent (Dapat dieksekusi berulang kali dari basis data bersih)
-- ==============================================================================

USE toko_037;

-- ------------------------------------------------------------------------------
-- 1. PENGHAPUSAN TABEL DENGAN URUTAN TERBALIK (Idempotensi Skrip)
-- Urutan: pengiriman -> pembayaran -> detail_pesanan -> pesanan -> produk -> kategori -> pelanggan
-- ------------------------------------------------------------------------------

DROP TABLE IF EXISTS pengiriman;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;

-- ------------------------------------------------------------------------------
-- 2. PEMBUATAN TABEL INDUK / MASTER (Tanpa Kunci Tamu)
-- Urutan: pelanggan -> kategori
-- ------------------------------------------------------------------------------

-- Tabel 1: pelanggan (Master Pelanggan Toko Daring)
-- Mencatat pengguna e-commerce terdaftar.
-- kode_pelanggan dan email_pelanggan bersifat UNIQUE.
-- no_hp dan alamat adalah data pribadi (UU PDP, boleh NULL pada profil awal).
CREATE TABLE pelanggan (
    id_pelanggan INT NOT NULL AUTO_INCREMENT,
    kode_pelanggan VARCHAR(12) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    email_pelanggan VARCHAR(100) NOT NULL,
    no_hp_pelanggan VARCHAR(15) NULL,
    alamat_pelanggan TEXT NULL,
    tgl_daftar_pelanggan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pelanggan),
    UNIQUE KEY uq_pelanggan_kode (kode_pelanggan),
    UNIQUE KEY uq_pelanggan_email (email_pelanggan)
) ENGINE=InnoDB;

-- Tabel 2: kategori (Master Klasifikasi Produk)
-- Mengelompokkan komoditas produk (misal: Elektronik, Fashion, Kuliner).
CREATE TABLE kategori (
    id_kategori SMALLINT NOT NULL AUTO_INCREMENT,
    kode_kategori VARCHAR(10) NOT NULL,
    nama_kategori VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_kategori),
    UNIQUE KEY uq_kategori_kode (kode_kategori)
) ENGINE=InnoDB;

-- ------------------------------------------------------------------------------
-- 3. PEMBUATAN TABEL KATALOG DAN TRANSAKSI UTAMA
-- Urutan: produk -> pesanan -> detail_pesanan -> pembayaran -> pengiriman
-- ------------------------------------------------------------------------------

-- Tabel 3: produk (Master Katalog Produk)
-- Memuat relasi FK ke kategori.
-- Dilengkapi konstrain CHECK harga non-negatif dan stok non-negatif (AB-09).
-- Batas stok minimum default 5 untuk peringatan dini (KI-03).
CREATE TABLE produk (
    id_produk INT NOT NULL AUTO_INCREMENT,
    kode_produk VARCHAR(20) NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    id_kategori SMALLINT NOT NULL,
    harga_jual_produk DECIMAL(12,2) NOT NULL,
    stok_produk INT NOT NULL DEFAULT 0,
    stok_min_produk INT NOT NULL DEFAULT 5,
    PRIMARY KEY (id_produk),
    UNIQUE KEY uq_produk_kode (kode_produk),
    CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) 
        REFERENCES kategori (id_kategori),
    CONSTRAINT ck_produk_harga CHECK (harga_jual_produk >= 0),
    CONSTRAINT ck_produk_stok CHECK (stok_produk >= 0),
    CONSTRAINT ck_produk_stok_min CHECK (stok_min_produk >= 0)
) ENGINE=InnoDB;

-- Tabel 4: pesanan (Header Dokumen Checkout Pesanan)
-- Mencatat transaksi pembelian daring oleh pelanggan terdaftar.
-- Format no_pesanan unik (AB-01).
-- diskon_pesanan default 0.00, memfasilitasi promo P = 2% (AB-05).
CREATE TABLE pesanan (
    id_pesanan INT NOT NULL AUTO_INCREMENT,
    no_pesanan VARCHAR(25) NOT NULL,
    tgl_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_pelanggan INT NOT NULL,
    diskon_pesanan DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ongkir_pesanan DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status_pesanan ENUM('menunggu','lunas','dikirim','selesai','dibatalkan') NOT NULL DEFAULT 'menunggu',
    PRIMARY KEY (id_pesanan),
    UNIQUE KEY uq_pesanan_nomor (no_pesanan),
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) 
        REFERENCES pelanggan (id_pelanggan),
    CONSTRAINT ck_pesanan_diskon CHECK (diskon_pesanan >= 0),
    CONSTRAINT ck_pesanan_ongkir CHECK (ongkir_pesanan >= 0)
) ENGINE=InnoDB;

-- Tabel 5: detail_pesanan (Entitas Asosiatif Rincian Pesanan)
-- Memecah relasi M:N antara pesanan dan produk.
-- Kunci primer komposit (id_pesanan, id_produk).
-- Batasan kuantitas per baris: CHECK (qty > 0 AND qty <= 4) sesuai aturan P+2 = 4 (AB-02).
-- harga_satuan_detail_pesanan snapshot harga saat checkout (AB-04).
CREATE TABLE detail_pesanan (
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    qty_detail_pesanan SMALLINT NOT NULL,
    harga_satuan_detail_pesanan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pesanan, id_produk),
    CONSTRAINT fk_detail_pesanan_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk) 
        REFERENCES produk (id_produk),
    CONSTRAINT ck_detail_pesanan_qty CHECK (qty_detail_pesanan > 0 AND qty_detail_pesanan <= 4),
    CONSTRAINT ck_detail_pesanan_harga CHECK (harga_satuan_detail_pesanan >= 0)
) ENGINE=InnoDB;

-- Tabel 6: pembayaran (Transaksi Finansial Gateway/Transfer)
-- Relasi One-to-Zero-or-One (1 : 0..1) terhadap pesanan melalui UNIQUE KEY (id_pesanan).
-- no_transaksi_pembayaran unik dari gateway perbankan.
CREATE TABLE pembayaran (
    id_pembayaran INT NOT NULL AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    no_transaksi_pembayaran VARCHAR(50) NOT NULL,
    metode_pembayaran VARCHAR(30) NOT NULL,
    tgl_pembayaran DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nominal_pembayaran DECIMAL(12,2) NOT NULL,
    status_pembayaran ENUM('pending','verifikasi','gagal') NOT NULL DEFAULT 'pending',
    PRIMARY KEY (id_pembayaran),
    UNIQUE KEY uq_pembayaran_pesanan (id_pesanan),
    UNIQUE KEY uq_pembayaran_notransaksi (no_transaksi_pembayaran),
    CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
    CONSTRAINT ck_pembayaran_nominal CHECK (nominal_pembayaran > 0)
) ENGINE=InnoDB;

-- Tabel 7: pengiriman (Transaksi Logistik dan Ekspedisi Kurir)
-- Relasi One-to-Zero-or-One (1 : 0..1) terhadap pesanan melalui UNIQUE KEY (id_pesanan).
-- no_resi_pengiriman unik dari pihak ekspedisi kurir (AB-08).
CREATE TABLE pengiriman (
    id_pengiriman INT NOT NULL AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    no_resi_pengiriman VARCHAR(40) NOT NULL,
    nama_ekspedisi VARCHAR(50) NOT NULL,
    alamat_kirim_pengiriman TEXT NOT NULL,
    status_pengiriman ENUM('diproses','dikirim','terima') NOT NULL DEFAULT 'diproses',
    tgl_kirim_pengiriman DATETIME NULL,
    PRIMARY KEY (id_pengiriman),
    UNIQUE KEY uq_pengiriman_pesanan (id_pesanan),
    UNIQUE KEY uq_pengiriman_resi (no_resi_pengiriman),
    CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan (id_pesanan) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 4. VERIFIKASI STRUKTUR TABEL
-- ==============================================================================

SHOW TABLES;
DESCRIBE pelanggan;
DESCRIBE kategori;
DESCRIBE produk;
DESCRIBE pesanan;
DESCRIBE detail_pesanan;
DESCRIBE pembayaran;
DESCRIBE pengiriman;

-- ==============================================================================
-- 5. PEMBUKTIAN KETEGASAN CONSTRAINT SERVER PADA TOKO DARING
-- ==============================================================================

-- 5.1 Memasukkan Data Induk Uji Coba
INSERT INTO pelanggan (kode_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan)
VALUES ('PLG-001', 'Bagas Dwi Sanjaya', 'bagasdwisanjaya24@gmail.com', '081234567890', 'Jl. Ki Hajar Dewantara No. 15, Metro Timur');

INSERT INTO kategori (kode_kategori, nama_kategori)
VALUES ('KAT-01', 'Elektronik & Gadget');

INSERT INTO produk (kode_produk, nama_produk, id_kategori, harga_jual_produk, stok_produk, stok_min_produk)
VALUES ('PRD-001', 'Mouse Wireless Silent Click', 1, 125000.00, 25, 5);

-- 5.2 Uji Coba CHECK Maksimal Variasi Kuantitas (P+2 = 4)
-- Kueri berikut akan DITOLAK server jika qty_detail_pesanan > 4
INSERT INTO pesanan (no_pesanan, id_pelanggan, diskon_pesanan, ongkir_pesanan, status_pesanan)
VALUES ('ORD-202610-0001', 1, 2500.00, 15000.00, 'menunggu');

-- Percobaan sah (qty = 3 <= 4) -> BERHASIL
INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
VALUES (1, 1, 3, 125000.00);

-- Percobaan pelanggaran (qty = 5 > 4) -> DITOLAK Error CHECK
-- INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
-- VALUES (1, 1, 5, 125000.00);

-- ==============================================================================
-- Akhir dari berkas p05_ddl_25430037.sql
-- ==============================================================================

