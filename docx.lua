-- docx.lua: penomoran heading untuk output DOCX.
--  - Heading 1: "BAB I PENDAHULUAN" (huruf kapital, angka romawi)
--  - Heading 2: "1.1. Sub Bab" (titik di akhir nomor)
--  - Heading 3: "1.1.1 Sub Sub Bab"
--  - Heading dengan atribut {-} (unnumbered) dilewati tanpa penomoran.
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