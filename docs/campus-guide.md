# Panduan Preset & Kustomisasi Format Kampus

Dokumen ini berisi panduan untuk menyesuaikan format laporan akademik sesuai dengan pedoman penulisan di berbagai perguruan tinggi di Indonesia.

---

## 1. Pilihan Preset Margin Dokumen

Anda dapat mengatur preset margin melalui berkas `metadata.yml`:

### A. Preset Standar Modern (`standard`)
* **Penggunaan:** Tugas akhir, laporan magang, praktikum, seminar.
* **Konfigurasi `metadata.yml`:**
  ```yaml
  margin_preset: "standard"
  ```
* **Ukuran Margin:**
  * Kiri: 2.5 cm
  * Kanan: 2.5 cm
  * Atas: 2.0 cm
  * Bawah: 3.0 cm

### B. Preset Skripsi Tradisional (`skripsi-4433` / `4-4-3-3`)
* **Penggunaan:** Format skripsi/tesis jilid tebal (hardcover) yang mewajibkan margin kiri lebih lebar untuk area jilidan.
* **Konfigurasi `metadata.yml`:**
  ```yaml
  margin_preset: "skripsi-4433"
  ```
* **Ukuran Margin:**
  * Kiri: 4.0 cm (area jilid)
  * Atas: 4.0 cm
  * Kanan: 3.0 cm
  * Bawah: 3.0 cm

---

## 2. Contoh Konfigurasi Berbagai Kampus

### A. Format Universitas Indonesia (UI)
```yaml
title: "IMPLEMENTASI DEEP LEARNING UNTUK DETEKSI PENYAKIT PADA CITRA MEDIS"
subtitle: "LAPORAN TUGAS AKHIR"
course: "Proyek Perangkat Lunak Lanjut"
lecturer: "Prof. Dr. Ir. Dosen Pengampu, M.Sc."
author:
  - name: "Nama Mahasiswa"
    nim: "2106012345"
institution: "UNIVERSITAS INDONESIA"
faculty: "FAKULTAS ILMU KOMPUTER"
year: "2026"
margin_preset: "standard"
```

### B. Format Institut Teknologi Bandung (ITB)
```yaml
title: "RANCANG BANGUN SISTEM KONTROL DAN MONITORING SMART GRID BERBASIS IOT"
subtitle: "LAPORAN TUGAS AKHIR"
course: "Sistem Tertanam"
lecturer: "Dr. Eng. Pembimbing Utama, S.T., M.T."
author:
  - name: "Nama Mahasiswa"
    nim: "13521001"
institution: "INSTITUT TEKNOLOGI BANDUNG"
faculty: "SEKOLAH TEKNIK ELEKTRO DAN INFORMATIKA"
year: "2026"
margin_preset: "skripsi-4433"
```

### C. Format Universitas Gadjah Mada (UGM)
```yaml
title: "ANALISIS PERFORMA ARSITEKTUR MICROSERVICES PADA CLOUD COMPUTING"
subtitle: "LAPORAN PRAKTIKUM LAPANGAN"
course: "Rekayasa Perangkat Lunak"
lecturer: "Dr. Dosen Pengampu, S.Kom., M.Cs."
author:
  - name: "Mahasiswa Satu"
    nim: "21/475123/TK/52123"
  - name: "Mahasiswa Dua"
    nim: "21/475124/TK/52124"
institution: "UNIVERSITAS GADJAH MADA"
faculty: "FAKULTAS TEKNIK"
year: "2026"
margin_preset: "skripsi-4433"
```

---

## 3. Mengganti Logo Kampus
Cukup salin gambar logo resmi kampus Anda ke direktori utama dengan nama **`logo.jpg`** (atau format PNG yang dikonversi ke JPEG):
```bash
cp /path/ke/logo-kampus.png logo.jpg
```
Pipeline akan secara otomatis menyesuaikan ukuran dan memposisikannya secara proporsional di tengah halaman sampul.
