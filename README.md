<p align="center">
  <img src="logo.jpg" alt="Laporan Generator" width="200"/>
</p>

<h1 align="center">Laporan Generator</h1>

<p align="center">
   Pipeline otomatisasi laporan akademik dari Markdown ke PDF dalam satu perintah.
   Format APA, cover profesional, support Docker. Bisa pake AI Agent untuk generate konten otomatis.
</p>

<p align="center">
  <a href="https://github.com/muadzhdz/laporan-generator/actions/workflows/build.yml"><img src="https://github.com/muadzhdz/laporan-generator/actions/workflows/build.yml/badge.svg" alt="Build Status"></a>
  <a href="#"><img src="https://img.shields.io/badge/Pandoc-3.0+-blue?style=for-the-badge&logo=markdown"></a>
  <a href="#"><img src="https://img.shields.io/badge/LaTeX-pdflatex-008080?style=for-the-badge&logo=latex"></a>
  <a href="#"><img src="https://img.shields.io/badge/ImageMagick-7.0+-orange?style=for-the-badge"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
</p>

<p align="center">
  <b><a href="GETTING-STARTED.md">Panduan Pemula (Zero to PDF)</a></b> •
  <b><a href="CONTRIBUTING.md">Kontribusi</a></b> •
  <b><a href="CHANGELOG.md">Changelog</a></b> •
  <b><a href="docs/troubleshooting.md">Troubleshooting</a></b> •
  <b><a href="examples/Laporan-Akademik-Example.pdf">Contoh PDF</a></b>
</p>

---

## Daftar Isi

- [AI Agent Flow (Cara Cepat)](#ai-agent-flow-cara-cepat)
- [Manual Flow (Edit Sendiri)](#manual-flow-edit-sendiri)
- [Build PDF -- Pilih 1 dari 3 Cara](#build-pdf--pilih-1-dari-3-cara)
- [Pusat Dokumentasi (Docs)](#pusat-dokumentasi-docs)
- [Struktur File](#struktur-file)
- [Alur Pipeline](#alur-pipeline)
- [Lisensi](#lisensi)

---

## AI Agent Flow (Cara Cepat)

Flow utama: Clone repo -> Jalankan AI Agent -> Langsung Build.

```bash
1. Clone repo ke folder project kamu:
     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu
     cd project-kamu/

2. Ganti logo.jpg dengan logo kampus atau sekolah kamu
   (nama file TETAP logo.jpg -- biar ditemukan template)

3. Jalankan AI Agent (OpenCode, Claude Code, Antigravity CLI, dll):
     "Baca prompt.md dan generate laporan untuk project ini"

4. AI akan:
   - Scan folder project kamu (tentukan jenis project: Web/ML/IoT/dll)
   - Tanya kamu pertanyaan satu per satu (judul, anggota, dosen, matkul, dll)
   - Overwrite file-file berikut dengan konten sesuai project kamu:
     + chapters/bab*.md      (isi laporan per bab - tanpa manual numbering)
     + metadata.yml           (judul, penulis, dosen, matkul, institusi)
     + references.bib         (daftar pustaka format APA)
     + cover.md               (kata pengantar)

5. Build PDF (lihat cara build di bawah)
```

---

## Manual Flow (Edit Sendiri)

Jika Anda ingin menulis konten laporan secara manual tanpa AI:

```bash
1. Clone repo:
     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu
     cd project-kamu/

2. Ganti logo.jpg dengan logo kampus/sekolah kamu (nama file TETAP logo.jpg)

3. Edit isi laporan di chapters/bab*.md (BAB I s/d BAB V)

4. Atur metadata di metadata.yml (judul, penulis, dosen, matkul, institusi)

5. Isi daftar pustaka di references.bib (format BibTeX) dan gunakan sitasi [@citekey] di Markdown

6. Build PDF (lihat cara build di bawah)
```

---

## Build PDF -- Pilih 1 dari 3 Cara

### Opsi 1: Docker (Paling Gampang - Zero Dependencies)
```bash
docker compose run --rm laporan-generator
```

### Opsi 2: Manual Install (Linux)
```bash
# Ubuntu / Debian
sudo apt install pandoc texlive-latex-base texlive-latex-extra texlive-fonts-recommended imagemagick
sudo fmtutil-sys --all

# Build
./build.sh
```

### Opsi 3: Makefile Helpers
```bash
make init         # Aktifkan git pre-commit hook otomatis
make build        # Build PDF (sama kaya ./build.sh)
make view         # Buka file Laporan.pdf di PDF viewer
make watch        # Auto-build saat file berubah (butuh inotify-tools)
make docx         # Export ke Microsoft Word (.docx)
make html         # Export ke HTML
make test         # Jalankan test suite (15 kategori tes / 30 assertions)
make clean        # Hapus Laporan.pdf dan folder tmp/
```

---

## Pusat Dokumentasi (Docs)

Untuk informasi teknis lebih mendalam, silakan baca dokumentasi terpisah kami:

- **[GETTING-STARTED.md](GETTING-STARTED.md)**: Panduan langkah-demi-langkah dari nol hingga jadi PDF, glosarium istilah, dan FAQ.
- **[docs/metadata-schema.md](docs/metadata-schema.md)**: Panduan lengkap skema konfigurasi `metadata.yml` (Single & Multi-Author).
- **[docs/template-guide.md](docs/template-guide.md)**: Penjelasan arsitektur `template.latex`, font Nimbus Serif, margin, dan makro Pandoc 3.x.
- **[docs/troubleshooting.md](docs/troubleshooting.md)**: Solusi lengkap masalah ImageMagick policy, font map missing, dan izin Docker.
- **[CONTRIBUTING.md](CONTRIBUTING.md)**: Pedoman berkontribusi, menambah template kampus baru, dan standar testing.
- **[CHANGELOG.md](CHANGELOG.md)**: Catatan riwayat versi dan perubahan fitur.

---

## Struktur File

```
laporan-generator/
├── GETTING-STARTED.md       # Panduan pemula (Zero to PDF)
├── CONTRIBUTING.md          # Panduan kontribusi open-source
├── CHANGELOG.md             # Catatan rilis versi
├── docs/                    # Dokumentasi teknis terpisah
│   ├── metadata-schema.md   # Skema metadata.yml
│   ├── template-guide.md    # Arsitektur template LaTeX
│   └── troubleshooting.md   # Solusi error lengkap
├── examples/                # Contoh PDF laporan hasil kompilasi
├── .github/                 # Workflows CI/CD, Issue & PR templates
├── apa.csl                  # Citation Style Language (APA)
├── build.sh                 # Skrip build utama
├── template.latex           # Template LaTeX (font, margin, format)
├── metadata.yml             # Judul, penulis, dosen, matkul, institusi
├── references.bib           # Daftar pustaka (BibTeX)
├── chapters/                # Konten laporan per bab (bab1-5)
├── cover.md                 # Kata pengantar
├── logo.jpg                 # Logo kampus/sekolah (WAJIB ganti)
├── Makefile                 # Target build, watch, test, docker, init, view
├── test.sh                  # Test suite (15 kategori tes)
├── Dockerfile               # Container build (Ubuntu 22.04 + Pandoc + TeX)
├── docker-compose.yml       # Docker orchestration (UID/GID user mapping)
└── prompt.md                # Instruksi AI Agent untuk pembuatan laporan
```

---

## Alur Pipeline

```
chapters/bab*.md ---+                      
cover.md -----------+                      
metadata.yml -------+-- Pandoc --citeproc --+-- pdfLaTeX -- Laporan.pdf
references.bib -----+  --csl=apa.csl        |
template.latex -----+                       +-- ImageMagick (alpha off)
logo.jpg -----------+                       |
gambar/ ------------+                       +-- Bash (tmpdir + trap)
apa.csl ------------+                       +-- container user (no root)
```

---

## Lisensi

MIT License. Lihat [LICENSE](LICENSE) untuk detail.
