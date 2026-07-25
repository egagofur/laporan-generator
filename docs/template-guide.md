# Panduan Arsitektur Template LaTeX (template.latex)

File `template.latex` merupakan jantung dari pemformatan visual PDF pada **Laporan Generator**. Template ini dirancang untuk memenuhi standar penyusunan laporan akademik resmi di Indonesia.

---

## Desain Arsitektur & Pemilihan Font

### 1. Pemilihan Font (Nimbus Serif / Times New Roman)
* Standardisasi karya ilmiah di Indonesia mewajibkan penggunaan font tipe *Times New Roman* 12pt.
* Untuk menjamin portabilitas kompilasi cross-platform pada mesin Linux, macOS, dan Docker tanpa tergantung pada font proprietary Microsoft, template menggunakan **Nimbus Serif** (`nimbus15.map` & `T1/jtm` font definition).
* Font ini secara visual identik dengan Times New Roman dan didukung secara native oleh pdflatex.

### 2. Pengaturan Margin & Spacing
```latex
\usepackage[margin=2.5cm,top=2cm,bottom=3cm,footskip=40pt]{geometry}
\onehalfspacing
\setlength{\parindent}{1.5cm}
```
* Margin Kiri & Kanan: 2.5 cm
* Margin Atas: 2.0 cm
* Margin Bawah: 3.0 cm
* Spasi Antar Baris: 1.5 spasi (*one half spacing*)
* Indentasi Paragraf Pertama: 1.5 cm

---

## Penomoran Bab dan Halaman

### 1. Format Bab & Heading (titlesec & tocloft)
```latex
\renewcommand{\chaptername}{BAB}
\renewcommand{\thechapter}{\Roman{chapter}}
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
\renewcommand{\thesubsection}{\arabic{chapter}.\arabic{section}.\arabic{subsection}}
```
* **Bab**: Diformat dengan Angka Romawi (`BAB I`, `BAB II`, `BAB III`, dst).
* **Sub-bab**: Diformat dengan Angka Arab (`1.1`, `1.2`, `2.1`).
* **Sub-sub-bab**: Diformat dengan Angka Arab 3 tingkat (`1.1.1`, `1.1.2`).

### 2. Penomoran Halaman (frontmatter vs mainmatter)
- **Bagian Depan** (Kata Pengantar, Daftar Isi): Menggunakan penomoran Romawi kecil (`i`, `ii`, `iii`) di bagian tengah bawah.
- **Bagian Utama** (BAB I hingga BAB V): Menggunakan penomoran Angka Arab (`1`, `2`, `3`) berurutan.

---

## Makro Penting Kompatibilitas Pandoc

### 1. Makro Responsive Images (\pandocbounded)
```latex
\providecommand{\pandocbounded}[1]{#1}
```
* Menjamin kompatibilitas dengan Pandoc 3.x saat menyisipkan gambar `![](gambar/file.png)`.

### 2. Pemrosesan Tabel (tabular & longtable)
```latex
\renewcommand{\arraystretch}{1.2}
\setlength{\tabcolsep}{4pt}
\AtBeginEnvironment{longtable}{\footnotesize}
```
* Mengatur spasi sel tabel agar terlihat rapi dan tidak terlalu rapat.

### 3. Pewarnaan Blok Kode (listings)
```latex
\lstset{
  basicstyle=\footnotesize\ttfamily,
  breaklines=true,
  frame=single,
  backgroundcolor=\color{lightgray!10},
  rulecolor=\color{lightgray},
}
```
* Menampilkan blok kode pemrograman dengan font monospaced, border rapi, dan latar belakang abu-abu muda.
