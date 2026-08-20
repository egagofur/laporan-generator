-- docx.lua: penomoran heading dan cover page untuk output DOCX.
--  - Heading 1: "BAB I PENDAHULUAN" (huruf kapital, angka romawi)
--  - Heading 2: "1.1. Sub Bab" (titik di akhir nomor)
--  - Heading 3: "1.1.1 Sub Sub Bab"
--  - Heading dengan atribut {-} (unnumbered) dilewati tanpa penomoran.
--  - Cover page dibangun dari metadata (logo, judul, penulis, institusi)
--    meniru cover PDF, menggantikan title block bawaan pandoc.
--
-- Dipakai lewat `pandoc ... --lua-filter=docx.lua --reference-doc=reference.docx`.

local bab = 0
local sub = 0
local subsub = 0

local function is_unnumbered(el)
  for _, cls in ipairs(el.attr.classes or {}) do
    if cls == "unnumbered" then
      return true
    end
  end
  return false
end

local function roman(n)
  local map = {
    {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"},
    {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
    {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"},
  }
  local out = ""
  for _, pair in ipairs(map) do
    while n >= pair[1] do
      out = out .. pair[2]
      n = n - pair[1]
    end
  end
  return out
end

local function balance_title(text, max_lines)
  max_lines = max_lines or 4
  local words = {}
  for w in text:gmatch("%S+") do
    words[#words + 1] = w
  end
  local n = #words
  if n <= 1 or #text <= 55 then
    return { text }
  end
  local lens = {}
  for i, w in ipairs(words) do
    lens[i] = #w
  end
  local memo = {}
  local function solve(i, k)
    if k == 1 then
      local line = table.concat(words, " ", i, n)
      local mx = 0
      for j = i, n do
        mx = mx + lens[j]
      end
      mx = mx + (n - i)
      local cost = mx + (n == i and 100 or 0)
      return { { cost, { line }, mx } }
    end
    local key = i * 100 + k
    if memo[key] then
      return memo[key]
    end
    local res = {}
    local cur, cur_len = "", 0
    for j = i, n - k + 1 do
      local add = lens[j] + (j > i and 1 or 0)
      cur = cur == "" and words[j] or (cur .. " " .. words[j])
      cur_len = cur_len + add
      for _, cand in ipairs(solve(j + 1, k - 1)) do
        local lines = { cur }
        for _, l in ipairs(cand[2]) do
          lines[#lines + 1] = l
        end
        local mx = math.max(cur_len, cand[3])
        res[#res + 1] = { mx + cand[1] - cand[3], lines, mx }
      end
    end
    memo[key] = res
    return res
  end
  local best, best_cost = nil, math.huge
  for k = 2, math.min(max_lines, n) do
    for _, cand in ipairs(solve(1, k)) do
      if cand[1] < best_cost then
        best, best_cost = cand, cand[1]
      end
    end
  end
  return best[2]
end

local function para(content, style)
  return pandoc.Div(
    { pandoc.Para(content) },
    pandoc.Attr("", {}, { ["custom-style"] = style })
  )
end

local function pagebreak()
  return pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>')
end

local function meta_str(meta, key)
  local v = meta[key]
  if v == nil then
    return ""
  end
  return pandoc.utils.stringify(v)
end

function Header(el)
  if FORMAT ~= "docx" then
    return nil
  end
  if is_unnumbered(el) then
    return nil
  end
  local title = pandoc.utils.stringify(el.content)
  if el.level == 1 then
    bab = bab + 1
    sub = 0
    subsub = 0
    el.content = pandoc.Str("BAB " .. roman(bab) .. " " .. string.upper(title))
  elseif el.level == 2 then
    sub = sub + 1
    subsub = 0
    el.content = pandoc.Str(bab .. "." .. sub .. ". " .. title)
  elseif el.level == 3 then
    subsub = subsub + 1
    el.content = pandoc.Str(bab .. "." .. sub .. "." .. subsub .. " " .. title)
  end
  return el
end

function Pandoc(doc)
  if FORMAT ~= "docx" then
    return doc
  end
  local meta = doc.meta
  local title = meta_str(meta, "title")
  local subtitle = meta_str(meta, "subtitle")
  local course = meta_str(meta, "course")
  local lecturer = meta_str(meta, "lecturer")
  local faculty = meta_str(meta, "faculty")
  local institution = meta_str(meta, "institution")
  local year = meta_str(meta, "year")

  local blocks = pandoc.List{}
  blocks[#blocks + 1] = pagebreak()

  if title ~= "" then
    blocks[#blocks + 1] = pandoc.Div(
      { pandoc.Para({ pandoc.Image({}, "logo.jpg", "", pandoc.Attr("", {}, { width = "4cm" })) }) },
      pandoc.Attr("", {}, { ["custom-style"] = "CoverImage" })
    )
    local tlines = balance_title(string.upper(title))
    local content = {}
    for i, l in ipairs(tlines) do
      if i > 1 then
        content[#content + 1] = pandoc.LineBreak()
      end
      content[#content + 1] = pandoc.Str(l)
    end
    blocks[#blocks + 1] = para(content, "CoverTitle")
    if subtitle ~= "" then
      blocks[#blocks + 1] = para({ pandoc.Str(string.upper(subtitle)) }, "CoverSubtitle")
    end
    if course ~= "" then
      blocks[#blocks + 1] = para({ pandoc.Strong(pandoc.Str(course)) }, "CoverLine")
    end
    if lecturer ~= "" then
      blocks[#blocks + 1] = para(
        { pandoc.Str("Dosen Pengampu: "), pandoc.Strong(pandoc.Str(lecturer)) },
        "CoverLine"
      )
    end
  end

  local authors = meta["author"]
  if authors ~= nil then
    local author_list = {}
    if authors[1] ~= nil then
      for _, a in ipairs(authors) do
        author_list[#author_list + 1] = a
      end
    else
      author_list[#author_list + 1] = authors
    end
    if #author_list > 0 then
      blocks[#blocks + 1] = para({ pandoc.Str("Disusun oleh:") }, "CoverLine")
      for _, a in ipairs(author_list) do
        local name = pandoc.utils.stringify(a["name"] or a)
        local nim = pandoc.utils.stringify(a["nim"] or "")
        blocks[#blocks + 1] = para({ pandoc.Strong(pandoc.Str(name)) }, "CoverLine")
        if nim ~= "" then
          blocks[#blocks + 1] = para({ pandoc.Str(nim) }, "CoverLine")
        end
      end
    end
  end

  if faculty ~= "" or institution ~= "" or year ~= "" then
    if faculty ~= "" then
      blocks[#blocks + 1] = para({ pandoc.Str(string.upper(faculty)) }, "CoverInstitution")
    end
    if institution ~= "" then
      blocks[#blocks + 1] = para({ pandoc.Str(string.upper(institution)) }, "CoverInstitution")
    end
    if year ~= "" then
      blocks[#blocks + 1] = para({ pandoc.Str(string.upper(year)) }, "CoverInstitution")
    end
  end

  blocks[#blocks + 1] = pagebreak()

  meta.title = nil
  meta.subtitle = nil
  meta.date = nil
  meta.author = nil

  doc.blocks = blocks .. doc.blocks
  return doc
end