FROM rocker/r-ver:4.2.1

RUN apt-get update &&  apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libssl-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Without this, we are unable to pick up more recent packages
COPY docker/Rprofile.site /usr/local/lib/R/etc/Rprofile.site

COPY DESCRIPTION /tmp/DESCRIPTION

RUN install2.r --error remotes &&  \
        Rscript -e 'remotes::install_deps("/tmp")'

EXPOSE 8001

COPY . /src
RUN R CMD INSTALL --install-tests /src && \
        cp /src/docker/littlestar /usr/local/bin && \
        rm -rf /src

ENTRYPOINT ["/usr/local/bin/littlestar"]
