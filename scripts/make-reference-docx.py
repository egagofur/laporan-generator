#!/usr/bin/env python3
"""Generate reference.docx untuk pandoc --reference-doc.

Memodifikasi reference.docx bawaan pandoc agar gaya dokumen Word
mengikuti pedoman laporan akademik:

  - Ukuran halaman A4, margin atas 2cm / bawah 3cm / kiri-kanan 2.5cm
  - Normal (teks isi): Times New Roman 12pt, justify, spasi 1.5
  - Heading 1 (judul BAB): Times New Roman 14pt bold, rata tengah, hitam
  - Heading 2/3 (sub-bab): Times New Roman 12pt bold, rata kiri, hitam
  - Title/Subtitle/Author/Date: Times New Roman, rata tengah, hitam

Usage:
  python3 scripts/make-reference-docx.py [input.docx] [output.docx]

  input.docx  - hasil `pandoc --print-default-data-file reference.docx`
  output.docx - reference.docx hasil styling (default: reference.docx)
"""

import re
import sys
import zipfile

TNR = '<w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>'

STYLES = {
    "Normal": f"""<w:style w:type="paragraph" w:styleId="Normal">
  <w:name w:val="Normal"/>
  <w:qFormat/>
  <w:pPr>
    <w:spacing w:after="0" w:line="360" w:lineRule="auto"/>
    <w:jc w:val="both"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
  </w:rPr>
</w:style>""",
    "Heading1": f"""<w:style w:type="paragraph" w:styleId="Heading1">
  <w:name w:val="heading 1"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="BodyText"/>
  <w:link w:val="Heading1Char"/>
  <w:uiPriority w:val="9"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:spacing w:before="360" w:after="120"/>
    <w:jc w:val="center"/>
    <w:outlineLvl w:val="0"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="28"/>
    <w:szCs w:val="28"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Heading2": f"""<w:style w:type="paragraph" w:styleId="Heading2">
  <w:name w:val="heading 2"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="BodyText"/>
  <w:link w:val="Heading2Char"/>
  <w:uiPriority w:val="9"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:spacing w:before="160" w:after="80"/>
    <w:outlineLvl w:val="1"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Heading3": f"""<w:style w:type="paragraph" w:styleId="Heading3">
  <w:name w:val="heading 3"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="BodyText"/>
  <w:link w:val="Heading3Char"/>
  <w:uiPriority w:val="9"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:spacing w:before="160" w:after="80"/>
    <w:outlineLvl w:val="2"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Title": f"""<w:style w:type="paragraph" w:styleId="Title">
  <w:name w:val="Title"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="BodyText"/>
  <w:link w:val="TitleChar"/>
  <w:uiPriority w:val="10"/>
  <w:qFormat/>
  <w:pPr>
    <w:spacing w:after="80" w:line="240" w:lineRule="auto"/>
    <w:jc w:val="center"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="28"/>
    <w:szCs w:val="28"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Subtitle": f"""<w:style w:type="paragraph" w:styleId="Subtitle">
  <w:name w:val="Subtitle"/>
  <w:basedOn w:val="Title"/>
  <w:next w:val="BodyText"/>
  <w:link w:val="SubtitleChar"/>
  <w:uiPriority w:val="11"/>
  <w:qFormat/>
  <w:pPr>
    <w:spacing w:after="80" w:line="240" w:lineRule="auto"/>
    <w:jc w:val="center"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Author": f"""<w:style w:type="paragraph" w:styleId="Author">
  <w:name w:val="Author"/>
  <w:basedOn w:val="Title"/>
  <w:next w:val="BodyText"/>
  <w:uiPriority w:val="9"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:jc w:val="center"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
  </w:rPr>
</w:style>""",
    "Date": f"""<w:style w:type="paragraph" w:styleId="Date">
  <w:name w:val="Date"/>
  <w:basedOn w:val="Title"/>
  <w:next w:val="BodyText"/>
  <w:uiPriority w:val="9"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:jc w:val="center"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
  </w:rPr>
</w:style>""",
    "AbstractTitle": f"""<w:style w:type="paragraph" w:styleId="AbstractTitle">
  <w:name w:val="Abstract Title"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="Abstract"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:spacing w:before="300" w:after="0"/>
    <w:jc w:val="center"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
    <w:b/>
    <w:bCs/>
  </w:rPr>
</w:style>""",
    "Abstract": f"""<w:style w:type="paragraph" w:styleId="Abstract">
  <w:name w:val="Abstract"/>
  <w:basedOn w:val="Normal"/>
  <w:next w:val="BodyText"/>
  <w:qFormat/>
  <w:pPr>
    <w:keepNext/>
    <w:keepLines/>
    <w:spacing w:before="100" w:after="300"/>
    <w:jc w:val="both"/>
  </w:pPr>
  <w:rPr>
    {TNR}
    <w:color w:val="000000"/>
    <w:sz w:val="24"/>
    <w:szCs w:val="24"/>
  </w:rPr>
</w:style>""",
}

SECTPR = """<w:sectPr>
  <w:footnotePr>
    <w:numRestart w:val="eachSect"/>
  </w:footnotePr>
  <w:pgSz w:w="11906" w:h="16838"/>
  <w:pgMar w:top="1134" w:right="1417" w:bottom="1701" w:left="1417" w:header="720" w:footer="720" w:gutter="0"/>
</w:sectPr>"""


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else "/tmp/ref-default.docx"
    dst = sys.argv[2] if len(sys.argv) > 2 else "reference.docx"

    with zipfile.ZipFile(src, "r") as zin:
        names = zin.namelist()
        items = {n: zin.read(n) for n in names}

    styles = items["word/styles.xml"].decode("utf-8")
    for style_id, block in STYLES.items():
        pattern = re.compile(
            rf'<w:style\b[^>]*w:styleId="{style_id}"[^>]*>.*?</w:style>',
            re.S,
        )
        if not pattern.search(styles):
            print(f"[warn] style {style_id} tidak ditemukan, dilewati")
            continue
        styles = pattern.sub(block, styles)
    items["word/styles.xml"] = styles.encode("utf-8")

    doc = items["word/document.xml"].decode("utf-8")
    if re.search(r"<w:sectPr>.*?</w:sectPr>", doc, re.S):
        doc = re.sub(r"<w:sectPr>.*?</w:sectPr>", SECTPR, doc, flags=re.S)
    else:
        print("[warn] sectPr tidak ditemukan di document.xml")
    items["word/document.xml"] = doc.encode("utf-8")

    with zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED) as zout:
        for n in names:
            zout.writestr(n, items[n])

    print(f"[OK] reference.docx dibuat: {dst}")


if __name__ == "__main__":
    main()