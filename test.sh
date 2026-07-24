#!/usr/bin/env bash
set -e

PASS=0
FAIL=0

pass() { PASS=$((PASS+1)); echo "  ✅ $1"; }
fail() { FAIL=$((FAIL+1)); echo "  ❌ $1"; }

echo "=== Test Suite: Laporan Generator ==="
echo ""

# T1: Cek dependensi
echo "[T1] Dependency check"
if command -v pandoc &>/dev/null; then pass "pandoc tersedia"; else fail "pandoc tidak ada"; fi
if command -v pdflatex &>/dev/null; then pass "pdflatex tersedia"; else fail "pdflatex tidak ada"; fi
if command -v convert &>/dev/null; then pass "imagemagick tersedia"; else fail "imagemagick tidak ada"; fi
echo ""

# T2: Cek file wajib
echo "[T2] File structure check"
for f in cover.md template.latex build.sh metadata.yml references.bib; do
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
if grep -q 'documentclass' template.latex; then pass "template punya documentclass"; else fail "template tanpa documentclass"; fi
if grep -Fq 'pmboxdraw' template.latex; then pass "template pakai pmboxdraw (original)"; else fail "template tidak ada pmboxdraw"; fi
if grep -Fq '\sloppy' template.latex; then pass "template pakai \sloppy (original)"; else fail "template tidak ada \sloppy"; fi
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

echo "========================"
echo "Hasil: $PASS passed, $FAIL failed"
echo "========================"

[ "$FAIL" -eq 0 ] || exit 1
