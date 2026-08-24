# Panduan Arsitektur Template Typst (template.typ)

File `template.typ` merupakan jantung dari pemformatan visual PDF pada **Laporan Generator**. Template ini dirancang untuk memenuhi standar penyusunan laporan akademik resmi di Indonesia, dan dikompilasi dengan **Typst** sebagai engine typesetting.

> **Catatan**: Pipeline utama sepenuhnya menggunakan **Typst** (`template.typ`). Template LaTeX lama diarsipkan pada branch `legacy/latex-engine`.

---

## Desain Arsitektur & Pemilihan Font

### 1. Pemilihan Font (Libertinus Serif)
* Standardisasi karya ilmiah di Indonesia mewajibkan penggunaan font tipe *Times New Roman* 12pt.
* Untuk menjamin portabilitas kompilasi cross-platform tanpa dependensi font eksternal, template menggunakan **Libertinus Serif** (`Libertinus Serif`) yang sudah dibundel langsung di dalam binary Typst.
* Blok kode menggunakan **DejaVu Sans Mono** (juga font bawaan Typst).

### 2. Pengaturan Margin & Spacing
```typst
#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
)
#set text(font: "Libertinus Serif", size: 12pt)
#set par(justify: true, leading: 1.5em)
```
* Margin Kiri & Kanan: 2.5 cm
* Margin Atas: 2.0 cm
* Margin Bawah: 3.0 cm
* Spasi Antar Baris: 1.5 spasi (*one half spacing*)
* Paragraf rata kanan-kiri (*justify*)

---

## Penomoran Bab dan Halaman

### 1. Format Bab & Heading
```typst
#set heading(numbering: (..ns) => {
  if ns.len() == 1 {
    "BAB " + numbering("I", ns.at(0)) + linebreak()
  } else if ns.len() == 2 {
    numbering("1.1", ..ns)
  } else {
    numbering("1.1.1", ..ns)
  }
})
```
* **Bab**: Diformat dengan Angka Romawi (`BAB I`, `BAB II`, `BAB III`, dst). Angka Romawi dan judul dipisahkan oleh *line break*.
* **Sub-bab**: Diformat dengan Angka Arab (`1.1`, `1.2`, `2.1`).
* **Sub-sub-bab**: Diformat dengan Angka Arab 3 tingkat (`1.1.1`, `1.1.2`).
* **Heading tanpa nomor** (Kata Pengantar, Daftar Isi, Daftar Pustaka): menggunakan `{-}` di Markdown yang diterjemahkan Pandoc menjadi `#heading(level: 1, numbering: none)`.

> **Catatan**: Jangan menulis pola `"BAB I"` langsung sebagai format string `numbering(...)`. Typst menginterpretasikan rangkaian huruf `BAB` sebagai pola huruf dan memotong angka Romawinya. Selalu concat literal secara manual: `"BAB " + numbering("I", n)`.

### 2. Penomoran Halaman (frontmatter vs mainmatter)
* **Bagian Depan** (Kata Pengantar, Daftar Isi): Menggunakan penomoran Romawi kapital (`I`, `II`, `III`) di bagian tengah bawah. Diatur di `cover.md`:
  ```typst
  #set page(numbering: "I")
  ```
* **Bagian Utama** (BAB I hingga BAB V): Menggunakan penomoran Angka Arab (`1`, `2`, `3`) berurutan, di-reset ulang:
  ```typst
  #set page(numbering: "1")
  #counter(page).update(1)
  ```

---

## Halaman Sampul (Cover)

Bagian sampul dirender dari metadata `metadata.yml` dengan variabel: `title`, `subtitle`, `course`, `lecturer`, `authors`, `institution`, `logo`, `year`.

```typst
#block(
  width: 100%,
  align(center)[
    #image(logo, width: 4cm)
    ...
  ]
)
```

---

## Pemrosesan Elemen Konten

### 1. Tabel
```typst
#show table: set stroke(0.75pt)
#show table.header: set text(weight: "bold")
```
* Header tabel dicetak tebal, garis tabel 0.75pt.

### 2. Gambar
* Caption gambar dirender di bawah gambar (`#show figure: set figure.caption(position: bottom)`).
* Gambar diproses oleh ImageMagick di `build.sh` (alpha channel dihapus) sebelum dikompilasi.

### 3. Blok Kode
```typst
#show raw: set text(font: "DejaVu Sans Mono", size: 9pt)
```
* Blok kode menggunakan font monospaced 9pt dengan latar abu-abu muda (`#show raw: set block(fill: luma(240))`).