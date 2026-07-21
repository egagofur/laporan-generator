#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
OUTDIR="$DIR"
REPORT="$OUTDIR/Laporan.pdf"

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cp "$OUTDIR/cover.md" "$TMPDIR/"
cp "$OUTDIR/isi-laporan.md" "$TMPDIR/"
cp "$OUTDIR/daftar-pustaka.md" "$TMPDIR/"
cp "$OUTDIR/template.latex" "$TMPDIR/"
cp "$OUTDIR/logo-kampus.jpg" "$TMPDIR/"

if [ -d "$OUTDIR/gambar" ]; then
  cp -r "$OUTDIR/gambar" "$TMPDIR/"
  for f in "$TMPDIR/gambar/"*.png; do
    [ -f "$f" ] && convert "$f" -alpha off "$f" 2>/dev/null || true
  done
fi

# Generate fontools_ts1.enc
cat > "$TMPDIR/fontools_ts1.enc" << 'EOF'
/TS1Encoding [
  /grave /acute /circumflex /tilde /dieresis /hungarumlaut /ring /caron
  /breve /macron /dotaccent /cedilla /ogonek /quotesinglbase /guilsinglleft
  /guilsinglright /quotedblbase /quotedblleft /quotedblright /dagger
  /daggerdbl /bullet /ellipsis /emdash /endash /florin /fraction /onesuperior
  /twosuperior /threesuperior /onequarter /onehalf /threequarters /ordfeminine
  /ordmasculine /agrave /Agrave /acircumflex /Acircumflex /atilde /Atilde
  /adieresis /Adieresis /aring /Aring /ae /AE /ccedilla /Ccedilla /egrave
  /Egrave /ecircumflex /Ecircumflex /edieresis /Edieresis /igrave /Igrave
  /icircumflex /Icircumflex /idieresis /Idieresis /ntilde /Ntilde /ograve
  /Ograve /ocircumflex /Ocircumflex /otilde /Otilde /odieresis /Odieresis
  /oe /OE /oslash /Oslash /ugrave /Ugrave /ucircumflex /Ucircumflex
  /udieresis /Udieresis /yacute /Yacute /thorn /Thorn /germandbls
  /quotesinglbase /quotedblbase /quotedblleft /quotedblright /dagger
  /daggerdbl /bullet /ellipsis
] def
EOF

# Generate t1jtm.fd font definition
cat > "$TMPDIR/t1jtm.fd" << 'FDEOF'
\ProvidesFile{t1jtm.fd}
   [2010/11/10 Fontinst v1.927 font definitions for T1/jtm (patched).]

\expandafter\ifx\csname Jtms@scale\endcsname\relax
 \let\Jtms@@scale\@empty
\else
 \edef\Jtms@@scale{s*[\csname Jtms@scale\endcsname]}%
\fi%

\DeclareFontFamily{T1}{jtm}{}

\DeclareFontShape{T1}{jtm}{c}{n}{<->\Jtms@@scale jtmr8tc}{}
\DeclareFontShape{T1}{jtm}{m}{n}{<->\Jtms@@scale jtmr8te}{}
\DeclareFontShape{T1}{jtm}{m}{it}{<->\Jtms@@scale jtmri8te}{}
\DeclareFontShape{T1}{jtm}{m}{sl}{<->\Jtms@@scale jtmro8te}{}
\DeclareFontShape{T1}{jtm}{m}{sc}{<->\Jtms@@scale jtmrc8te}{}
\DeclareFontShape{T1}{jtm}{b}{n}{<-> ssub * jtm/bx/n}{}
\DeclareFontShape{T1}{jtm}{b}{it}{<-> ssub * jtm/bx/it}{}
\DeclareFontShape{T1}{jtm}{b}{sl}{<-> ssub * jtm/bx/sl}{}
\DeclareFontShape{T1}{jtm}{b}{sc}{<-> ssub * jtm/bx/sc}{}
\DeclareFontShape{T1}{jtm}{x}{n}{<->\Jtms@@scale jtmr8tw}{}
\DeclareFontShape{T1}{jtm}{x}{it}{<->\Jtms@@scale jtmri8tw}{}
\DeclareFontShape{T1}{jtm}{x}{sl}{<->\Jtms@@scale jtmro8tw}{}
\DeclareFontShape{T1}{jtm}{x}{sc}{<->\Jtms@@scale jtmrc8tw}{}
\DeclareFontShape{T1}{jtm}{bx}{n}{<->\Jtms@@scale jtmb8tv}{}
\DeclareFontShape{T1}{jtm}{bx}{it}{<->\Jtms@@scale jtmbi8tv}{}
\DeclareFontShape{T1}{jtm}{bx}{sl}{<->\Jtms@@scale jtmbo8tv}{}
\DeclareFontShape{T1}{jtm}{bx}{sc}{<->\Jtms@@scale jtmbc8tv}{}

\endinput
FDEOF

cd "$TMPDIR"

pandoc \
  "isi-laporan.md" \
  --template="template.latex" \
  --include-before-body="cover.md" \
  --include-after-body="daftar-pustaka.md" \
  --top-level-division=chapter \
  --pdf-engine=pdflatex \
  --no-highlight \
  -o "$REPORT" 2>&1

echo ""
echo "=== PDF BERHASIL DIBUAT ==="
echo "Lokasi: $REPORT"
