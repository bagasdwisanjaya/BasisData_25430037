-- ==============================================================================
-- BUKU PRAKTIKUM BASIS DATA - SEMESTER 3 (UM METRO 2026/2027)
-- Modul 5: DDL dan Tipe Data
-- File        : p05_ddl_kopma_25430037.sql
-- Praktikan   : Bagas Dwi Sanjaya (NIM: 25430037)
-- Kelas       : Kelas B, Ilmu Komputer - Semester 3
-- Basis Data  : kopma_037
-- RDBMS Target: MariaDB 10.4.32 / MySQL 8.0 (Engine: InnoDB)
-- Karakteristik: Idempotent (Dapat dieksekusi berulang kali dari basis data bersih)
-- Standar Charset: Mewarisi collation basis data utf8mb4_unicode_ci (tanpa klausul tabel)
-- ==============================================================================

USE kopma_037;

-- ------------------------------------------------------------------------------
-- 1. PENGHAPUSAN TABEL DENGAN URUTAN TERBALIK (Idempotensi Skrip)
-- Aturan Dependensi: Tabel anak (referencing) harus dihapus sebelum tabel induk (referenced)
-- ------------------------------------------------------------------------------

DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ------------------------------------------------------------------------------
-- 2. PEMBUATAN TABEL INDUK / MASTER (Tanpa Kunci Tamu)
-- Urutan Pembuatan: petugas -> anggota -> barang -> pemasok
-- ------------------------------------------------------------------------------

-- Tabel 1: petugas (Master Petugas Kopma)
-- Mencatat seluruh staf/karyawan: kasir, petugas gudang, dan ketua
CREATE TABLE petugas (
    id_petugas SMALLINT NOT NULL AUTO_INCREMENT,
    kode_petugas CHAR(3) NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran_petugas ENUM('kasir','gudang','ketua') NOT NULL,
    PRIMARY KEY (id_petugas),
    UNIQUE KEY uq_petugas_kode (kode_petugas)
) ENGINE=InnoDB;

-- Tabel 2: anggota (Master Anggota Koperasi Mahasiswa)
-- Mencatat mahasiswa terdaftar berhak diskon 5% (AB-02).
-- no_anggota dan nim_anggota bernilai unik (AB-05).
-- no_hp_anggota merupakan data pribadi (UU PDP, boleh NULL).
CREATE TABLE anggota (
    id_anggota INT NOT NULL AUTO_INCREMENT,
    no_anggota CHAR(6) NOT NULL,
    nim_anggota CHAR(10) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    prodi_anggota VARCHAR(60) NOT NULL,
    no_hp_anggota VARCHAR(15) NULL,
    status_anggota ENUM('aktif','non-aktif') NOT NULL DEFAULT 'aktif',
    tgl_daftar_anggota DATE NOT NULL,
    PRIMARY KEY (id_anggota),
    UNIQUE KEY uq_anggota_no (no_anggota),
    UNIQUE KEY uq_anggota_nim (nim_anggota)
) ENGINE=InnoDB;

-- Tabel 3: barang (Master Katalog dan Persediaan Barang)
-- Menyimpan harga terkini, stok fisik, dan batas minimum stok pemesanan ulang (AB-06).
-- Dijaga konstrain CHECK agar stok_barang dan harga_jual_barang tidak negatif (AB-03).
-- Dilengkapi konstrain CHECK stok_min_barang >= 0 (Latihan E.1).
CREATE TABLE barang (
    id_barang INT NOT NULL AUTO_INCREMENT,
    kode_barang VARCHAR(10) NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang ENUM('ATK','makanan','minuman') NOT NULL,
    harga_jual_barang DECIMAL(12,2) NOT NULL,
    stok_barang INT NOT NULL DEFAULT 0,
    stok_min_barang INT NOT NULL DEFAULT 5,
    PRIMARY KEY (id_barang),
    UNIQUE KEY uq_barang_kode (kode_barang),
    CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
    CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
    CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

-- Tabel 4: pemasok (Master Mitra Pemasok Barang)
-- Mencatat vendor penyedia komoditas dagangan Kopma.
-- Tidak berelasi langsung ke barang; keterkaitan terekam via transaksi pembelian.
CREATE TABLE pemasok (
    id_pemasok INT NOT NULL AUTO_INCREMENT,
    kode_pemasok VARCHAR(10) NOT NULL,
    nama_pemasok VARCHAR(100) NOT NULL,
    telepon_pemasok VARCHAR(15) NULL,
    alamat_pemasok VARCHAR(200) NULL,
    PRIMARY KEY (id_pemasok),
    UNIQUE KEY uq_pemasok_kode (kode_pemasok)
) ENGINE=InnoDB;

-- ------------------------------------------------------------------------------
-- 3. PEMBUATAN TABEL TRANSAKSI (Memiliki Kunci Tamu)
-- Urutan Pembuatan: penjualan -> detail_penjualan -> pembelian -> detail_pembelian
-- ------------------------------------------------------------------------------

-- Tabel 5: penjualan (Header Transaksi Penjualan Kasir)
-- Mencatat dokumen nota penjualan kasir. Format nota unik PJ-YYMM-nnnn (AB-01).
-- id_anggota bernilai NULL jika pembeli umum (AB-02).
-- fk_penjualan_anggota dikonfigurasi ON DELETE SET NULL (Latihan E.2, kepatuhan UU PDP).
CREATE TABLE penjualan (
    id_penjualan INT NOT NULL AUTO_INCREMENT,
    no_nota_penjualan CHAR(12) NOT NULL,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas SMALLINT NOT NULL,
    id_anggota INT NULL,
    bayar_penjualan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan),
    UNIQUE KEY uq_penjualan_nota (no_nota_penjualan),
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) 
        REFERENCES petugas (id_petugas),
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) 
        REFERENCES anggota (id_anggota) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabel 6: detail_penjualan (Entitas Asosiatif Transaksi Penjualan)
-- Memecah relasi M:N antara penjualan dan barang.
-- Kunci primer komposit (id_penjualan, id_barang).
-- fk_detail_penjualan ON DELETE CASCADE (jika nota batal, rincian ikut terhapus).
-- fk_detail_barang RESTRICT/NO ACTION (barang berpenjualan dilarang dihapus).
-- harga_satuan_detail_penjualan mencatat snapshot harga saat transaksi (AB-04).
CREATE TABLE detail_penjualan (
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_penjualan SMALLINT NOT NULL,
    harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) 
        REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) 
        REFERENCES barang (id_barang),
    CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

-- Tabel 7: pembelian (Header Faktur Pengadaan dari Pemasok)
-- Mencatat penerimaan faktur dari mitra vendor.
-- no_faktur_pembelian tidak unik karena vendor berbeda dapat menerbitkan nomor faktur sama.
-- status_pembelian mencatat alur pesanan: 'dipesan' -> 'diterima' saat barang tiba.
CREATE TABLE pembelian (
    id_pembelian INT NOT NULL AUTO_INCREMENT,
    no_faktur_pembelian VARCHAR(20) NOT NULL,
    tgl_pembelian DATE NOT NULL,
    id_pemasok INT NOT NULL,
    status_pembelian ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',
    PRIMARY KEY (id_pembelian),
    CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) 
        REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

-- Tabel 8: detail_pembelian (Entitas Asosiatif Pengadaan Barang)
-- Memecah relasi M:N antara pembelian dan barang.
-- Kunci primer komposit (id_pembelian, id_barang).
-- harga_beli_detail_pembelian mencatat harga modal per unit.
CREATE TABLE detail_pembelian (
    id_pembelian INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_pembelian INT NOT NULL,
    harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pembelian, id_barang),
    CONSTRAINT fk_detail_pembelian FOREIGN KEY (id_pembelian) 
        REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
    CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang) 
        REFERENCES barang (id_barang),
    CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0),
    CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;

-- ==============================================================================
-- 4. VERIFIKASI STRUKTUR TABEL
-- ==============================================================================

SHOW TABLES;
DESCRIBE petugas;
DESCRIBE anggota;
DESCRIBE barang;
DESCRIBE pemasok;
DESCRIBE penjualan;
DESCRIBE detail_penjualan;
DESCRIBE pembelian;
DESCRIBE detail_pembelian;

-- ==============================================================================
-- 5. PENGUJIAN PERUBAHAN STRUKTUR TABEL (Langkah D.4 Butir 6)
-- Menambahkan kolom tgl_kedaluwarsa lalu menghapusnya kembali
-- ==============================================================================

ALTER TABLE barang 
    ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;

DESCRIBE barang;

ALTER TABLE barang 
    DROP COLUMN tgl_kedaluwarsa;

DESCRIBE barang;

-- ==============================================================================
-- 6. PEMBUKTIAN KETEGASAN CONSTRAINT SERVER (Langkah D.3 & Latihan E)
-- Catatan: Kueri sengaja ditulis untuk membuktikan server menolak data cacat.
-- ==============================================================================

-- 6.1 Memasukkan Data Induk Uji Coba
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) 
VALUES ('K01', 'Rina Astuti', 'kasir'),
       ('G01', 'Budi Santoso', 'gudang');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
VALUES ('ATK-001', 'Buku Tulis Sinar Dunia 38 Lembar', 'ATK', 4500.00, 50, 10),
       ('MKN-001', 'Roti Sari Roti Cokelat', 'makanan', 6000.00, 20, 5);

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0001', '25430037', 'Bagas Dwi Sanjaya', 'S1 Ilmu Komputer', '081234567890', 'aktif', '2026-09-01');

-- 6.2 Uji Coba Pelanggaran 1 (Foreign Key Tak Dikenal -> DITOLAK Server Error 1452)
-- Petugas dengan id_petugas = 99 tidak ada di tabel induk petugas
-- INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
-- VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000.00);

-- 6.3 Uji Coba Pelanggaran 2 (CHECK Stok Negatif -> DITOLAK Server Error 4025 / 3819)
-- Melanggar aturan bisnis AB-03 (stok_barang >= 0)
-- UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- 6.4 Uji Coba Pelanggaran 3 (UNIQUE KEY Kembar -> DITOLAK Server Error 1062)
-- Melanggar aturan integritas entitas kode unik (kode_barang 'ATK-001' sudah ada)
-- INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
-- VALUES ('ATK-001', 'Duplikat Buku Tulis', 'ATK', 4500.00);

-- 6.5 Uji Coba Latihan E.1 (CHECK Stok Minimum Negatif -> DITOLAK Server Error 4025 / 3819)
-- Melanggar aturan integritas domain stok_min_barang >= 0
-- UPDATE barang SET stok_min_barang = -5 WHERE id_barang = 1;

-- 6.6 Uji Coba Latihan E.2 (Pembuktian ON DELETE SET NULL)
-- Membuat penjualan untuk anggota A-0001
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0001', NOW(), 1, 1, 50000.00);

-- Verifikasi data awal penjualan
SELECT id_penjualan, no_nota_penjualan, id_petugas, id_anggota, bayar_penjualan 
FROM penjualan WHERE id_penjualan = 1;

-- Menghapus rekaman anggota dari tabel master
DELETE FROM anggota WHERE id_anggota = 1;

-- Verifikasi id_anggota pada penjualan otomatis menjadi NULL tanpa menghapus nota
SELECT id_penjualan, no_nota_penjualan, id_petugas, id_anggota, bayar_penjualan 
FROM penjualan WHERE id_penjualan = 1;

-- ==============================================================================
-- Akhir dari berkas p05_ddl_kopma_25430037.sql
-- ==============================================================================
