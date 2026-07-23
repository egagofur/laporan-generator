# PENDAHULUAN

## Latar Belakang

Penulisan laporan akademik merupakan kegiatan yang tidak terpisahkan dari dunia pendidikan. Mahasiswa, dosen, dan peneliti secara rutin menghasilkan laporan tugas akhir, skripsi, tesis, makalah, jurnal, dan berbagai dokumen akademik lainnya. Kualitas laporan tidak hanya diukur dari isi ilmiahnya, tetapi juga dari format penyajian dan konsistensi tampilan.

Metode penulisan laporan yang umum digunakan saat ini masih mengandalkan word processor seperti Microsoft Word atau LibreOffice Writer. Pendekatan ini memiliki beberapa kelemahan signifikan:

1. **Inkonsistensi format** --- Setiap pengguna memiliki cara berbeda dalam mengatur format. Perubahan template di tengah pengerjaan seringkali membutuhkan penyesuaian manual satu per satu pada setiap bagian dokumen.

2. **Revisi yang memakan waktu** --- Perubahan format, penomoran, atau tata letak seringkali mengharuskan pengguna mengedit ulang seluruh dokumen secara manual. Hal ini sangat tidak efisien, terutama untuk dokumen panjang.

3. **Ketidakcocokan dengan version control** --- Format file word processor bersifat binary (bukan teks biasa), sehingga tidak dapat di-diff dengan mudah. Git dan sistem version control lainnya tidak dapat melacak perubahan secara granular pada file seperti `.docx`.

4. **Kolaborasi yang rumit** --- Menggabungkan perubahan dari beberapa kontributor seringkali menyebabkan masalah format, layout yang berantakan, atau bahkan data hilang.

Konsep pemisahan konten dari tampilan (separation of concerns) telah lama dikenal dalam dunia pengembangan perangkat lunak. Dalam konteks penulisan dokumen, konsep ini berarti bahwa penulis cukup fokus pada konten laporan, sementara tampilan dan format ditangani secara terpisah oleh sistem typesetting.

Pendekatan yang ditawarkan adalah kombinasi tiga teknologi utama:
- **Markdown** sebagai format penulisan konten yang ringan dan mudah dibaca
- **LaTeX** sebagai sistem typesetting untuk format dokumen profesional
- **Pandoc** sebagai universal document converter yang menjembatani Markdown dan LaTeX

Ketiga teknologi ini digabungkan dalam sebuah pipeline otomatisasi yang dijalankan melalui skrip Bash. Pipeline ini mengambil file Markdown sebagai input, memprosesnya dengan Pandoc menggunakan template LaTeX, dan menghasilkan output PDF yang siap digunakan. Seluruh proses dijalankan dengan satu perintah di terminal.

Laporan ini membahas secara rinci pipeline otomatisasi dokumen akademik tersebut, mulai dari teknologi yang digunakan, arsitektur pipeline, implementasi, hingga studi kasus penerapannya pada project Laporan Generator.

## Rumusan Masalah

Berdasarkan latar belakang di atas, rumusan masalah dalam laporan ini adalah:

1. Apa yang dimaksud dengan Markdown, LaTeX, dan Pandoc, serta bagaimana peran masing-masing dalam otomatisasi dokumen?
2. Bagaimana struktur template LaTeX yang digunakan untuk menghasilkan laporan akademik?
3. Bagaimana alur kerja konversi dokumen dari format Markdown ke PDF menggunakan Pandoc?
4. Bagaimana cara menangani gambar dalam pipeline otomatisasi dokumen?
5. Bagaimana skrip Bash digunakan untuk mengotomatisasi seluruh proses build?
6. Bagaimana struktur file dan implementasi pipeline pada project Laporan Generator?

## Tujuan

Tujuan dari laporan ini adalah:

1. Menjelaskan konsep Markdown, LaTeX, dan Pandoc serta peran masing-masing dalam pipeline otomatisasi dokumen
2. Menguraikan struktur template LaTeX yang digunakan untuk laporan akademik
3. Menjelaskan alur konversi dokumen dari Markdown ke PDF menggunakan Pandoc dengan engine pdfLaTeX
4. Menjelaskan teknik penanganan gambar dalam pipeline menggunakan ImageMagick
5. Menjelaskan implementasi skrip Bash sebagai orkestrator pipeline
6. Menyajikan studi kasus implementasi pipeline pada project Laporan Generator, termasuk struktur file dan cara penggunaannya

## Manfaat

Manfaat dari laporan ini adalah:

1. Memberikan pemahaman tentang konsep pemisahan konten dan tampilan dalam penulisan dokumen akademik
2. Menyediakan referensi implementasi pipeline otomatisasi dokumen yang dapat direproduksi
3. Meningkatkan efisiensi pembuatan laporan akademik melalui otomatisasi
4. Menghasilkan format laporan yang konsisten, profesional, dan sesuai standar
5. Memudahkan kolaborasi dan version control melalui penggunaan format teks

## Batasan

Batasan dalam laporan ini adalah:

1. Output dokumen yang dihasilkan dalam format PDF
2. Tools utama yang digunakan: Pandoc, pdfLaTeX, ImageMagick, dan Bash
3. Template LaTeX menggunakan font Nimbus Serif sebagai pengganti Times New Roman
4. Ukuran kertas A4 dengan margin kiri dan kanan 2,5 cm, atas 2 cm, dan bawah 3 cm
5. Sistem operasi yang digunakan adalah Linux (Ubuntu/Debian), meskipun konsep yang diterapkan berlaku universal


