# HASIL DAN PEMBAHASAN

## Struktur Direktori

Implementasi pipeline menghasilkan struktur direktori sebagai berikut:

\vspace{5pt}
\begin{center}
\begin{minipage}{0.6\textwidth}
\footnotesize
\begin{verbatim}
laporan-generator/
|-- cover.md              # Halaman sampul
|-- template.latex        # Template LaTeX
|-- build.sh              # Skrip build
|-- metadata.yml          # Judul, penulis, institusi
|-- references.bib        # Daftar pustaka (BibTeX)
|-- chapters/             # BAB 1-5 (modular)
|   |-- bab1-pendahuluan.md
|   |-- bab2-tinjauan-pustaka.md
|   |-- bab3-metodologi.md
|   |-- bab4-hasil-dan-pembahasan.md
|   \-- bab5-penutup.md
|-- logo.jpg              # Logo institusi
|-- daftar-pustaka.md     # Fallback heading daftar pustaka
|-- Makefile              # Target build, watch, test
|-- test.sh               # Test suite
|-- README.md             # Dokumentasi
|-- LICENSE               # Lisensi MIT
\-- .gitignore            # Ignore rules
\end{verbatim}
\end{minipage}
\end{center}
\vspace{5pt}

Fungsi masing-masing file:

**cover.md** --- Berisi halaman sampul laporan yang ditulis dalam format LaTeX. File ini disisipkan ke dalam dokumen melalui flag `--include-before-body`. Cover mencakup judul, logo institusi, identitas penyusun, dan informasi institusi. Selain cover, file ini juga berisi kata pengantar yang ditulis dalam format LaTeX.

**template.latex** --- Template LaTeX yang mendefinisikan format dan layout dokumen. Template ini mencakup seluruh pengaturan yang diperlukan: document class, font, margin, header, footer, penomoran, daftar isi, dan styling. Template menggunakan variabel Pandoc (`$body$`, `$for(include-before)$`, dll.) untuk menyisipkan konten dari file Markdown.

**build.sh** --- Skrip Bash yang mengorkestrasi seluruh pipeline. Skrip ini menangani persiapan file, pemrosesan gambar, eksekusi Pandoc, dan pembersihan. Semua operasi dilakukan secara otomatis tanpa intervensi manual.

**logo.jpg** --- File gambar logo institusi yang ditampilkan pada halaman sampul. Logo dikonversi dari PNG ke JPG untuk mengurangi ukuran file dan meningkatkan kompatibilitas dengan pdfLaTeX.

**chapters/** --- Direktori yang berisi file Markdown terpisah per bab (bab1 sampai bab5). Setiap file ditulis dalam format Pandoc Markdown. Pendekatan modular ini memudahkan kolaborasi dan version control karena perubahan per bab dapat dilacak secara independen.

**daftar-pustaka.md** --- File yang berisi daftar pustaka atau referensi. File ini disisipkan setelah body dokumen melalui flag `--include-after-body`. Format penulisan mengikuti gaya APA.

## Analisis Template LaTeX

Template LaTeX terdiri dari beberapa blok pengaturan yang masing-masing memiliki fungsi spesifik.

### Document Class dan Font

```latex
\documentclass[12pt,a4paper,oneside]{book}

\usepackage[T1]{fontenc}
\pdfmapfile{+nimbus15.map}
\renewcommand{\rmdefault}{NimbusSerif}
\renewcommand{\familydefault}{\rmdefault}
```

Document class `book` dipilih karena menyediakan struktur chapter yang sesuai untuk laporan. Opsi `12pt` menghasilkan ukuran font dasar 12 poin. Penggunaan `\pdfmapfile` dan `\renewcommand{\rmdefault}` mengaktifkan font Nimbus Serif sebagai font default.

### Margin dan Spasi

```latex
\usepackage[margin=2.5cm,top=2cm,bottom=3cm,footskip=40pt]{geometry}
\usepackage{setspace}
\onehalfspacing
\setlength{\parindent}{1.5cm}
```

Margin kiri dan kanan 2,5 cm, atas 2 cm, bawah 3 cm. Spasi baris 1,5 dengan indentasi paragraf 1,5 cm. Pengaturan ini sesuai dengan standar laporan akademik yang umum digunakan di Indonesia.

### Penomoran Bab dan Section

```latex
\renewcommand{\chaptername}{BAB}
\renewcommand{\thechapter}{\Roman{chapter}}
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
\renewcommand{\thesubsection}{\arabic{chapter}.\arabic{section}.%
  \arabic{subsection}}
```

Bab diberi nama "BAB" dengan angka Romawi, menghasilkan format seperti "BAB I" dan "BAB II". Sub-bab menggunakan angka Arab dengan format "1.1" dan "2.3". Sub-sub-bab menggunakan format "1.1.1".

### Format Chapter

```latex
\titleformat{\chapter}[display]
  {\normalfont\bfseries\centering\fontsize{14}{18}\selectfont}
  {\chaptername\ \thechapter}{10pt}{\fontsize{14}{18}\selectfont}
```

Chapter ditampilkan dengan format bold, centered, ukuran font 14pt dengan spasi 18pt. Nomor bab ditampilkan pada baris terpisah dari judul bab. Jarak antara nomor dan judul adalah 10pt.

## Analisis Build Script

### Setup dan Error Handling

```bash
set -e
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT
```

Tiga baris ini merupakan fondasi keandalan script:
- `set -e` menghentikan script saat terjadi error
- `mktemp -d` membuat direktori temporer yang aman
- `trap` memastikan direktori temporer dibersihkan, bahkan jika script gagal di tengah jalan

### Proses Copy dan Preparasi

```bash
cp "$OUTDIR/cover.md" "$TMPDIR/"
cp "$OUTDIR/template.latex" "$TMPDIR/"
cp "$OUTDIR/logo.jpg" "$TMPDIR/"
cp "$OUTDIR/metadata.yml" "$TMPDIR/"
cp "$OUTDIR/references.bib" "$TMPDIR/"

if [ -d "$OUTDIR/chapters" ]; then
  cp "$OUTDIR/chapters"/*.md "$TMPDIR/"
else
  cp "$OUTDIR/isi-laporan.md" "$TMPDIR/"
fi
```

Semua file disalin ke direktori temporer untuk menjaga direktori kerja tetap bersih. File-file sisa kompilasi LaTeX (`.aux`, `.log`, `.out`, `.toc`) akan tertinggal di direktori temporer yang nantinya dihapus.

### Eksekusi Pandoc

```bash
pandoc \
  $INPUT_FILES \
  --template="template.latex" \
  --include-before-body="cover.md" \
  --include-after-body="daftar-pustaka.md" \
  --metadata-file="metadata.yml" \
  --citeproc \
  --bibliography="references.bib" \
  --top-level-division=chapter \
  --pdf-engine=pdflatex \
  -o "$REPORT" 2>&1
```

Flag `--include-before-body` menyisipkan cover.md di awal dokumen (sebelum BAB 1). Flag `--include-after-body` menyisipkan daftar-pustaka.md di akhir dokumen (setelah BAB 5). Flag `--top-level-division=chapter` memastikan heading level 1 di Markdown dikonversi menjadi perintah `\chapter{}` di LaTeX, bukan `\section{}` atau `\part{}`.

### Font Definition Generation

Script menghasilkan dua file yang diperlukan oleh font Nimbus Serif:

1. `fontools_ts1.enc` --- File encoding untuk TS1 (Text Companion Symbols) yang mendefinisikan pemetaan karakter simbol seperti tanda mata uang, tanda kurung, dan simbol tipografi lainnya.

2. `t1jtm.fd` --- File font definition yang mendeklarasikan font shape untuk keluarga font JTM yang digunakan oleh Nimbus Serif. File ini mendefinisikan kombinasi weight (medium, bold, bx) dan shape (normal, italic, slanted, small caps) yang tersedia.

Kedua file ditulis langsung dari dalam script menggunakan heredoc, sehingga tidak memerlukan file eksternal.

## Output Pipeline

### File yang Dihasilkan

Pipeline menghasilkan satu file output utama: `Laporan.pdf`. File ini merupakan dokumen PDF yang siap digunakan dengan format sebagai berikut:

| Aspek | Spesifikasi |
|:------|:------------|
| Ukuran kertas | A4 (210 mm x 297 mm) |
| Font | Times New Roman (Nimbus Serif) |
| Ukuran font | 12pt |
| Spasi baris | 1,5 spasi |
| Margin kiri/kanan | 2,5 cm |
| Margin atas/bawah | 2 cm / 3 cm |
| Indentasi paragraf | 1,5 cm |
| Penomoran bab | Romawi (BAB I, BAB II) |
| Penomoran sub-bab | Arab (1.1, 2.1) |
| Daftar isi | Otomatis |
| Lisensi font | Open source (GPL) |

### Perbandingan dengan Metode Konvensional

| Aspek | Pipeline Otomatis | Word Processor |
|:------|:------------------|:---------------|
| Format konten | Markdown (teks) | Binary (docx) |
| Version control | Git-friendly | Tidak kompatibel |
| Konsistensi format | Terjamin oleh template | Bergantung pengguna |
| Waktu revisi format | Ubah template, rebuild | Edit manual per halaman |
| Kolaborasi | Merge via Git | Track changes terbatas |
| Output | PDF langsung | Export manual |
| Dependensi | Pandoc + LaTeX | MS Word / LibreOffice |

Pipeline otomatis unggul dalam konsistensi format, kemudahan revisi, dan kompatibilitas dengan version control. Sementara word processor unggul dalam kemudahan penggunaan awal (WYSIWYG) dan tidak memerlukan instalasi tools tambahan.

## Version Control dengan Git

### Keunggulan File Teks

Penggunaan Markdown sebagai format konten memberikan keunggulan signifikan dalam version control. File Markdown adalah teks biasa, sehingga Git dapat melacak perubahan secara granular, baris per baris.

Perubahan yang sebelumnya sulit dilacak di file binary DOCX:
- Penambahan satu kalimat → diff satu baris
- Perbaikan typo → diff beberapa karakter
- Perubahan format tabel → diff struktur tabel

### Workflow Kolaborasi

Dengan pipeline otomatis, workflow kolaborasi menjadi:

1. Setiap kontributor menulis konten di file Markdown
2. Perubahan di-commit ke Git
3. Merge dilakukan dengan Git standar
4. PDF di-build ulang dengan `./build.sh`
5. Output PDF selalu sinkron dengan konten terbaru

### .gitignore

File `.gitignore` dikonfigurasi untuk mengabaikan file-file yang tidak perlu di-version control:

```
*.pdf
*.aux
*.log
*.out
*.toc
*.lof
*.lot
*.fls
*.fdb_latexmk
```

File PDF tidak perlu di-commit karena dapat dihasilkan kapan saja dengan menjalankan `build.sh`. File sisa kompilasi LaTeX (aux, log, out, toc) juga diabaikan karena bersifat sementara.


