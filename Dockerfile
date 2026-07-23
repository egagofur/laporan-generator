FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-lang-other \
    imagemagick \
    inotify-tools \
    make \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q "https://github.com/jgm/pandoc/releases/download/3.6.1/pandoc-3.6.1-1-amd64.deb" -O /tmp/pandoc.deb \
    && dpkg -i /tmp/pandoc.deb \
    && rm /tmp/pandoc.deb

RUN fmtutil-sys --all

WORKDIR /workspace

CMD ["./build.sh"]
