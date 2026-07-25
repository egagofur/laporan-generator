# Panduan Penanganan Masalah (Troubleshooting)

Dokumen ini berisi daftar masalah umum, kode kesalahan, dan solusi langkah-demi-langkah saat menjalankan **Laporan Generator**.

---

## 1. ImageMagick Security Policy Error

### Gejala Error:
```text
convert-im6.q16: attempt to perform an operation not allowed by the security policy 'PDF'
```

### Penyebab:
Kebijakan keamanan default ImageMagick pada beberapa distribusi Linux (seperti Ubuntu/Debian) membatasi pemrosesan berkas PDF/PNG untuk mencegah kerentanan keamanan.

### Solusi:
1. Buka file kebijakan ImageMagick dengan hak akses sudo:
   ```bash
   sudo nano /etc/ImageMagick-6/policy.xml
   # atau untuk ImageMagick 7:
   sudo nano /etc/ImageMagick-7/policy.xml
   ```
2. Cari baris berikut:
   ```xml
   <policy domain="coder" rights="none" pattern="PDF" />
   ```
3. Ubah `rights="none"` menjadi `rights="read|write"`:
   ```xml
   <policy domain="coder" rights="read|write" pattern="PDF" />
   ```
4. Simpan file (`Ctrl+O`, `Enter`) lalu keluar (`Ctrl+X`).

---

## 2. Missing Font Map (NimbusSerif / fontools_ts1.enc)

### Gejala Error:
```text
! LaTeX Error: File `t1jtm.fd' not found.
atau
kpathsea: Running mktexmf fontools_ts1.enc failed.
```

### Penyebab:
Map font `pdflatex` di mesin lokal belum teregenerasi setelah instalasi paket TeX Live.

### Solusi:
Jalankan regenerasi map font sistem dengan perintah berikut:
```bash
sudo fmtutil-sys --all
```
Jika masalah berlanjut, pastikan paket `texlive-fonts-extra` dan `texlive-fonts-recommended` sudah terinstall:
```bash
sudo apt install texlive-fonts-extra texlive-fonts-recommended
```

---

## 3. Undefined Control Sequence \pandocbounded

### Gejala Error:
```text
! Undefined control sequence.
l.370 \pandocbounded
```

### Penyebab:
Pandoc versi 3.x secara otomatis membungkus tag gambar dengan makro `\pandocbounded`, namun makro tersebut belum terdefinisi di template LaTeX lama.

### Solusi:
Pastikan file `template.latex` Anda menyertakan baris berikut:
```latex
\providecommand{\pandocbounded}[1]{#1}
```
*(Versi `template.latex` pada repositori ini sudah diperbarui untuk menangani isu ini secara otomatis)*.

---

## 4. Citasi "Undefined Reference"

### Gejala Error:
```text
LaTeX Warning: Citation 'he2016deep' on page 1 undefined.
```

### Penyebab:
Di dalam Markdown, sintaks raw LaTeX `\cite{citekey}` digunakan alih-alih sintaks native Pandoc.

### Solusi:
Gunakan sintaks sitasi Pandoc `[@citekey]` atau `@citekey` di file Markdown:
- **Salah**: `Menurut \cite{he2016deep}...`
- **Benar**: `Menurut [@he2016deep]...`

---

## 5. Permission Denied pada Laporan.pdf (Docker Volume)

### Gejala Error:
```text
cannot create Laporan.pdf: Permission denied
```

### Penyebab:
Container Docker dijalankan sebagai user `root` sehingga menghalangi user lokal untuk mengubah atau menghapus file output.

### Solusi:
Gunakan perintah `docker compose` yang sudah dikonfigurasi dengan variabel `UID/GID` lokal:
```bash
docker compose run --rm laporan-generator
```
*(File `docker-compose.yml` pada project ini secara otomatis memetakan `user: "${UID:-1000}:${GID:-1000}"`)*.
