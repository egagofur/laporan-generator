.PHONY: build clean lint-deps watch docx html crossref test docker-build init view

build:
	./build.sh

init:
	@git config core.hooksPath .githooks
	@echo "[OK] Git pre-commit hook berhasil diaktifkan!"

view:
	@if [ -f Laporan.pdf ]; then \
		command -v xdg-open >/dev/null 2>&1 && xdg-open Laporan.pdf || open Laporan.pdf || echo "Laporan.pdf ada di: $(shell pwd)/Laporan.pdf"; \
	else \
		echo "ERROR: Laporan.pdf belum dibuat. Jalankan 'make build' terlebih dahulu."; \
		exit 1; \
	fi

clean:
	rm -f Laporan.pdf Laporan.docx Laporan.html
	rm -rf tmp/

lint-deps:
	@echo "Checking dependencies..."
	@command -v pandoc >/dev/null 2>&1 || { echo "ERROR: pandoc not found"; exit 1; }
	@command -v typst >/dev/null 2>&1 || { echo "ERROR: typst not found"; exit 1; }
	@command -v convert >/dev/null 2>&1 || { echo "ERROR: ImageMagick (convert) not found"; exit 1; }
	@echo "All dependencies OK."

watch:
	@command -v inotifywait >/dev/null 2>&1 || { echo "ERROR: inotifywait not found. Install inotify-tools."; exit 1; }
	@echo "Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -r -e modify -e create -e delete . \
			--exclude '(Laporan\.pdf|tmp/|\.git/|\.pdf)' 2>/dev/null; \
		./build.sh; \
	done

docx:
	@if [ ! -d chapters ]; then \
		echo "ERROR: Direktori chapters/ tidak ditemukan."; \
		exit 1; \
	fi; \
	pandoc chapters/bab*.md \
		--metadata-file=metadata.yml \
		--citeproc --bibliography=references.bib \
		--csl=apa.csl \
		--metadata=reference-section-title="DAFTAR PUSTAKA" \
		--top-level-division=chapter \
		-o Laporan.docx 2>&1

html:
	@if [ ! -d chapters ]; then \
		echo "ERROR: Direktori chapters/ tidak ditemukan."; \
		exit 1; \
	fi; \
	pandoc chapters/bab*.md \
		--metadata-file=metadata.yml \
		--citeproc --bibliography=references.bib \
		--csl=apa.csl \
		--metadata=reference-section-title="DAFTAR PUSTAKA" \
		--top-level-division=chapter \
		--standalone --toc \
		-o Laporan.html 2>&1

crossref:
	@command -v pandoc-crossref >/dev/null 2>&1 || { \
		echo "ERROR: pandoc-crossref not found."; \
		echo "Install: https://github.com/lierdakil/pandoc-crossref"; \
		exit 1; \
	}
	CITEPROC_OPTS="--filter pandoc-crossref" ./build.sh

test:
	./test.sh

docker-build:
	docker compose build

docker-run:
	docker compose run --rm laporan-generator

docker-watch:
	docker compose run --rm watch
