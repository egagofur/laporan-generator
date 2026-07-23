# TINJAUAN PUSTAKA

## Markdown

### Sejarah dan Perkembangan

Markdown diciptakan oleh John Gruber pada tahun 2004 dengan tujuan menciptakan format penulisan yang mudah dibaca dan mudah ditulis dalam bentuk teks biasa [@gruber2004markdown]. Filosofi utama Markdown adalah bahwa format teks biasa sudah cukup untuk menulis dokumen sederhana, dan elemen markup yang digunakan harus seminimal mungkin.

Sejak diperkenalkan, Markdown telah berkembang menjadi berbagai varian dan ekstensi. Beberapa varian populer antara lain GitHub Flavored Markdown (GFM), CommonMark, dan Pandoc Markdown. Masing-masing varian memiliki fitur tambahan seperti dukungan tabel, daftar tugas (task list), sintaks matematika, dan metadata.

Pandoc Markdown adalah varian yang paling kaya fitur karena dikembangkan khusus untuk Pandoc. Varian ini mendukung hampir semua ekstensi yang ada, termasuk tabel multi-baris, catatan kaki, definisi metadata (YAML front matter), sintaks matematika LaTeX, dan berbagai jenis blok kode.

### Sintaks Dasar

Berikut adalah sintaks dasar Markdown yang digunakan dalam penulisan laporan:

\setlength{\tabcolsep}{1pt}

| Elemen | Sintaks | Contoh |
|--------|---------|--------|
| Heading level 1 | `# Teks` | `# BAB 1: PENDAHULUAN` |
| Heading level 2 | `## Teks` | `## 1.1 Latar Belakang` |
| Heading level 3 | `### Teks` | `### 2.1.1 Sejarah` |
| Paragraf | Baris teks biasa, dipisahkan baris kosong | |
| Teks tebal | `**teks**` atau `__teks__` | `**penting**` |
| Teks miring | `*teks*` atau `_teks_` | `*catatan*` |
| List tidak berurut | `- item` atau `* item` | `- poin pertama` |
| List berurut | `1. item` | `1. langkah pertama` |
| Link | `[teks](url)` | `[Pandoc](https://pandoc.org)` |
| Gambar | `![caption](path/file.png)` | `![Diagram](gambar/arsitektur.png)` |
| Tabel | Menggunakan pipe dan dash | (lihat contoh di bawah) |
| Kode inline | `` `kode` `` | `` `print("hello")` `` |
| Blok kode | Diapit triple backtick | |
| Matematika inline | `$...$` | `$E = mc^2$` |
| Matematika display | `$$...$$` | `$$\sum_{i=1}^n i$$` |

\setlength{\tabcolsep}{4pt}

### Keunggulan untuk Laporan Akademik

Markdown memiliki beberapa keunggulan yang membuatnya cocok sebagai format penulisan laporan akademik:

1. **Format teks biasa** --- File Markdown dapat dibaca dan diedit dengan editor teks apa pun. Tidak memerlukan perangkat lunak berbayar atau aplikasi khusus.

2. **Kompatibilitas dengan Git** --- Karena berbasis teks, file Markdown dapat di-version control dengan Git. Perubahan dapat di-diff, di-merge, dan dilacak dengan mudah.

3. **Sintaks sederhana** --- Markdown dapat dipelajari dalam hitungan menit. Penulis dapat langsung fokus pada konten tanpa terganggu oleh kompleksitas format.

4. **Konversi multi-format** --- File Markdown dapat dikonversi ke berbagai format output seperti PDF, HTML, EPUB, DOCX, dan LaTeX.

5. **Integrasi LaTeX** --- Markdown mendukung sintaks matematika LaTeX secara inline maupun display, memungkinkan penulisan rumus ilmiah dengan mudah.

6. **Portabilitas** --- File Markdown bersifat platform-independen dan dapat dibuka di sistem operasi apa pun.

## LaTeX

### Sejarah dan Perkembangan

LaTeX dikembangkan oleh Leslie Lamport pada tahun 1994 sebagai kumpulan makro (macro package) di atas sistem typesetting TeX yang diciptakan oleh Donald Knuth pada tahun 1984 [@lamport1994latex; @knuth1984texbook]. LaTeX menyediakan antarmuka yang lebih mudah digunakan dibandingkan TeX murni, dengan menyediakan perintah-perintah standar untuk format dokumen.

LaTeX dirancang berdasarkan prinsip bahwa penulis harus fokus pada konten dan struktur logis dokumen, bukan pada tampilan visual. Format dan tata letak ditangani secara otomatis oleh sistem berdasarkan kelas dokumen dan packages yang digunakan.

### Struktur Dokumen LaTeX

Dokumen LaTeX terdiri dari dua bagian utama:

1. **Preamble** --- Bagian sebelum `\begin{document}` yang berisi:
   - Deklarasi document class: `\documentclass[12pt,a4paper,oneside]{book}`
   - Penggunaan packages: `\usepackage{geometry}`, `\usepackage{setspace}`, dll.
   - Pengaturan global: font, margin, header, footer
   - Definisi perintah kustom

2. **Body** --- Bagian antara `\begin{document}` dan `\end{document}` yang berisi konten dokumen:
   - Front matter: cover, kata pengantar, daftar isi
   - Main matter: bab-bab utama
   - Back matter: daftar pustaka, lampiran

Document class yang digunakan dalam pipeline ini adalah `book`. Kelas ini menyediakan struktur chapter, section, dan subsection yang sesuai untuk laporan akademik. Pengaturan `12pt` menentukan ukuran font dasar, `a4paper` menentukan ukuran kertas, dan `oneside` mengatur pencetakan satu sisi.

### Packages Penting

Berikut adalah packages yang digunakan dalam template LaTeX:

\setlength{\tabcolsep}{6pt}

| Package | Fungsi |
|---------|--------|
| geometry | Pengaturan margin dan ukuran kertas |
| setspace | Pengaturan spasi baris (1.5 spacing) |
| graphicx | Penyisipan gambar ke dalam dokumen |
| hyperref | Pembuatan tautan internal dan eksternal |
| fancyhdr | Header dan footer kustom |
| titlesec | Format judul chapter dan section |
| tocloft | Format daftar isi |
| indentfirst | Indentasi pada paragraf pertama setelah judul |
| caption | Format caption gambar dan tabel |
| float | Penempatan floating objects (gambar, tabel) |
| listings | Penulisan kode program dengan syntax highlighting |
| xcolor | Penggunaan warna dalam dokumen |
| enumitem | Format daftar (list) kustom |
| longtable | Tabel yang bisa melebihi satu halaman |
| booktabs | Garis tabel profesional |
| amsmath | Persamaan matematika tingkat lanjut |

\setlength{\tabcolsep}{4pt}

### Font dan Encoding

Font default yang digunakan adalah Nimbus Serif, yang merupakan font open source dengan bentuk hampir identik dengan Times New Roman. Nimbus Serif adalah bagian dari proyek font URW++ yang dirilis di bawah lisensi GPL.

Encoding font menggunakan T1 (Cork encoding) melalui package `fontenc`. T1 encoding mendukung karakter-karakter bahasa Indonesia dan Eropa Barat dengan lebih baik dibandingkan encoding default OT1. Font Nimbus Serif diaktifkan melalui file mapping `nimbus15.map` dan perintah `\renewcommand{\rmdefault}{NimbusSerif}`.

Definisi font untuk Nimbus Serif memerlukan file `fontools_ts1.enc` untuk encoding TS1 (Text Companion Symbols) dan file `t1jtm.fd` untuk mendeklarasikan font shape keluarga JTM yang digunakan oleh Nimbus.

### Pengaturan Halaman dan Margin

Pengaturan halaman dilakukan dengan package `geometry`:

- Margin kiri: 2,5 cm
- Margin kanan: 2,5 cm
- Margin atas: 2 cm
- Margin bawah: 3 cm
- Jarak footer: 40pt dari bawah

Spasi baris diatur menjadi 1,5 spasi menggunakan package `setspace` dengan perintah `\onehalfspacing`. Indentasi paragraf diatur sebesar 1,5 cm dengan `\setlength{\parindent}{1.5cm}`.

### Penomoran dan Daftar Isi

Penomoran bab menggunakan angka Romawi dengan prefix "BAB":
- Output: BAB I, BAB II, BAB III, dst.
- Konfigurasi: `\renewcommand{\chaptername}{BAB}` dan
  `\renewcommand{\thechapter}{\Roman{chapter}}`

Penomoran sub-bab menggunakan angka Arab:
- Output: 1.1, 1.2, 2.1, 2.2, dst.
- Konfigurasi: `\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}`

Daftar isi menampilkan entri BAB dengan format tebal dan prefix "BAB":
- Konfigurasi:
  `\renewcommand{\cftchappresnum}{BAB }`
- Spasi antar entri diatur dengan
  `\setlength{\cftbeforechapskip}{5pt}`

## Pandoc

### Sejarah dan Perkembangan

Pandoc dikembangkan oleh John MacFarlane sejak tahun 2006 [@pandoc2024]. Nama "Pandoc" berasal dari bahasa Yunani yang berarti "semua hal yang diterima". Pandoc adalah universal document converter yang dapat mengkonversi dokumen antar berbagai format markup.

Awalnya dikembangkan untuk memenuhi kebutuhan konversi antara Haskell documentation dan Markdown, Pandoc kini telah berkembang menjadi salah satu alat konversi dokumen paling komprehensif yang tersedia. Pandoc ditulis dalam bahasa pemrograman Haskell dan dirilis di bawah lisensi GPL.

### Arsitektur Pandoc

Pandoc bekerja melalui arsitektur berbasis **AST** (Abstract Syntax Tree). AST adalah representasi internal dokumen yang bersifat netral terhadap format input maupun output.

Proses konversi terdiri dari tiga tahap:

1. **Parsing (Reader)** --- Pandoc membaca dokumen input dan mem-parsing-nya menjadi AST. Setiap format input memiliki reader yang sesuai (Markdown reader, HTML reader, LaTeX reader, dll.).

2. **Transformasi (AST)** --- AST yang dihasilkan dapat ditransformasi atau difilter sebelum dikonversi. Filter dapat ditulis dalam Lua, Python, atau bahasa lain untuk memodifikasi AST.

3. **Generasi (Writer)** --- Pandoc menulis AST ke format output yang diinginkan melalui writer yang sesuai (PDF writer, HTML writer, DOCX writer, dll.).

Pendekatan AST ini memungkinkan Pandoc untuk mengkonversi antar format yang sangat beragam dengan hasil yang konsisten. Jika suatu fitur didukung oleh AST, fitur tersebut secara otomatis dapat dikonversi ke format output apa pun.

### Format Input dan Output

Pandoc mendukung berbagai format input dan output:

**Format Input:**
- Markdown (beberapa varian)
- HTML
- LaTeX
- Docx (Microsoft Word)
- EPUB
- OPML
- org-mode (Emacs)
- reStructuredText
- Textile
- MediaWiki markup
- Jupyter Notebook (.ipynb)

**Format Output:**
- PDF (melalui engine LaTeX)
- HTML (+ slide show)
- DOCX
- LaTeX
- EPUB
- Markdown
- AsciiDoc
- Man page
- Plain text

### Flags Penting

Berikut adalah flags Pandoc yang digunakan dalam pipeline:

\begin{longtable}{p{3.2cm} p{4.5cm} p{5.5cm}}
\hline
\textbf{Flag} & \textbf{Fungsi} & \textbf{Contoh Penggunaan} \\
\hline
\endfirsthead
\hline
\textbf{Flag} & \textbf{Fungsi} & \textbf{Contoh Penggunaan} \\
\hline
\endhead
\hline
\endfoot
\hline
\endlastfoot
\texttt{--template=FILE} & Menentukan template LaTeX & \texttt{--template=template.latex} \\
\texttt{--include-before-body=FILE} & Menyisipkan konten sebelum body & \texttt{--include-before-body=cover.md} \\
\texttt{--include-after-body=FILE} & Menyisipkan konten setelah body & \texttt{--include-after-body=daftar-pustaka.md} \\
\texttt{--top-level-division=TYPE} & Menentukan tipe division tertinggi & \texttt{--top-level-division=chapter} \\
\texttt{--pdf-engine=ENGINE} & Menentukan engine PDF & \texttt{--pdf-engine=pdflatex} \\
\texttt{-o FILE} & Nama file output & \texttt{-o Laporan.pdf} \\
\texttt{--from=FORMAT} & Format input (auto-detect) & \texttt{--from=markdown} \\
\texttt{--to=FORMAT} & Format output (auto-detect) & \texttt{--to=latex} \\
\end{longtable}

### Template Engine

Pandoc menggunakan sistem template yang fleksibel. Template ditulis dalam format yang mirip dengan format output, dengan tambahan variabel yang diisi oleh Pandoc.

Variabel template yang umum digunakan:
- `$body$` --- Konten utama dokumen
- `$title$` --- Judul dokumen
- `$author$` --- Penulis
- `$date$` --- Tanggal
- `$for(include-before)$$include-before$$endfor$`\
  --- Konten sebelum body
- `$for(include-after)$$include-after$$endfor$`\
  --- Konten setelah body
- `$toc$` --- Daftar isi
- `$header-includes$` --- Kustomisasi header LaTeX

Template memungkinkan kustomisasi penuh terhadap format output tanpa mengubah konten dokumen. Ini adalah inti dari konsep pemisahan konten dan tampilan.

## ImageMagick

### Sejarah dan Perkembangan

ImageMagick adalah software suite untuk manipulasi gambar yang pertama kali dikembangkan oleh John Cristy pada tahun 1990 [@imagemagick2024]. ImageMagick mendukung lebih dari 200 format file gambar dan menyediakan berbagai tool untuk mengolah gambar melalui command line.

ImageMagick ditulis dalam bahasa C dan dirilis di bawah lisensi Apache 2.0. Software ini tersedia untuk Linux, macOS, dan Windows.

### Perintah Convert

Perintah `convert` adalah tool utama ImageMagick yang digunakan untuk:
- Konversi antar format gambar (PNG ke JPG, dll.)
- Resize gambar
- Rotasi dan flipping
- Manipulasi warna dan channel
- Penambahan efek dan filter
- Optimasi ukuran file

Dalam pipeline ini, `convert` digunakan terutama untuk menghapus alpha channel dari gambar PNG.

### Penanganan Alpha Channel

Gambar PNG seringkali memiliki alpha channel yang merepresentasikan transparansi. Saat gambar dengan alpha channel dikonversi ke PDF oleh pdfLaTeX, area transparan dapat menyebabkan masalah seperti:

- Background gambar menjadi hitam
- Gambar tidak muncul sama sekali
- Warna gambar berubah

Untuk mengatasi masalah ini, perintah berikut digunakan:

```bash
convert input.png -alpha off output.png
```

Flag `-alpha off` menghapus alpha channel dari gambar dan mengganti area transparan dengan latar belakang putih. Gambar yang dihasilkan kompatibel penuh dengan pdfLaTeX.

### Optimasi Gambar

Selain penanganan alpha channel, ImageMagick juga digunakan untuk mengoptimasi ukuran file gambar:

```bash
convert input.png -quality 85% -resize 800x600 output.jpg
```

Parameter `-quality` mengontrol tingkat kompresi (semakin rendah, semakin kecil ukuran file). Parameter `-resize` mengubah dimensi gambar. Kedua parameter ini membantu mengurangi ukuran file PDF akhir.

## Bash dan Linux

### Bash Shell

Bash (Bourne Again SHell) adalah shell dan bahasa scripting yang dikembangkan oleh Brian Fox pada tahun 1989 untuk GNU Project [@gnu2024bash]. Bash adalah shell default pada sebagian besar distribusi Linux dan macOS.

Bash menggabungkan fitur-fitur dari berbagai shell sebelumnya:
- Dari Bourne Shell (sh): syntax dasar, variabel, redirection
- Dari C Shell (csh): history, job control, aliases
- Dari Korn Shell (ksh): command completion, arithmetic

### Konsep Dasar Shell Scripting

**Shebang:**
Baris pertama script Bash dimulai dengan `#!/usr/bin/env bash` yang memberitahu sistem bahwa script harus dijalankan dengan interpreter Bash.

**Variabel:**
```bash
NAMA="Laporan Generator"
echo $NAMA
```

**Command Substitution:**
```bash
DIR="$(cd "$(dirname "$0")" && pwd)"
```
Perintah di atas mendapatkan direktori tempat script berada.

**Conditional:**
```bash
if [ -d "$OUTDIR/gambar" ]; then
    cp -r "$OUTDIR/gambar" "$TMPDIR/"
fi
```

**Error Handling:**
```bash
set -e
```
Perintah `set -e` menghentikan script jika ada perintah yang mengembalikan exit code non-zero (gagal). Ini mencegah script melanjutkan eksekusi setelah terjadi error.

### Fitur Penting dalam Pipeline Script

**`set -e`:**
Menghentikan eksekusi script jika ada perintah yang gagal. Ini penting untuk pipeline karena kegagalan pada salah satu tahap harus menghentikan seluruh proses.

**`mktemp -d`:**
Membuat direktori temporer dengan nama unik. Direktori ini digunakan untuk menyimpan file-file sementara selama proses build.

```bash
TMPDIR=$(mktemp -d)
```

**`trap`:**
Mendaftarkan perintah yang akan dijalankan saat script selesai atau menerima sinyal. Ini digunakan untuk membersihkan direktori temporer.

```bash
trap "rm -rf $TMPDIR" EXIT
```

Dengan `trap`, direktori temporer akan dihapus otomatis baik saat script selesai normal maupun saat terjadi error.

**Exit Codes:**
Setiap perintah di Linux/Bash mengembalikan exit code:
- 0: sukses
- Non-0: gagal (angka berbeda menunjukkan jenis error berbeda)

**Pipes dan Redirection:**
```bash
pandoc ... 2>&1
```
`2>&1` menggabungkan stderr (file descriptor 2) ke stdout (file descriptor 1), sehingga error dan output normal tercetak bersamaan.

### Linux sebagai Platform Pipeline

Linux menyediakan lingkungan yang ideal untuk pipeline otomatisasi dokumen [@love2010kernel; @welsh2019running]:

1. **Package Manager** --- Distribusi Linux menyediakan package manager (apt, dnf, pacman) yang memudahkan instalasi Pandoc, TeX Live, dan ImageMagick.

2. **Filesystem** --- Struktur filesystem Linux yang terstandarisasi memudahkan pengelolaan file dan path.

3. **Dukungan Bash** --- Bash tersedia secara default dan terintegrasi penuh dengan sistem operasi.

4. **Headless Operation** --- Pipeline dapat dijalankan di server tanpa GUI, memungkinkan integrasi dengan CI/CD.

5. **Skripability** --- Linux menyediakan berbagai tool command line yang dapat digabungkan dalam pipeline scripting.


