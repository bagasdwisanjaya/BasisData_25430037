# Dokumen Normalisasi Basis Data - Koperasi Mahasiswa (Kopma)

**Nama Praktikan:** Bagas Dwi Sanjaya  
**NIM:** 25430037  
**Kelas:** Kelas B, Ilmu Komputer - Semester 3  
**Mata Kuliah:** Praktikum Basis Data (Semester 3)  
**Studi Kasus:** Koperasi Mahasiswa Sejahtera (Kopma)  
**Modul:** 4 - Normalisasi Basis Data Relasional (UNF $\rightarrow$ 1NF $\rightarrow$ 2NF $\rightarrow$ 3NF)  
**Tahun Akademik:** 2026/2027  

---

## 1. Dokumen Sumber yang Dianalisis: Nota Penjualan Kasir

```text
========================================================================================
                          KOPERASI MAHASISWA SEJAHTERA (KOPMA)
                       Gedung Student Center Lt. 1, Kampus Terpadu
========================================================================================
NOTA PENJUALAN: PJ-2609-0142                             TANGGAL: 26/09/2026 14:15:00
KASIR         : K01 (Rina Astuti)
ANGGOTA       : A-0457 / NIM: 25430037 (Bagas Dwi Sanjaya - S1 Ilmu Komputer)
STATUS ANGGOTA: AKTIF (Berhak Diskon 5% Sesuai AB-02)
----------------------------------------------------------------------------------------
RINCIAN BELANJAAN:
No  Kode Barang   Nama Barang                    Kategori   Qty   Harga Satuan   Subtotal
--  -----------   ----------------------------   --------   ---   ------------   --------
1.  ATK-001       Buku Tulis Sidu 38 Lembar      ATK          2     Rp  4.500    Rp  9.000
2.  MKN-001       Roti Sari Roti Cokelat         Makanan      1     Rp  6.000    Rp  6.000
----------------------------------------------------------------------------------------
Total Belanja          : Rp 15.000
Tunai Dibayar          : Rp 20.000
Kembalian              : Rp  5.000
========================================================================================
```

---

## 2. Tahap 0: Bentuk Tidak Ternormalisasi (UNF)

Bentuk UNF memuat seluruh atribut faktur penjualan dengan rincian barang sebagai kelompok berulang (*repeating group*):

$$\mathtt{UNF\_KOPMA} = \{\mathtt{no\_nota}, \mathtt{tgl}, \mathtt{kode\_kasir}, \mathtt{nama\_kasir}, \mathtt{no\_anggota}, \mathtt{nim}, \mathtt{nama\_anggota}, \mathtt{prodi}, \mathtt{status}, \mathbf{\{\mathtt{kode\_brg}, \mathtt{nama\_brg}, \mathtt{kategori}, \mathtt{qty}, \mathtt{harga\_satuan}\}}, \mathtt{total}, \mathtt{bayar}, \mathtt{kembalian}\}$$

---

## 3. Tahap 1: Bentuk Normal Pertama (1NF)

Repeating group didatarkan sehingga setiap baris memuat nilai atomik.  
**Kunci Primer Komposit:**
$$\mathbf{PK} = (\mathtt{no\_nota\_penjualan}, \mathtt{kode\_barang})$$

### Skema 1NF:
`penjualan_1nf` (
  **`no_nota_penjualan`** [PK],
  **`kode_barang`** [PK],
  `tgl_penjualan`,
  `kode_petugas`,
  `nama_petugas`,
  `peran_petugas`,
  `no_anggota`,
  `nim_anggota`,
  `nama_anggota`,
  `prodi_anggota`,
  `status_anggota`,
  `nama_barang`,
  `kategori_barang`,
  `harga_jual_master`,
  `qty_detail_penjualan`,
  `harga_satuan_detail_penjualan`,
  `bayar_penjualan`
)

*Identifikasi Dependensi Parsial pada 1NF:*
- $\mathtt{no\_nota\_penjualan} \rightarrow \mathtt{tgl}, \mathtt{kode\_petugas}, \mathtt{nim\_anggota}, \mathtt{bayar}$ (Dependensi Parsial).
- $\mathtt{kode\_barang} \rightarrow \mathtt{nama\_barang}, \mathtt{kategori\_barang}, \mathtt{harga\_jual\_master}$ (Dependensi Parsial).

---

## 4. Tahap 2: Bentuk Normal Kedua (2NF)

Dependensi parsial dihilangkan dengan dekomposisi menjadi 3 tabel:

1. **`penjualan_2nf`** (PK: `no_nota_penjualan`):  
   (`no_nota_penjualan` [PK], `tgl_penjualan`, `kode_petugas`, `nama_petugas`, `peran_petugas`, `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `status_anggota`, `bayar_penjualan`)
2. **`barang_2nf`** (PK: `kode_barang`):  
   (`kode_barang` [PK], `nama_barang`, `kategori_barang`, `harga_jual_master`, `stok_barang`, `stok_min_barang`)
3. **`detail_penjualan_2nf`** (PK Komposit: `no_nota_penjualan`, `kode_barang`):  
   (`no_nota_penjualan` [PK,FK], `kode_barang` [PK,FK], `qty_detail_penjualan`, `harga_satuan_detail_penjualan`)

*Identifikasi Dependensi Transitif pada 2NF:*
- $\mathtt{no\_nota\_penjualan} \rightarrow \mathtt{kode\_petugas} \rightarrow \mathtt{nama\_petugas}, \mathtt{peran\_petugas}$.
- $\mathtt{no\_nota\_penjualan} \rightarrow \mathtt{nim\_anggota} \rightarrow \mathtt{nama\_anggota}, \mathtt{prodi\_anggota}, \mathtt{status\_anggota}$.

---

## 5. Tahap 3: Bentuk Normal Ketiga (3NF)

Seluruh dependensi transitif dihilangkan. Ditambah dekomposisi simetris pada modul pengadaan barang, diperoleh **skema kanonik 8 tabel relasional Kopma**:

1. **`petugas`**: (`id_petugas` [PK], `kode_petugas` [UQ], `nama_petugas`, `peran_petugas`)
2. **`anggota`**: (`id_anggota` [PK], `no_anggota` [UQ], `nim_anggota` [UQ], `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`, `tgl_daftar_anggota`)
3. **`barang`**: (`id_barang` [PK], `kode_barang` [UQ], `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang`)
4. **`pemasok`**: (`id_pemasok` [PK], `kode_pemasok` [UQ], `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok`)
5. **`penjualan`**: (`id_penjualan` [PK], `no_nota_penjualan` [UQ], `tgl_penjualan`, `id_petugas` [FK], `id_anggota` [FK], `bayar_penjualan`)
6. **`detail_penjualan`**: (`id_penjualan` [PK,FK], `id_barang` [PK,FK], `qty_detail_penjualan`, `harga_satuan_detail_penjualan`)
7. **`pembelian`**: (`id_pembelian` [PK], `no_faktur_pembelian`, `tgl_pembelian`, `id_pemasok` [FK], `status_pembelian`)
8. **`detail_pembelian`**: (`id_pembelian` [PK,FK], `id_barang` [PK,FK], `qty_detail_pembelian`, `harga_beli_detail_pembelian`)

---

## 6. Daftar Dependensi Fungsional (FD) Kopma

- **FD-01**: $\mathtt{kode\_petugas} \rightarrow \mathtt{nama\_petugas}, \mathtt{peran\_petugas}$
- **FD-02**: $\mathtt{nim\_anggota} \rightarrow \mathtt{no\_anggota}, \mathtt{nama\_anggota}, \mathtt{prodi}, \mathtt{no\_hp}, \mathtt{status}, \mathtt{tgl\_daftar}$
- **FD-03**: $\mathtt{kode\_barang} \rightarrow \mathtt{nama\_barang}, \mathtt{kategori\_barang}, \mathtt{harga\_jual\_master}, \mathtt{stok}, \mathtt{stok\_min}$
- **FD-04**: $\mathtt{kode\_pemasok} \rightarrow \mathtt{nama\_pemasok}, \mathtt{telepon\_pemasok}, \mathtt{alamat\_pemasok}$
- **FD-05**: $\mathtt{no\_nota\_penjualan} \rightarrow \mathtt{tgl\_penjualan}, \mathtt{kode\_petugas}, \mathtt{nim\_anggota}, \mathtt{bayar\_penjualan}$
- **FD-06**: $(\mathtt{no\_nota\_penjualan}, \mathtt{kode\_barang}) \rightarrow \mathtt{qty\_detail\_penjualan}, \mathtt{harga\_satuan\_detail\_penjualan}$
- **FD-07**: $\mathtt{id\_pembelian} \rightarrow \mathtt{no\_faktur\_pembelian}, \mathtt{tgl\_pembelian}, \mathtt{kode\_pemasok}, \mathtt{status\_pembelian}$
- **FD-08**: $(\mathtt{id\_pembelian}, \mathtt{kode\_barang}) \rightarrow \mathtt{qty\_detail\_pembelian}, \mathtt{harga\_beli\_detail\_pembelian}$

---

## 7. Analisis Keputusan Nilai Turunan

| Elemen Nilai Turunan | Formula Matematis | Keputusan Desain | Alasan Arsitektural |
| --- | --- | :---: | --- |
| `subtotal` | `qty * harga_satuan` | **Tidak Disimpan** | Dihitung dinamis saat kueri untuk mencegah inkonsistensi data jika kuantitas diubah. |
| `total_belanja` | `SUM(subtotal) - diskon` | **Tidak Disimpan** | Dihitung dinamis dari rincian belanja; mencegah celah *update anomaly* di tabel kepala. |
| `uang_kembalian` | `bayar - total_belanja` | **Tidak Disimpan** | Nilai komputasi murni dari dua nilai yang telah ada. |
| `harga_satuan_transaksi` | Harga master saat checkout | **Disimpan (Snapshot)** | Wajib disimpan pada rincian transaksi (**AB-04**) agar transaksi lama tidak berubah saat harga master naik. |

---
*Disusun oleh Bagas Dwi Sanjaya (NIM: 25430037) - Praktikum Basis Data Semester 3.*
