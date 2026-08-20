# KATA PENGANTAR {-}

Puji syukur kehadirat Tuhan Yang Maha Esa atas segala rahmat dan karunia-Nya sehingga laporan yang berjudul **"Otomatisasi Pembuatan Dokumen Laporan Akademik menggunakan Pandoc, LaTeX, dan Markdown"** dapat diselesaikan dengan baik.

Laporan ini disusun sebagai dokumentasi pipeline otomatisasi dokumen akademik yang dibangun menggunakan kombinasi teknologi Markdown, LaTeX, Pandoc, ImageMagick, dan Bash. Pipeline ini memungkinkan penulisan konten laporan dalam format Markdown yang sederhana, yang kemudian dikonversi menjadi PDF dengan format profesional melalui Pandoc dan pdfLaTeX.

Penulis menyadari bahwa laporan ini tidak dapat terselesaikan tanpa bantuan dari berbagai pihak. Oleh karena itu, penulis mengucapkan terima kasih kepada semua pihak yang telah memberikan dukungan dalam penyelesaian laporan ini.

Penulis menyadari bahwa laporan ini masih jauh dari sempurna. Oleh karena itu, kritik dan saran yang membangun sangat diharapkan untuk perbaikan di masa mendatang. Semoga laporan ini dapat memberikan manfaat bagi pembaca dalam memahami konsep otomatisasi dokumen akademik.

```{=typst}
#v(1fr)
#align(right)[
  Juli 2026

  #v(1cm)
  Tim Penyusun
]
#pagebreak()
#outline(
  title: [#align(center)[#text(size: 14pt, weight: "bold")[DAFTAR ISI]]],
  depth: 3,
)
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)
```

```{=openxml}
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
<w:p><w:pPr><w:pStyle w:val="Heading1"/><w:outlineLvl w:val="-1"/></w:pPr><w:r><w:t>DAFTAR ISI</w:t></w:r></w:p>
<w:p>
  <w:r><w:fldChar w:fldCharType="begin" w:dirty="true"/></w:r>
  <w:r><w:instrText xml:space="preserve"> TOC \o "1-3" \h \z \u </w:instrText></w:r>
  <w:r><w:fldChar w:fldCharType="separate"/></w:r>
  <w:r><w:t xml:space="preserve">Perbarui daftar isi: klik kanan lalu pilih Update Field (F9)</w:t></w:r>
  <w:r><w:fldChar w:fldCharType="end"/></w:r>
</w:p>
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
```

```{=latex}
\newpage
```