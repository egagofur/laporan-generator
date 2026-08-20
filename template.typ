#set document(
  title: "$title$",
  author: ($for(author)$"$author.name$"$sep$,$endfor$),
)

#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
  numbering: none,
)

#set text(font: "Libertinus Serif", size: 12pt)
#set par(justify: true, leading: 1.5em)

#set heading(numbering: (..ns) => {
  if ns.len() == 1 {
    "BAB " + numbering("I", ns.at(0)) + linebreak()
  } else if ns.len() == 2 {
    numbering("1.1", ..ns)
  } else {
    numbering("1.1.1", ..ns)
  }
})

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  align(center)[
    #block(inset: (top: 0.5em, bottom: 1em))[
      #text(size: 14pt, weight: "bold")[#it]
    ]
  ]
}

#show heading.where(level: 2): it => {
  block(inset: (top: 0.6em, bottom: 0.3em))[
    #text(size: 12pt, weight: "bold")[#it]
  ]
}

#show heading.where(level: 3): it => {
  block(inset: (top: 0.4em, bottom: 0.2em))[
    #text(size: 12pt, weight: "bold")[#it]
  ]
}

#set table(stroke: 0.5pt + luma(140), inset: 4pt)
#show table.header: set text(weight: "bold")
#set figure.caption(position: bottom)
#show raw.where(block: true): set text(font: "DejaVu Sans Mono", size: 9pt)

#v(1cm)
#align(center)[
  #text(size: 14pt, weight: "bold")[$title$]
]
$if(subtitle)$
#v(0.3cm)
#align(center)[
  #text(size: 14pt, weight: "bold")[$subtitle$]
]
$endif$
$if(course)$
#v(0.8cm)
#align(center)[
  #text(size: 12pt, weight: "bold")[$course$]
]
$endif$
$if(lecturer)$
#v(0.4cm)
#align(center)[
  #text(size: 11pt)[Dosen Pengampu:]
  #text(size: 12pt, weight: "bold")[$lecturer$]
]
$endif$

#v(1fr)
#align(center)[
  #image("logo.jpg", width: 4cm)
]
#v(1fr)

#align(center)[
  #text(size: 12pt)[Disusun oleh:]
]
$for(author)$
#v(0.3cm)
#align(center)[
  #text(size: 12pt, weight: "bold")[$author.name$] \
  #text(size: 11pt)[$author.nim$]
]
$endfor$

#v(1fr)
#align(center)[
  #text(size: 12pt, weight: "bold")[$faculty$]
  #linebreak()
  #text(size: 12pt, weight: "bold")[$institution$]
  #linebreak()
  #text(size: 12pt, weight: "bold")[$year$]
]
#v(1cm)

#pagebreak()
#set page(numbering: "I")
#counter(page).update(1)

$body$