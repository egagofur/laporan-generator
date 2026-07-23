# PENUTUP

## Kesimpulan

Berdasarkan pembahasan yang telah dilakukan, dapat ditarik kesimpulan sebagai berikut:

1. **Markdown, LaTeX, dan Pandoc** memiliki peran yang saling melengkapi dalam otomatisasi dokumen. Markdown berfungsi sebagai format penulisan konten yang ringan dan mudah dibaca. LaTeX berfungsi sebagai sistem typesetting untuk format dokumen profesional. Pandoc berfungsi sebagai jembatan konversi yang menghubungkan keduanya.

2. **Template LaTeX** untuk laporan akademik terdiri dari beberapa komponen utama: document class (book), font (Nimbus Serif), margin (2,5 cm kiri/kanan, 2 cm atas, 3 cm bawah), spasi (1,5 spasi), penomoran (Romawi untuk BAB, Arab untuk sub-bab), dan daftar isi (dengan entri BAB tebal).

3. **Alur konversi dokumen** dari Markdown ke PDF melalui tiga tahap: parsing Markdown ke AST oleh Pandoc, konversi AST ke LaTeX menggunakan template, dan kompilasi LaTeX ke PDF oleh pdfLaTeX. Seluruh alur dijalankan dengan satu perintah Pandoc.

4. **Penanganan gambar** dalam pipeline menggunakan ImageMagick untuk menghapus alpha channel dari file PNG, mencegah masalah kompatibilitas dengan pdfLaTeX. Perintah `convert -alpha off` mengganti area transparan dengan latar belakang putih.

5. **Skrip Bash** berhasil mengotomatisasi seluruh pipeline dengan fitur-fitur penting: error handling dengan `set -e`, direktori temporer dengan `mktemp`, pembersihan otomatis dengan `trap`, dan eksekusi Pandoc dengan parameter yang tepat.

6. **Pipeline otomatisasi** yang diimplementasikan pada project Laporan Generator berhasil menghasilkan dokumen PDF dengan format konsisten dan profesional. Struktur file yang modular (direktori `chapters/`, `metadata.yml`, `references.bib`, dan Makefile) memudahkan penggunaan dan modifikasi.

## Saran

Untuk pengembangan pipeline otomatisasi dokumen selanjutnya, beberapa saran yang dapat diberikan:

1. **Continuous Integration / Continuous Deployment (CI/CD)** --- Pipeline dapat diintegrasikan dengan GitHub Actions atau GitLab CI untuk build otomatis setiap kali ada perubahan di repository. Setiap push akan menghasilkan PDF terbaru tanpa perlu menjalankan build manual.

2. **Multi-format output** --- Pandoc mendukung berbagai format output selain PDF, seperti HTML, EPUB, dan DOCX. Pipeline dapat dikembangkan untuk menghasilkan beberapa format sekaligus.

3. **Template kustomisasi** --- Template LaTeX dapat dikembangkan dengan lebih banyak variasi, seperti template untuk laporan magang, skripsi, makalah, dan jurnal. Masing-masing template dapat memiliki pengaturan format yang berbeda.

4. **Integrasi dengan reference manager** --- Daftar pustaka dapat diintegrasikan dengan file BibTeX atau CSL (Citation Style Language) untuk manajemen referensi yang lebih baik.

5. **Penjadwalan build otomatis** --- Pipeline dapat dijadwalkan menggunakan cron job untuk build periodik, berguna untuk dokumen yang memerlukan update rutin.

6. **Validasi konten** --- Pipeline dapat dilengkapi dengan validasi otomatis untuk memeriksa kesalahan penulisan (typo, inkonsistensi format, referensi yang tidak lengkap) sebelum build.
