<p align="center">
  <img src="laporan-generator.gif" alt="Laporan Generator" width="200" style="border-radius: 50%;"/>
</p>

<h1 align="center">Laporan Generator</h1>

<p align="center">
  Pipeline otomatisasi laporan akademik — dari Markdown ke PDF dalam satu perintah.
  <br>Referensi + tooling AI Agent untuk mahasiswa informatika.
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Pandoc-3.0+-blue?style=for-the-badge&logo=markdown"></a>
  <a href="#"><img src="https://img.shields.io/badge/LaTeX-pdflatex-008080?style=for-the-badge&logo=latex"></a>
  <a href="#"><img src="https://img.shields.io/badge/ImageMagick-7.0+-orange?style=for-the-badge&logo=imagemagick"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
</p>

---

## Tentang

Repositori ini menyediakan dua hal dalam satu tempat:

1. **Referensi** — Contoh laporan akademik lengkap (BAB 1–5) yang langsung bisa di-*build* jadi PDF.
   Cocok buat lihat struktur, gaya penulisan, dan format yang dihasilkan.
2. **Tooling** — Template LaTeX, skrip *build*, dan instruksi AI Agent (`prompt.md`) yang bisa
   di-*copy* ke project kamu untuk *generate* laporan sendiri secara otomatis.

Topik laporan mencakup project IT / informatika: web, *mobile*, *machine learning*, IoT,
tugas kuliah, dan lain-lain yang berbasis *coding*.

---

## Struktur

```
laporan-generator/
├── template/               # Tooling — siap-copy ke project user
│   ├── template.latex      #   Template LaTeX (format laporan)
│   ├── build.sh            #   Skrip build otomatis
│   ├── cover.md            #   Cover generic
│   ├── daftar-pustaka.md   #   Daftar pustaka
│   └── prompt.md           #   Instruksi AI Agent
├── prompt.md               # Instruksi AI Agent (copy ke root project)
├── cover.md                # Contoh cover
├── template.latex          # Contoh template
├── build.sh                # Contoh build script
├── logo-kampus.jpg         # Logo contoh
├── isi-laporan.md          # Contoh isi laporan (BAB 1–5)
├── daftar-pustaka.md       # Contoh daftar pustaka
├── Laporan.pdf             # Output contoh (langsung lihat hasilnya)
└── README.md               # File ini
```

---

## Cara Pakai (AI Agent Flow)

Ini *workflow* utama — biar AI yang generate seluruh laporan:

```
1. Clone repo ini → lihat contoh Laporan.pdf (referensi)
2. Copy prompt.md ke root project kamu
3. Copy folder template/ → project-kamu/laporan/
4. Jalankan AI (OpenCode, Claude Code, Gemini CLI, dll.) di folder project kamu
5. Load prompt.md ke AI:
     "Baca prompt.md dan generate laporan untuk project ini"
6. AI akan scan project + tanya interaktif (judul, screenshot, dll.)
7. AI generate file-file .md di dalam laporan/:
     cover.md, isi-laporan.md, daftar-pustaka.md
8. Jalankan:
     cd laporan/ && chmod +x build.sh && ./build.sh
9. → Laporan.pdf siap 🎉
```

> **Catatan:** Kamu juga bisa edit manual file `.md` di `laporan/` kalo mau
> ubah konten setelah di-generate AI, tinggal `./build.sh` lagi.

---

## Persyaratan

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
cd laporan/
chmod +x build.sh
./build.sh
```

Output: `Laporan.pdf`

---

## Alur Pipeline

```
isi-laporan.md ───┐
cover.md ─────────┤
daftar-pustaka.md ─┤─── Pandoc ─── Laporan.pdf
template.latex ───┤       │
logo-kampus.jpg ───┘       └── pdfLaTeX (engine)
                                  │
                           ImageMagick (alpha PNG)
                                  │
                           Bash (orkestrasi build)
```

---

## Lisensi

MIT License. Lihat [LICENSE](LICENSE) untuk detail.
