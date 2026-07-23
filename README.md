<p align="center">
  <img src="logo.jpg" alt="Laporan Generator" width="200"/>
</p>

<h1 align="center">Laporan Generator</h1>

<p align="center">
   Pipeline otomatisasi laporan akademik dari Markdown ke PDF dalam satu perintah.
   Format APA, cover profesional, support Docker. Bisa pake AI Agent untuk generate konten otomatis.
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Pandoc-3.0+-blue?style=for-the-badge&logo=markdown"></a>
  <a href="#"><img src="https://img.shields.io/badge/LaTeX-pdflatex-008080?style=for-the-badge&logo=latex"></a>
  <a href="#"><img src="https://img.shields.io/badge/ImageMagick-7.0+-orange?style=for-the-badge"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
</p>

## Daftar Isi

- [AI Agent Flow (Cara Cepat)](#ai-agent-flow-cara-cepat)
- [Manual Flow (Edit Sendiri)](#manual-flow-edit-sendiri)
- [Build PDF — Pilih 1 dari 3 Cara](#build-pdf--pilih-1-dari-3-cara)
- [Logo](#logo)
- [Struktur File](#struktur-file)
- [Alur Pipeline](#alur-pipeline)
- [Lisensi](#lisensi)

---

## AI Agent Flow (Cara Cepat)

Flow utama -- clone, jalanin AI Agent, langsung build.

```
1. Clone repo ke folder project kamu:
     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu
     cd project-kamu/

2. Ganti logo.jpg dengan logo kampus atau sekolah kamu
   (nama file TETAP logo.jpg -- biar ditemukan template)

3. Jalankan AI Agent (OpenCode, Claude Code, Antigravity CLI, dll):
     "Baca prompt.md dan generate laporan untuk project ini"

4. AI akan:
   - Scan folder project kamu (tentukan jenis project: Web/ML/IoT/dll)
   - Tanya kamu pertanyaan satu per satu:
     (judul, anggota, universitas, dosen, matkul, tahun ajaran,
     template kampus, latar belakang project, jumlah sub-bab bab 1,
     screenshot, bab tambahan, font)
   - Overwrite file-file berikut dengan konten sesuai project kamu:
     + chapters/bab*.md      (isi laporan per bab — tanpa manual numbering)
     + metadata.yml           (judul, penulis, dosen, matkul, institusi)
     + references.bib         (daftar pustaka format APA)
     + cover.md               (kata pengantar)
   - File yang TIDAK diubah: template.latex, build.sh, logo.jpg, apa.csl

5. Build PDF (lihat cara build di bawah)

6. Laporan.pdf siap
```

---

## Manual Flow (Edit Sendiri)

Kalo mau nulis konten laporan manual tanpa AI:

```
1. Clone repo:
     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu
     cd project-kamu/

2. Ganti logo.jpg dengan logo kampus atau sekolah kamu (nama file TETAP logo.jpg)

3. Edit isi laporan di chapters/bab*.md:
     chapters/bab1-pendahuluan.md         -- BAB I
     chapters/bab2-tinjauan-pustaka.md    -- BAB II
     chapters/bab3-metodologi.md          -- BAB III
     chapters/bab4-hasil-dan-pembahasan.md -- BAB IV
     chapters/bab5-penutup.md             -- BAB V

4. Atur metadata di metadata.yml:
     title, author (nama + NIM), lecturer, course, institution, faculty, year

5. Isi daftar pustaka di references.bib (format BibTeX)

6. Build PDF (lihat cara build di bawah)

7. Laporan.pdf siap

Note: kalo ada screenshot, taruh di folder gambar/ dan referensi pake ![](gambar/file.png)
```

---

## Build PDF -- Pilih 1 dari 3 Cara

### Opsi 1: Docker (Paling Gampang)

Tanpa instal Pandoc / TeX Live / ImageMagick di mesin lokal. Semua
dependensi sudah di dalam container.

**Butuh:** Docker Desktop terinstall

```bash
# Build PDF
docker compose run --rm laporan-generator

# Atau pake Makefile
make docker-run         # Sama dengan docker compose run
make docker-watch       # Auto-build saat file berubah
make docker-build       # Build ulang image (kalo Dockerfile diubah)
```

Perintah pertama kali akan download + build image (~5-10 menit tergantung koneksi).
Selanjutnya eksekusi dalam hitungan detik.

Ada 2 service di docker-compose.yml:
| Service | Cara Jalan | Fungsi |
|---------|-----------|--------|
| laporan-generator | `docker compose run --rm laporan-generator` | Build PDF sekali jalan |
| watch | `docker compose --profile watch run --rm watch` | Pantau perubahan file, auto rebuild |

Output Laporan.pdf muncul di folder project (ter-mount via volume).
Container jalan sebagai user ID host (UID/GID) biar file hasil gak jadi milik root.

---

### Opsi 2: Manual Install (Linux)

**Butuh:** sudo access

#### Ubuntu / Debian
```bash
sudo apt install pandoc texlive-latex-base texlive-latex-extra \
  texlive-latex-recommended texlive-fonts-extra \
  texlive-fonts-recommended texlive-lang-other imagemagick
sudo fmtutil-sys --all
```
> *Catatan: kalo `texlive-lang-other` error, coba `texlive-lang-indonesian` (nama package beda tergantung versi OS).*

#### Arch Linux
```bash
sudo pacman -S pandoc texlive-core texlive-latex texlive-latexextra \
  texlive-latexrecommended texlive-fontsextra \
  texlive-fontsrecommended texlive-langindonesian imagemagick
sudo fmtutil-sys --all
```

#### Fedora / RHEL
```bash
sudo dnf install pandoc texlive-scheme-medium \
  texlive-collection-latexextra texlive-collection-fontsrecommended \
  texlive-lang-indonesian imagemagick
sudo fmtutil-sys --all
```

#### Build
```bash
./build.sh
```

---

### Opsi 3: Makefile

Kalo dependensi sudah terinstall.

```bash
make lint-deps    # Cek apakah semua tools tersedia
make build        # Build PDF (sama kaya ./build.sh)
make watch        # Auto-build saat file berubah (butuh inotify-tools)
make docx         # Export ke Microsoft Word (.docx)
make html         # Export ke HTML
make test         # Jalankan test suite (25 tes)
make clean        # Hapus Laporan.pdf dan folder tmp/
```

---

## Logo

**WAJIB** ganti `logo.jpg` dengan logo kampus atau sekolah kamu.

- Nama file HARUS tetap `logo.jpg` (biar ditemukan template LaTeX)
- Tampil di halaman cover PDF dengan lebar 4cm
- Kalo pake AI Agent, file ini tidak di-overwrite (user ganti manual)
- Format: JPG direkomendasikan. PNG dengan alpha channel otomatis diproses oleh build.sh

---

## Struktur File

```
laporan-generator/
├── apa.csl                  # Citation Style Language (APA)
├── build.sh                 # Skrip build utama
├── template.latex           # Template LaTeX (font, margin, format)
├── metadata.yml             # Judul, penulis, dosen, matkul, institusi
├── references.bib           # Daftar pustaka (BibTeX)
├── chapters/                # Konten laporan per bab
│   ├── bab1-pendahuluan.md
│   ├── bab2-tinjauan-pustaka.md
│   ├── bab3-metodologi.md
│   ├── bab4-hasil-dan-pembahasan.md
│   └── bab5-penutup.md
├── cover.md                 # Kata pengantar
├── logo.jpg                 # Logo kampus/sekolah (WAJIB ganti)
├── Makefile                 # Build, watch, test, docker
├── test.sh                  # Test suite (25 tes)
├── Dockerfile               # Container build
├── docker-compose.yml       # Docker orchestration
├── .githooks/               # Pre-commit hook (validasi build)
├── .github/workflows/       # GitHub Actions CI/CD
├── prompt.md                # Instruksi AI Agent (jangan diubah)
├── README.md                # File ini
├── LICENSE                  # Lisensi MIT
└── .gitignore
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

Penjelasan singkat:
1. Semua file sumber disalin ke direktori temporer
2. Gambar PNG diproses (alpha channel dihapus via ImageMagick)
3. Pandoc mengkonversi Markdown ke LaTeX menggunakan template
4. Sitasi diformat APA via apa.csl (Citation Style Language)
5. Font Nimbus Serif diaktifkan via encoding map
6. pdfLaTeX mengkompilasi LaTeX menjadi PDF
7. Direktori temporer dibersihkan otomatis (trap)

---

## Untuk yang Baru Mulai (Zero Skill)

Udah baca semua flow di atas tapi masih bingung? Gapapa.
Kamu cukup lakuin 3 langkah doang:

```
1. Download repo ini ke folder project kamu:
     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu
     cd project-kamu/

2. Jalanin AI Agent (OpenCode, Claude Code, Antigravity CLI, dll):
     "Baca prompt.md dan bantu aku bikin laporan untuk project ini"

3. Diskusi aja sama AI Agent-nya.
   Dia bakal nuntun kamu step by step, nanya judul, nama, screenshot,
   sampe semua beres. Kamu tinggal jawab pertanyaannya doang.

   Pas AI bilang selesai, jalanin ini di terminal:
     docker compose run --rm laporan-generator

   (Kalo belum punya Docker, download dulu dari https://docker.com)
```

Selesai. PDF kamu jadi.
Gak perlu paham coding, gak perlu install Pandoc/LaTeX manual.
AI Agent + Docker yang urus semuanya.

---

## Lisensi

MIT License. Lihat [LICENSE](LICENSE) untuk detail.
