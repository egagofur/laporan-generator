<p align="center">
  <img src="logo.jpg" alt="Laporan Generator" width="200"/>
</p>

<h1 align="center">Laporan Generator</h1>

<p align="center">
  Pipeline otomatisasi laporan akademik — dari Markdown ke PDF dalam satu perintah.
  <br>Referensi + tooling AI Agent.
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Pandoc-3.0+-blue?style=for-the-badge&logo=markdown"></a>
  <a href="#"><img src="https://img.shields.io/badge/LaTeX-pdflatex-008080?style=for-the-badge&logo=latex"></a>
  <a href="#"><img src="https://img.shields.io/badge/ImageMagick-7.0+-orange?style=for-the-badge"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
</p>

---

## Tentang

Repositori ini adalah contoh laporan akademik lengkap (BAB 1–5) yang bisa langsung kamu
*clone* ke project kamu, jalankan AI Agent untuk me-*generate* ulang isinya sesuai project,
dan *build* jadi PDF dalam satu perintah.

Topik laporan mencakup project IT / informatika: web, *mobile*, *machine learning*, IoT,
tugas kuliah, dan lain-lain yang berbasis *coding*.

---

## Struktur

```
laporan-generator/
├── build.sh                 # Skrip build
├── cover.md                 # Contoh cover → di-overwrite AI
├── daftar-pustaka.md        # Contoh daftar pustaka → di-overwrite AI
├── isi-laporan.md           # Contoh isi laporan (BAB 1—5) → di-overwrite AI
├── template.latex           # Template LaTeX
├── logo.jpg          # Logo (cover PDF & header README)
├── prompt.md                # Instruksi AI Agent
├── README.md                # File ini
├── Laporan.pdf              # Output contoh (langsung lihat hasilnya)
├── LICENSE                  # Lisensi MIT
└── .gitignore
```

## Cara Pakai (AI Agent Flow)

Ini *workflow* utama — clone, jalanin AI, langsung build:

```
1. Clone repo ini ke dalam folder project kamu:

     git clone https://github.com/muadzhdz/laporan-generator.git project-kamu/
     cd project-kamu/

2. Jalankan AI Agent (OpenCode, Claude Code, Gemini CLI, dll.):

     "Baca prompt.md dan generate laporan untuk project ini"

3. AI akan scan project kamu + tanya interaktif (judul, fitur, screenshot, dll.)
   → LANGSUNG overite file-file di repo ini:
     cover.md, isi-laporan.md, daftar-pustaka.md

4. Jalankan build:

     ./build.sh

5. → Laporan.pdf siap
```

> **Catatan:** Mau ubah isi? Edit manual file `.md` terus `./build.sh` lagi.

---

## Persyaratan

**Tools yang diperlukan:**

| Tool | Fungsi |
|------|--------|
| **Pandoc** | Konversi file Markdown ke format LaTeX |
| **TeX Live** | *Engine* pdfLaTeX untuk *build* PDF dari LaTeX |
| **ImageMagick** | Menghapus *alpha channel* pada gambar PNG |
| **Font Nimbus** | Pengganti *open source* untuk Times New Roman |

Pilih perintah instalasi sesuai distro kamu:

### Arch Linux
```bash
sudo pacman -S pandoc texlive-core texlive-latex texlive-latexextra texlive-latexrecommended texlive-fontsextra texlive-fontsrecommended imagemagick
```

### Ubuntu / Debian
```bash
sudo apt install pandoc texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-fonts-extra texlive-fonts-recommended imagemagick
```

### RHEL / Fedora
```bash
sudo dnf install pandoc texlive-scheme-medium texlive-collection-latexextra texlive-collection-fontsrecommended imagemagick
```

### Setup (satu kali, semua distro)
```bash
sudo fmtutil-sys --all
```

---

## Build Manual

Kalo semua tools udah terinstal:

```bash
./build.sh
```

Output: `Laporan.pdf`

---

## Alur Pipeline

```
isi-laporan.md ────────────────┐
cover.md ──────────────────────┤
daftar-pustaka.md ─────────────┤─── Pandoc ─── Laporan.pdf
template.latex ────────────────┤
logo.jpg ────────────────┤
gambar/ ───────────────────────┘
                               │
                               ├── pdfLaTeX
                               │
                               ├── ImageMagick
                               │
                               └── Bash (orkestrasi)
```


## Lisensi

MIT License. Lihat [LICENSE](LICENSE) untuk detail.
