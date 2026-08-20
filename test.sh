#!/usr/bin/env bash
set -e

PASS=0
FAIL=0

pass() { PASS=$((PASS+1)); echo "  [OK] $1"; }
fail() { FAIL=$((FAIL+1)); echo "  [FAIL] $1"; }

echo "=== Test Suite: Laporan Generator ==="
echo ""

# T1: Cek dependensi
echo "[T1] Dependency check"
if command -v pandoc &>/dev/null; then pass "pandoc tersedia"; else fail "pandoc tidak ada"; fi
if command -v typst &>/dev/null; then pass "typst tersedia"; else fail "typst tidak ada"; fi
if command -v convert &>/dev/null; then pass "imagemagick tersedia"; else fail "imagemagick tidak ada"; fi
echo ""

# T2: Cek file wajib
echo "[T2] File structure check"
for f in cover.md template.typ build.sh metadata.yml references.bib reference.docx docx.lua; do
  if [ -f "$f" ]; then pass "$f ditemukan"; else fail "$f tidak ada"; fi
done
if [ -d chapters ] && ls chapters/bab*.md &>/dev/null; then
  pass "Konten laporan ditemukan (chapters/)"
else
  fail "Tidak ada konten laporan di chapters/"
fi
echo ""

# T3: Cek metadata validity
echo "[T3] Metadata check"
if grep -q '^title:' metadata.yml 2>/dev/null; then pass "metadata.yml punya title"; else fail "metadata.yml tidak punya title"; fi
if grep -q '^author:' metadata.yml 2>/dev/null; then pass "metadata.yml punya author"; else fail "metadata.yml tidak punya author"; fi
echo ""

# T4: Cek template validity
echo "[T4] Template check"
if grep -q '^#set page' template.typ; then pass "template punya konfigurasi halaman (#set page)"; else fail "template tanpa #set page"; fi
if grep -Fq '$body$' template.typ; then pass "template punya placeholder \$body\$"; else fail "template tanpa placeholder \$body\$"; fi
if grep -Fq 'set heading(numbering' template.typ; then pass "template punya penomoran heading otomatis"; else fail "template tanpa penomoran heading"; fi
echo ""

# T5: Cek gitignore
echo "[T5] .gitignore check"
if grep -Fq '*.pdf' .gitignore; then pass ".gitignore mengecualikan *.pdf"; else fail ".gitignore tidak exclude *.pdf"; fi
if ! grep -q '!Laporan.pdf' .gitignore 2>/dev/null; then pass ".gitignore tidak exception Laporan.pdf"; else fail ".gitignore masih exception Laporan.pdf"; fi
echo ""

# T6: Cek Dockerfile
echo "[T6] Docker check"
if [ -f Dockerfile ]; then pass "Dockerfile ada"; else fail "Dockerfile tidak ada"; fi
if [ -f docker-compose.yml ]; then pass "docker-compose.yml ada"; else fail "docker-compose.yml tidak ada"; fi
echo ""

# T7: Build test
echo "[T7] Build PDF"
if ./build.sh; then
  pass "Build sukses"
  if [ -f Laporan.pdf ]; then
    SIZE=$(stat -c%s Laporan.pdf 2>/dev/null || stat -f%z Laporan.pdf 2>/dev/null)
    if [ "$SIZE" -gt 50000 ]; then
      pass "PDF valid ($(numfmt --to=iec $SIZE 2>/dev/null || echo ${SIZE}B))"
    else
      fail "PDF terlalu kecil ($SIZE bytes)"
    fi
  else
    fail "Laporan.pdf tidak dihasilkan"
  fi
else
  fail "Build gagal"
fi
echo ""

# T8: Cek box-drawing di konten
echo "[T8] No box-drawing characters"
if grep -rn '[├─└│]' chapters/ 2>/dev/null; then
  fail "Masih ada box-drawing characters"
else
  pass "Tidak ada box-drawing characters"
fi
echo ""

# T9: Cek manual numbering di heading
echo "[T9] No manual numbering in headings"
if grep -rn '^## [0-9]\+\.' chapters/ 2>/dev/null; then
  fail "Masih ada manual numbering di heading (harusnya ## Judul, bukan ## 1.1 Judul)"
else
  pass "Tidak ada manual numbering di heading level 2"
fi
if grep -rn '^### [0-9]\+\.' chapters/ 2>/dev/null; then
  fail "Masih ada manual numbering di heading level 3"
else
  pass "Tidak ada manual numbering di heading level 3"
fi
echo ""

# T10: Cek metadata fields
echo "[T10] Metadata fields check"
if grep -q '^lecturer:' metadata.yml 2>/dev/null; then
  pass "metadata.yml punya lecturer"
else
  fail "metadata.yml tidak punya lecturer"
fi
if grep -q '^course:' metadata.yml 2>/dev/null; then
  pass "metadata.yml punya course"
else
  fail "metadata.yml tidak punya course"
fi
echo ""

# T11: Cek format BibTeX
echo "[T11] References check"
if grep -qE '^@[a-zA-Z]+{' references.bib 2>/dev/null; then
  pass "references.bib memiliki struktur BibTeX valid"
else
  fail "references.bib tidak memiliki entri BibTeX valid"
fi
echo ""

# T12: Cek target Makefile (init & view)
echo "[T12] Makefile targets check"
if grep -q 'init:' Makefile 2>/dev/null && grep -q 'view:' Makefile 2>/dev/null; then
  pass "Makefile memiliki target init dan view"
else
  fail "Makefile tidak memiliki target init atau view"
fi
echo ""

# T13: Cek recursive image processing
echo "[T13] Recursive image processing check"
if grep -q 'find.*gambar' build.sh 2>/dev/null; then
  pass "build.sh mendukung pemrosesan gambar rekursif (find)"
else
  fail "build.sh belum mendukung pemrosesan gambar rekursif"
fi
echo ""

# T14: Cek ekstrasi dan keterbacaan teks PDF
echo "[T14] PDF content readability check"
if command -v pdftotext &>/dev/null; then
  if [ -f Laporan.pdf ]; then
    WORDS=$(pdftotext Laporan.pdf - 2>/dev/null | wc -w)
    if [ "$WORDS" -gt 200 ]; then
      pass "PDF readable ($WORDS kata terdeteksi)"
    else
      fail "PDF terlalu sedikit konten atau corrupt ($WORDS kata)"
    fi
  else
    fail "Laporan.pdf tidak ditemukan untuk diaudit"
  fi
else
  pass "pdftotext tidak terinstall (skipped)"
fi
echo ""

# T15: Cek engine Typst pada pipeline
echo "[T15] Typst engine check"
if grep -q -- '--pdf-engine=typst' build.sh 2>/dev/null; then
  pass "build.sh menggunakan pdf-engine typst"
else
  fail "build.sh belum menggunakan pdf-engine typst"
fi
echo ""

# T16: Cek kualitas DOCX export
echo "[T16] DOCX export check"
if command -v unzip &>/dev/null; then
  if make docx >/dev/null 2>&1; then
    pass "make docx sukses"
    if [ -f Laporan.docx ]; then
      DOCXML=$(unzip -p Laporan.docx word/document.xml 2>/dev/null)
      STYXML=$(unzip -p Laporan.docx word/styles.xml 2>/dev/null)
      if echo "$DOCXML" | grep -q 'BAB I PENDAHULUAN'; then
        pass "docx punya penomoran BAB I (kapital)"
      else
        fail "docx tanpa penomoran BAB I"
      fi
      if echo "$DOCXML" | grep -q 'KATA PENGANTAR' && ! echo "$DOCXML" | grep -q 'BAB I KATA PENGANTAR'; then
        pass "KATA PENGANTAR tanpa nomor bab"
      else
        fail "KATA PENGANTAR ke-numbering BAB I"
      fi
      if echo "$DOCXML" | grep -q 'instrText'; then
        pass "docx punya field DAFTAR ISI (TOC)"
      else
        fail "docx tanpa field TOC"
      fi
      if echo "$STYXML" | grep -q 'Times New Roman'; then
        pass "docx memakai Times New Roman"
      else
        fail "docx tanpa Times New Roman"
      fi
      if echo "$DOCXML" | grep -q 'w:w="11906"'; then
        pass "docx ukuran halaman A4"
      else
        fail "docx bukan A4"
      fi
      if echo "$STYXML" | grep -q 'w:val="28"'; then
        pass "Heading1 berukuran 14pt (sz 28)"
      else
        fail "Heading1 bukan 14pt"
      fi
    else
      fail "Laporan.docx tidak dihasilkan"
    fi
  else
    fail "make docx gagal"
  fi
else
  pass "unzip tidak terinstall (skipped)"
fi
echo ""

echo "========================"
echo "Hasil: $PASS passed, $FAIL failed"
echo "========================"

[ "$FAIL" -eq 0 ] || exit 1
