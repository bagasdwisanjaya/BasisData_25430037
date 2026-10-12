-- ==============================================================================
-- BUKU PRAKTIKUM BASIS DATA - SEMESTER 3 (UM METRO 2026/2027)
-- Modul 1: Lingkungan Kerja MariaDB di XAMPP dan Git
-- File        : p01_lingkungan_25430037.sql
-- Praktikan   : Bagas Dwi Sanjaya (NIM: 25430037)
-- Kelas       : Kelas B, Ilmu Komputer - Semester 3
-- Tanggal : 30 September 2026
-- Pertemuan : Satu (1)
-- Topik       : Inisialisasi Basis Data Praktik, Akun Kerja, dan Basis Data Proyek
-- Karakteristik : Idempotent (Dapat dijalankan berulang kali tanpa galat)
-- Catatan Keamanan: Password sengaja diganti penanda (<password_...>) sesuai
--                   petunjuk buku praktikum. JANGAN commit password asli!
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. BASIS DATA DAN AKUN PRAKTIK KOPMA (Langkah Percobaan D.4)
-- ------------------------------------------------------------------------------

-- Membuat basis data latihan Kopma dengan standar UTF-8 4-byte (utf8mb4)
CREATE DATABASE IF NOT EXISTS kopma_037
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Membuat akun kerja mahasiswa untuk latihan Kopma
CREATE USER IF NOT EXISTS 'mhs_037'@'localhost'
  IDENTIFIED BY '<password_kerja_mhs>';

-- Memberikan hak akses penuh hanya pada objek dalam basis data kopma_037
GRANT ALL PRIVILEGES ON kopma_037.* TO 'mhs_037'@'localhost';


-- ------------------------------------------------------------------------------
-- 2. AKUN TAMU HAK AKSES TERBATAS (Latihan & Modifikasi E.1)
-- ------------------------------------------------------------------------------

-- Membuat akun tamu khusus pembacaan (Read-Only)
CREATE USER IF NOT EXISTS 'tamu_037'@'localhost'
  IDENTIFIED BY '<password_tamu>';

-- Memberikan hak akses SELECT saja pada objek dalam basis data kopma_037
GRANT SELECT ON kopma_037.* TO 'tamu_037'@'localhost';


-- ------------------------------------------------------------------------------
-- 3. BASIS DATA DAN AKUN PENGEMBANG PROYEK TOKO DARING (Tugas Mandiri F)
-- Tema Proyek : Toko Daring (Kode Tema: toko)
-- ------------------------------------------------------------------------------

-- Membuat basis data proyek Toko Daring dengan standar UTF-8 4-byte (utf8mb4)
CREATE DATABASE IF NOT EXISTS toko_037
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Membuat akun pengembang khusus proyek Toko Daring
CREATE USER IF NOT EXISTS 'dev_037'@'localhost'
  IDENTIFIED BY '<password_dev>';

-- Memberikan hak akses penuh HANYA pada objek dalam basis data proyek toko_037
-- Sesuai prinsip Least Privilege (tidak memiliki akses ke kopma_037 maupun sistem)
GRANT ALL PRIVILEGES ON toko_037.* TO 'dev_037'@'localhost';


-- ------------------------------------------------------------------------------
-- 4. PENERAPAN DAN VERIFIKASI HAK AKSES
-- ------------------------------------------------------------------------------

-- Memperbarui tabel hak akses di memori server
FLUSH PRIVILEGES;

-- Menampilkan hak akses masing-masing akun untuk verifikasi
SHOW GRANTS FOR 'mhs_037'@'localhost';
SHOW GRANTS FOR 'tamu_037'@'localhost';
SHOW GRANTS FOR 'dev_037'@'localhost';

-- ==============================================================================
-- Akhir dari berkas p01_lingkungan_25430037.sql
-- ==============================================================================
