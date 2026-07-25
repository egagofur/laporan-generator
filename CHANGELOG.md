# Catatan Perubahan (CHANGELOG)

Semua perubahan penting pada project **Laporan Generator** akan didokumentasikan dalam file ini.

Format dokumen ini mengacu pada [Keep a Changelog](https://keepachangelog.com/id/1.0.0/) dan mematuhi [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
