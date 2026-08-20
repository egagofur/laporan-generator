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
    "BAB " + numbering("I", ns.at(0))
  } else if ns.len() == 2 {
    numbering("1.1.", ..ns)
  } else {
    numbering("1.1.1", ..ns)
  }
})

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  align(center)[
    #block(inset: (top: 0.5em, bottom: 1em))[
      #text(size: 14pt, weight: "bold")[
        #if it.numbering != none [
          #("BAB " + numbering("I", counter(heading).get().at(0)))
          #linebreak()
          #upper(it.body.text)
        ] else [
          #it.body
        ]
      ]
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

#show outline.entry.where(level: 1): set block(above: 0.9em, below: 0.2em)
#show outline.entry.where(level: 1): set text(weight: "bold")

#let balance-split(title, max-lines: 4) = {
  let words = title.split(" ")
  let n = words.len()
  if n <= 1 {
    return (title,)
  }
  let lens = words.map(w => w.len() + 1)
  let pref = (0,)
  for l in lens {
    pref.push(pref.last() + l)
  }
  let penalty = 100
  let dp = ((0, (), 0),) + range(1, n + 1).map(_ => (calc.inf, (), calc.inf))
  for i in range(1, n + 1) {
    for j in range(0, i) {
      let lines-before = dp.at(j).at(1).len()
      if lines-before >= max-lines {
        continue
      }
      let line-len = pref.at(i) - pref.at(j) - 1
      let prev = dp.at(j)
      let part = prev.at(1) + (words.slice(j, i).join(" "),)
      let mx = calc.max(prev.at(2), line-len)
      let single = part.map(l => if l.split(" ").len() <= 1 { 1 } else { 0 }).sum()
      let cost = mx + penalty * single
      if cost < dp.at(i).at(0) {
        dp.at(i) = (cost, part, mx)
      }
    }
  }
  dp.at(n).at(1)
}

#let title-lines = layout(size => {
  let t = upper("$title$".replace("\n", " ").replace("\r", " "))
  if measure(text(t, size: 14pt, weight: "bold")).width <= size.width {
    return t
  }
  let lines = balance-split(t)
  let out = ()
  for i in range(lines.len()) {
    if i > 0 {
      out.push(linebreak())
    }
    out.push(lines.at(i))
  }
  out.join()
})

#set table(stroke: 0.5pt + luma(140), inset: 4pt)
#show table.header: set text(weight: "bold")
#set figure.caption(position: bottom)
#show raw.where(block: true): set text(font: "DejaVu Sans Mono", size: 9pt)

#v(1cm)
#align(center)[
  #text(size: 14pt, weight: "bold")[#title-lines]
]
$if(subtitle)$
#v(0.3cm)
#align(center)[
  #text(size: 14pt, weight: "bold")[#upper("$subtitle$".replace("\n", " "))]
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
  #text(size: 14pt, weight: "bold")[#upper("$faculty$".replace("\n", " "))]
  #linebreak()
  #text(size: 14pt, weight: "bold")[#upper("$institution$".replace("\n", " "))]
  #linebreak()
  #text(size: 14pt, weight: "bold")[#upper("$year$".replace("\n", " "))]
]
#v(1cm)

#pagebreak()
#set page(numbering: "I")
#counter(page).update(1)

$body$