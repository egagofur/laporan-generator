# Catatan Perubahan (CHANGELOG)

Semua perubahan penting pada project **Laporan Generator** akan didokumentasikan dalam file ini.

Format dokumen ini mengacu pada [Keep a Changelog](https://keepachangelog.com/id/1.0.0/) dan mematuhi [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.1.0] - 2026-08-20

### Added
- **Export DOCX profesional**: `make docx` kini memakai `reference.docx` (template gaya Word) dan `docx.lua` (filter Lua). Hasil: halaman A4, margin 2/3/2.5/2.5 cm, Times New Roman 12pt justify spasi 1.5, Heading 1 (judul BAB) 14pt bold rata tengah, Heading 2/3 12pt bold rata kiri, penomoran `BAB I`/`1.1.`/`1.1.1` otomatis, field DAFTAR ISI Word (`TOC \o "1-3"`), dan KATA PENGANTAR tanpa nomor.
- **Cover DOCX meniru cover PDF**: logo, judul seimbang (tanpa kata sendirian, `balance_title` DP), subjudul, mata kuliah, dosen pengampu, daftar penulis (nama + NIM), dan institusi (fakultas/kampus/tahun) memakai style khusus `CoverImage`, `CoverTitle`, `CoverSubtitle`, `CoverLine`, `CoverInstitution`; title block bawaan pandoc dinonaktifkan.
- **`scripts/make-reference-docx.py`**: Skrip untuk meregenerasi `reference.docx` dari reference bawaan pandoc (`make reference-docx`).
- **Test T16**: Validasi DOCX export (penomoran BAB, KATA PENGANTAR tanpa nomor, field TOC, Times New Roman, ukuran A4, Heading 14pt, cover logo + style cover + title block hilang) -- total 43 assertions.
- Dependensi `unzip` di flake.nix, Dockerfile, dan CI untuk inspeksi DOCX.

### Changed
- **Format heading PDF mengikuti pedoman kampus**: Judul BAB kini dua baris (`BAB II` di baris pertama, judul kapital di baris kedua), 14pt bold, rata tengah; sub-bab `1.1.` (titik di akhir) 12pt bold bernomor di body; DAFTAR ISI terstruktur (judul bold 14pt, dot leaders, indent sub-bab & sub-sub-bab, spasi antar bab) tetap satu baris.
- **Judul sampul seimbang tanpa kata sendirian**: `balance-lines` (dynamic programming) membagi judul menjadi maksimal 4 baris berbentuk piramida, contoh: `SISTEM INFORMASI PEMESANAN / KANTIN SEKOLAH BERBASIS WEB / MENGGUNAKAN REACT DAN / NODE.JS`.
- **Judul sampul & info institusi 14pt kapital penuh** (`LAPORAN DOKUMENTASI PIPELINE`), fakultas/kampus/tahun di-uppercase otomatis.
- `make docx` kini menyertakan `cover.md` (KATA PENGANTAR + field DAFTAR ISI Word).

---

## [2.0.0] - 2026-08-20

### Changed
- **Engine PDF berpindah dari LaTeX ke Typst**: Pipeline utama kini memakai `--pdf-engine=typst` dengan template baru `template.typ`, menggantikan `template.latex` (disimpan sebagai arsip legacy dan tidak lagi dipakai pipeline utama).
- **Penomoran bab otomatis** (`BAB I`, `BAB II`, dst; sub-bab `1.1`, `1.1.1`) kini ditangani sepenuhnya oleh Typst via `set heading(numbering: ...)`.
- **Dependensi jauh lebih ringan**: Hapus seluruh paket TeX Live (~3.5 GB) dari Dockerfile, flake.nix, dan CI. Sekarang cukup binary Typst (~25 MB) + Pandoc + ImageMagick.
- **Dokumentasi di-update**: `README.md`, `docs/template-guide.md` (arsitektur `template.typ`), dan `docs/troubleshooting.md` (isu font Typst & sintaks raw).

### Removed
- `fmtutil-sys --all` dari Dockerfile dan CI workflows (khusus TeX Live).
- Tes `template.latex` (documentclass, pmboxdraw, \sloppy, \pandocbounded) diganti dengan pemeriksaan spesifik Typst.

---

## [1.2.0] - 2026-07-25

### Added
- **Release Automation Workflow**: Tambahan `.github/workflows/release.yml` untuk automated release ketika ada git tag push
- **Remove All Emojis**: Menghapus semua emoji dari dokumentasi untuk tone yang lebih profesional dan akademik-appropriate
- **Structured Case Study Examples**: Reorganisasi `examples/` menjadi 3 folder terstruktur:
  - `01-Web-App/` — Laporan aplikasi React + Node.js
  - `02-Machine-Learning/` — Laporan CNN image classification dengan PyTorch
  - `03-IoT-Project/` — Laporan smart home monitoring dengan ESP32
- **Standardized Test Output**: Update `test.sh` untuk menggunakan indicator output bersih ([OK] / [FAIL] / [ERROR])
- **GitHub Discussions**: Enable Discussions untuk community Q&A, showcase, dan feature requests
- **GitHub Stats Badges**: Tambah badges untuk Stars, Forks, Issues, dan Last Commit di README

### Improved
- Documentation consistency across all files (no emojis, professional tone)
- Release automation dengan auto-build example PDF on tag push
- Test output clarity dan debugging experience
- README header dengan stats badges untuk professional appearance

---

## [1.1.0] - 2026-07-25

### Added
- **Peningkatan Dokumen Modular**: Menambahkan `GETTING-STARTED.md`, `CONTRIBUTING.md`, dan folder `docs/` (`metadata-schema.md`, `template-guide.md`, `troubleshooting.md`).
- **Deep PDF Testing (T14 & T15)**: Pengujian ekstraksi teks PDF (`pdftotext`) dan penanganan makro Pandoc 3.x di `test.sh`.
- **Target Makefile Baru**: Target `make init` untuk setup Git pre-commit hook otomatis dan `make view` untuk membuka PDF di viewer.
- **Support Macro `\pandocbounded`**: Penanganan kompatibilitas gambar otomatis untuk Pandoc 3.x pada `template.latex`.
- **Informative Error Messages**: Peningkatan penanganan dan konteks kesalahan pada `build.sh`.
- **GitHub Issue & PR Templates**: Menambahkan `.github/ISSUE_TEMPLATE/` dan `.github/PULL_REQUEST_TEMPLATE.md`.
- **Automated Examples Script**: Menambahkan `examples/generate_examples.sh` untuk membuat sampel PDF bagi studi kasus Web, ML, dan IoT.

### Fixed
- Memperbaiki pengolahan gambar PNG agar mendukung pemrosesan *alpha channel* secara rekursif hingga *subfolder* gambar.
- Memperbaiki target `make clean` di `Makefile` agar menghapus artifact `.docx` dan `.html`.

---

## [1.0.0] - 2026-07-24

### Added
- Rilis perdana Laporan Generator akademik berbasis Pandoc, LaTeX, dan Docker.
- Dukungan 3 metode kompilasi (AI Agent, Manual CLI, Docker Compose).
- Integrasi APA Citation Style (`apa.csl`) & BibTeX (`references.bib`).
- Pengujian otomatis 25 assertions (`test.sh`).
- Workflow CI/CD GitHub Actions dan Git Pre-commit Hooks.
