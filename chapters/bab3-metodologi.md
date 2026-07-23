# METODOLOGI

## Arsitektur Pipeline

Pipeline otomatisasi dokumen terdiri dari tiga tahap utama yang berjalan secara sekuensial:

\vspace{10pt}
\begin{center}
\begin{minipage}{0.9\textwidth}
\footnotesize
\begin{verbatim}
+------------------+     +------------------+     +------------------+
|   TAHAP INPUT    |     |  TAHAP PROSES    |     |   TAHAP OUTPUT   |
+------------------+     +------------------+     +------------------+
|                  |     |                  |     |                  |
| cover.md         |     |   +--------+     |     | Laporan.pdf      |
| chapters/bab*.md |---->|   | Pandoc |     |     |                  |
| daftar-pustaka.md|     |   +--------+     |     | Format:          |
| metadata.yml     |     |      |           |     | - A4, 12pt       |
| references.bib   |     |      v           |     | - Times New Roman |
| template.latex   |     | +----------+     |     | - Spasi 1.5      |
| logo.jpg  |     | | pdflatex |     |     | - BAB Romawi     |
| gambar/*.png     |     | +----------+     |     | - Spasi 1.5      |
|                  |     | | pdflatex |     |     | - BAB Romawi     |
+------------------+     | +----------+     |     | - Daftar Isi     |
        |                +------------------+     +------------------+
        v                         |
+------------------+              |
| build.sh         |              |
| (Bash Script)    |<-------------+
| - mktemp         |
| - copy files     |
| - convert alpha  |
| - generate font  |
| - pandoc command |
| - cleanup        |
+------------------+
\end{verbatim}
\end{minipage}
\end{center}
\vspace{10pt}

### Tahap Input

Tahap input terdiri dari persiapan file-file sumber yang diperlukan:

1. **File konten**: `cover.md` (halaman sampul), `chapters/bab*.md` (BAB 1-5), `daftar-pustaka.md` (referensi)
2. **File metadata**: `metadata.yml` (judul, penulis, institusi), `references.bib` (daftar pustaka)
3. **File template**: `template.latex` (format dan layout)
4. **File pendukung**: `logo.jpg` (logo institusi), `gambar/*.png` (gambar pendukung)

Semua file sumber ditulis dalam format Markdown (kecuali template yang menggunakan LaTeX dan logo yang menggunakan JPG).

### Tahap Proses

Tahap proses dijalankan oleh skrip `build.sh` yang mengorkestrasi seluruh pipeline:

1. **Persiapan**: Membuat direktori temporer, menyalin file-file sumber
2. **Pre-processing**: Menghapus alpha channel dari gambar PNG
3. **Konversi**: Pandoc mengkonversi Markdown ke LaTeX menggunakan template
4. **Kompilasi**: pdfLaTeX mengkompilasi LaTeX menjadi PDF
5. **Pembersihan**: Menghapus direktori temporer

### Tahap Output

Tahap output menghasilkan file PDF yang siap digunakan. File PDF ini memiliki format yang konsisten:

- Ukuran kertas A4
- Font Times New Roman (Nimbus Serif) 12pt
- Spasi baris 1,5
- Margin sesuai standar
- Penomoran bab dengan angka Romawi (BAB I, BAB II)
- Penomoran sub-bab dengan angka Arab (1.1, 2.1)
- Daftar isi otomatis

## Template LaTeX

Template LaTeX adalah komponen kunci yang menentukan format dan tampilan akhir dokumen. Template ini berisi seluruh pengaturan format yang diperlukan untuk menghasilkan laporan akademik standar Indonesia.

### Struktur Template

Template LaTeX (`template.latex`) dibagi menjadi dua bagian utama:

**Preamble (baris 1--109):**

Document class:
```latex
\documentclass[12pt,a4paper,oneside]{book}
```

Pengaturan font:
```latex
\usepackage[T1]{fontenc}
\pdfmapfile{+nimbus15.map}
\renewcommand{\rmdefault}{NimbusSerif}
\renewcommand{\familydefault}{\rmdefault}
```

Package geometry untuk margin:
```latex
\usepackage[margin=2.5cm,top=2cm,bottom=3cm,footskip=40pt]{geometry}
```

Pengaturan chapter dan section numbering:
```latex
\renewcommand{\chaptername}{BAB}
\renewcommand{\thechapter}{\Roman{chapter}}
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
\renewcommand{\thesubsection}{\arabic{chapter}.\arabic{section}.%
  \arabic{subsection}}
```

Format chapter (14pt bold centered):
```latex
\titleformat{\chapter}[display]
  {\normalfont\bfseries\centering\fontsize{14}{18}\selectfont}
  {\chaptername\ \thechapter}{10pt}{\fontsize{14}{18}\selectfont}
```

**Body (baris 111--137):**

Front matter dengan halaman Romawi:
```latex
\frontmatter
\pagenumbering{roman}
```

Penyisipan cover melalui variabel Pandoc:
```latex
$for(include-before)$
$include-before$
$endfor$
```

Daftar isi:
```latex
\tableofcontents
```

Main matter dengan halaman Arab:
```latex
\mainmatter
\pagenumbering{arabic}
```

Konten utama:
```latex
$body$
```

### Variabel Pandoc

Template menggunakan variabel Pandoc yang diisi secara otomatis:
- `$for(include-before)$` --- Berisi file yang disertakan melalui `--include-before-body`
- `$body$` --- Berisi seluruh konten file input Markdown

## Build Script

Skrip `build.sh` adalah otak dari pipeline. Skrip ini mengatur seluruh proses build dari awal hingga akhir.

### Alur Kerja Build Script

**Langkah 1: Setup**
```bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
OUTDIR="$DIR"
REPORT="$OUTDIR/Laporan.pdf"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT
```

Script menentukan direktori kerja, membuat direktori temporer dengan `mktemp`, dan mendaftarkan pembersihan otomatis dengan `trap`.

**Langkah 2: Copy File Sumber**
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

Semua file sumber disalin ke direktori temporer untuk menjaga kebersihan direktori kerja.

**Langkah 3: Proses Gambar**
```bash
if [ -d "$OUTDIR/gambar" ]; then
  cp -r "$OUTDIR/gambar" "$TMPDIR/"
  for f in "$TMPDIR/gambar/"*.png; do
    [ -f "$f" ] && convert "$f" -alpha off "$f" 2>/dev/null || true
  done
fi
```

Jika folder `gambar/` ada, script menyalin dan memproses setiap file PNG untuk menghapus alpha channel.

**Langkah 4: Generate File Pendukung**

Script menghasilkan file `fontools_ts1.enc` yang diperlukan oleh encoding TS1 LaTeX, dan file `t1jtm.fd` yang mendefinisikan font shape untuk Nimbus Serif. Kedua file ditulis langsung dari dalam script menggunakan heredoc.

**Langkah 5: Eksekusi Pandoc**
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

Pandoc menjalankan konversi dengan parameter:
- Input: `chapters/bab*.md` (BAB 1-5)
- Template: `template.latex`
- Metadata: `metadata.yml` (judul, penulis, institusi)
- Cover: disisipkan sebelum body
- Daftar pustaka: digenerate otomatis dari `references.bib` via `--citeproc`
- Division: chapter (heading level 1 = \chapter)
- Engine: pdfLaTeX
- Output: `Laporan.pdf`

Error dan output normal digabungkan dengan `2>&1` untuk memudahkan debugging.

### Penanganan Error

Script menggunakan beberapa mekanisme penanganan error:

1. `set -e` --- Menghentikan script jika ada perintah yang gagal
2. `|| true` --- Pada perintah `convert`, error diabaikan jika gambar tidak memerlukan pemrosesan
3. `trap ... EXIT` --- Membersihkan direktori temporer meskipun terjadi error
4. `[ -f "$f" ]` --- Memeriksa keberadaan file sebelum memproses

## Penulisan Konten Markdown

### Struktur File

Konten laporan ditulis dalam file-file terpisah per bab di direktori `chapters/` (misal `chapters/bab1-pendahuluan.md`, `chapters/bab2-tinjauan-pustaka.md`, dst.). Format penulisan mengikuti aturan Pandoc Markdown:

- Heading level 1 (`#`) digunakan untuk judul BAB
- Heading level 2 (`##`) digunakan untuk sub-bab
- Heading level 3 (`###`) digunakan untuk sub-sub-bab
- Paragraf dipisahkan dengan baris kosong
- Tabel menggunakan sintaks pipe

### Penulisan Tabel

Tabel ditulis menggunakan format pipe dengan baris header dan separator:

```markdown
| Kolom 1 | Kolom 2 | Kolom 3 |
|---------|:-------:|--------:|
| Kiri    | Tengah  | Kanan   |
| Teks    | Teks    | Teks    |
```

Alignment dikontrol dengan posisi titik dua (`:`) pada baris separator:
- `:---` --- Rata kiri
- `:---:` --- Rata tengah
- `---:` --- Rata kanan

### Penulisan Matematika

Matematika inline ditulis dengan tanda dollar tunggal:
```markdown
Rumus $E = mc^2$ adalah rumus relativitas.
```

Matematika display ditulis dengan tanda dollar ganda:
```markdown
$$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$$
```

Pandoc akan meneruskan sintaks LaTeX ini langsung ke template LaTeX tanpa perubahan.

### Penulisan Kode

Kode inline ditulis dengan backtick tunggal:
```markdown
Gunakan perintah `pandoc --help` untuk melihat bantuan.
```

Blok kode ditulis dengan triple backtick dan dapat menyertakan bahasa untuk syntax highlighting:
```markdown
```bash
pandoc input.md -o output.pdf --pdf-engine=pdflatex
```
```

### Referensi Gambar

Gambar direferensikan dengan path relatif terhadap direktori kerja Pandoc:

```markdown
![Caption Gambar](gambar/nama-file.png)
```

Pandoc akan menghasilkan lingkungan `figure` LaTeX secara otomatis. Caption akan muncul di bawah gambar dengan format "Gambar 4.1" sesuai pengaturan template.

## Studi Kasus: Project Laporan Generator

Project Laporan Generator adalah implementasi nyata dari pipeline otomatisasi dokumen yang dibahas dalam laporan ini. Project ini berisi seluruh komponen pipeline:

1. **File konten**: `cover.md`, `chapters/bab*.md`, `daftar-pustaka.md`
2. **File metadata**: `metadata.yml`, `references.bib`
3. **File template**: `template.latex`
4. **Skrip build**: `build.sh`
5. **File pendukung**: `logo.jpg`

Semua file berada dalam satu direktori yang merupakan root dari project. Struktur ini sengaja dibuat sederhana untuk memudahkan penggunaan dan modifikasi.

Untuk menghasilkan PDF, pengguna cukup menjalankan:

```bash
cd ~/Projects/laporan-generator
chmod +x build.sh
./build.sh
```

Skrip akan secara otomatis:
1. Membaca file-file sumber
2. Memproses gambar (jika ada)
3. Menjalankan Pandoc dengan template LaTeX
4. Menghasilkan file `Laporan.pdf`

Seluruh proses berlangsung dalam hitungan detik dan menghasilkan dokumen dengan format yang konsisten dan profesional.


