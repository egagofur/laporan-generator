# ==============================================================================
# Laporan Generator CLI Helper for Windows PowerShell (.\laporan.ps1)
# ==============================================================================
param (
    [Parameter(Position=0)]
    [string]$Command = "help",
    [Parameter(Position=1)]
    [string]$SubCommand = "",
    [Parameter(Position=2)]
    [string]$Arg1 = "",
    [Parameter(Position=3)]
    [string]$Arg2 = ""
)

$ErrorActionPreference = "Stop"

function Show-Banner {
    Write-Host "  ========================================================" -ForegroundColor Cyan
    Write-Host "                 LAPORAN GENERATOR CLI v2.3.0             " -ForegroundColor Cyan
    Write-Host "     Otomatisasi Dokumen Akademik (Typst + DOCX Engine)   " -ForegroundColor Cyan
    Write-Host "  ========================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Help {
    Show-Banner
    Write-Host "Penggunaan: .\laporan.ps1 <perintah>" -ForegroundColor White
    Write-Host ""
    Write-Host "Perintah yang Tersedia:" -ForegroundColor White
    Write-Host "  build        Kompilasi PDF dan DOCX sekaligus" -ForegroundColor Green
    Write-Host "  pdf          Kompilasi dokumen PDF (via Typst)" -ForegroundColor Green
    Write-Host "  docx         Kompilasi dokumen Microsoft Word (.docx)" -ForegroundColor Green
    Write-Host "  init         Wizard interaktif untuk konfigurasi awal metadata" -ForegroundColor Green
    Write-Host "  preset       Kelola preset format kampus (list/show/apply/validate)" -ForegroundColor Green
    Write-Host "  check        Audit dependensi sistem dan struktur proyek" -ForegroundColor Green
    Write-Host "  test         Jalankan suite pengujian otomatis" -ForegroundColor Green
    Write-Host "  view         Buka dokumen Laporan.pdf di PDF viewer" -ForegroundColor Green
    Write-Host "  clean        Bersihkan berkas output dan direktori sementara" -ForegroundColor Green
    Write-Host "  help         Tampilkan panduan bantuan ini" -ForegroundColor Green
    Write-Host ""
    Write-Host "Contoh:" -ForegroundColor Yellow
    Write-Host "  .\laporan.ps1 build"
    Write-Host "  .\laporan.ps1 preset list"
    Write-Host "  .\laporan.ps1 preset apply itb-ta"
}

function Cmd-Check {
    Show-Banner
    Write-Host "[1/2] Memeriksa Dependensi Sistem..." -ForegroundColor Blue

    $deps = @(
        @{ Name="Pandoc"; Cmd="pandoc"; Req=$true },
        @{ Name="Typst"; Cmd="typst"; Req=$true },
        @{ Name="ImageMagick"; Cmd="magick"; Req=$false },
        @{ Name="Python 3"; Cmd="python"; Req=$true },
        @{ Name="LibreOffice"; Cmd="soffice"; Req=$false }
    )

    $allOk = $true
    foreach ($d in $deps) {
        $found = Get-Command $d.Cmd -ErrorAction SilentlyContinue
        if ($found) {
            Write-Host "  [OK] $($d.Name) ($($d.Cmd)) terpasang: $($found.Source)" -ForegroundColor Green
        } else {
            if ($d.Req) {
                Write-Host "  [FAIL] $($d.Name) ($($d.Cmd)) TIDAK DITEMUKAN (Wajib)" -ForegroundColor Red
                $allOk = $false
            } else {
                Write-Host "  [INFO] $($d.Name) ($($d.Cmd)) tidak ditemukan (Opsional)" -ForegroundColor Yellow
            }
        }
    }

    Write-Host ""
    Write-Host "[2/2] Memeriksa Berkas Proyek..." -ForegroundColor Blue
    $files = @("metadata.yml", "cover.md", "template.typ", "reference.docx", "references.bib")
    foreach ($f in $files) {
        if (Test-Path $f) {
            Write-Host "  [OK] Berkas $f ditemukan" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Berkas $f tidak ditemukan" -ForegroundColor Red
            $allOk = $false
        }
    }

    $dirs = @("presets", "chapters")
    foreach ($d in $dirs) {
        if (Test-Path $d) {
            Write-Host "  [OK] Direktori $d ditemukan" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Direktori $d tidak ditemukan" -ForegroundColor Red
            $allOk = $false
        }
    }

    Write-Host ""
    if ($allOk) {
        Write-Host "Semua dependensi dan berkas proyek lengkap dan siap digunakan!" -ForegroundColor Green
    } else {
        Write-Host "Ada beberapa komponen yang kurang. Gunakan Docker jika ingin bebas instalasi lokal." -ForegroundColor Yellow
    }
}

function Cmd-Build-PDF {
    Show-Banner
    Write-Host "Membangun Dokumen PDF (Typst Engine)..." -ForegroundColor Blue

    $inputFiles = @("cover.md") + (Get-ChildItem -Path "chapters" -Filter "bab*.md" | Sort-Object Name | ForEach-Object { $_.FullName })
    $presetOpt = ""
    if (Test-Path "metadata.yml") {
        $content = Get-Content "metadata.yml" -Raw
        if ($content -match "(?:preset|margin_preset)\s*:\s*[`"']?([a-zA-Z0-9_-]+)[`"']?") {
            $presetName = $matches[1]
            if (Test-Path "presets\$presetName.yml") {
                $presetOpt = "--metadata-file=presets\$presetName.yml"
            }
        }
    }

    $pandocArgs = @(
        $inputFiles,
        "--template=template.typ",
        $presetOpt,
        "--metadata-file=metadata.yml",
        "--citeproc",
        "--bibliography=references.bib",
        "--csl=apa.csl",
        "--metadata=reference-section-title=DAFTAR PUSTAKA",
        "--top-level-division=chapter",
        "--pdf-engine=typst",
        "--no-highlight",
        "-o", "Laporan.pdf"
    ) | Where-Object { $_ -ne "" }

    & pandoc $pandocArgs
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=== PDF BERHASIL DIBUAT ===" -ForegroundColor Green
        Write-Host "Lokasi: $(Get-Location)\Laporan.pdf" -ForegroundColor Cyan
    } else {
        Write-Host "[ERROR] Kompilasi PDF gagal." -ForegroundColor Red
    }
}

function Cmd-Preset {
    param ($Sub, $P1, $P2)
    switch ($Sub) {
        "list" {
            Show-Banner
            Write-Host "Daftar Preset Format Kampus Tersedia:" -ForegroundColor Blue
            Write-Host ""
            Get-ChildItem -Path "presets" -Filter "*.yml" | ForEach-Object {
                $pid = $_.BaseName
                $name = (Select-String -Path $_.FullName -Pattern "^\s*name:\s*`"?(.*?)`"?\s*$" | Select-Object -First 1).Matches.Groups[1].Value
                $desc = (Select-String -Path $_.FullName -Pattern "^\s*description:\s*`"?(.*?)`"?\s*$" | Select-Object -First 1).Matches.Groups[1].Value
                Write-Host "  * $pid - $name" -ForegroundColor Green
                if ($desc) { Write-Host "    $desc" -ForegroundColor Gray }
                Write-Host ""
            }
        }
        "show" {
            if (-not $P1) { Write-Host "Error: Sebutkan ID preset. Contoh: .\laporan.ps1 preset show itb-ta" -ForegroundColor Red; return }
            $file = "presets\$P1.yml"
            if (Test-Path $file) {
                Show-Banner
                Write-Host "Konfigurasi Preset: $P1" -ForegroundColor Cyan
                Write-Host "--------------------------------------------------------"
                Get-Content $file
                Write-Host "--------------------------------------------------------"
            } else {
                Write-Host "Preset '$P1' tidak ditemukan." -ForegroundColor Red
            }
        }
        "apply" {
            if (-not $P1) { Write-Host "Error: Sebutkan ID preset. Contoh: .\laporan.ps1 preset apply itb-ta" -ForegroundColor Red; return }
            $file = "presets\$P1.yml"
            if (-not (Test-Path $file)) { Write-Host "Preset '$P1' tidak ditemukan." -ForegroundColor Red; return }
            if (-not (Test-Path "metadata.yml")) { Write-Host "metadata.yml tidak ditemukan." -ForegroundColor Red; return }

            $content = Get-Content "metadata.yml" -Raw
            if ($content -match "preset\s*:") {
                $content = $content -replace "preset\s*:.*", "preset: `"$P1`""
            } else {
                $content += "`npreset: `"$P1`""
            }
            Set-Content -Path "metadata.yml" -Value $content -NoNewline
            Write-Host "[OK] Preset '$P1' berhasil diterapkan ke metadata.yml!" -ForegroundColor Green
        }
        "validate" {
            & python scripts/validate-preset.py --all
        }
        default {
            Write-Host "Gunakan: .\laporan.ps1 preset [list | show <id> | apply <id> | validate]" -ForegroundColor Yellow
        }
    }
}

function Cmd-Clean {
    Remove-Item -Force -ErrorAction SilentlyContinue Laporan.pdf, Laporan.docx, Laporan.html
    Write-Host "[OK] Berkas output berhasil dibersihkan." -ForegroundColor Green
}

function Cmd-View {
    if (Test-Path "Laporan.pdf") {
        Start-Process "Laporan.pdf"
    } else {
        Write-Host "Laporan.pdf belum dibuat. Jalankan '.\laporan.ps1 build' terlebih dahulu." -ForegroundColor Red
    }
}

switch ($Command.ToLower()) {
    "build" { Cmd-Build-PDF }
    "pdf"   { Cmd-Build-PDF }
    "check" { Cmd-Check }
    "clean" { Cmd-Clean }
    "view"  { Cmd-View }
    "preset" { Cmd-Preset $SubCommand $Arg1 $Arg2 }
    "help"  { Show-Help }
    default { Show-Help }
}
