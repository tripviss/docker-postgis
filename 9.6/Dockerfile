FROM postgres:9.6
MAINTAINER Teoh Han Hui <teohhanhui@gmail.com>

# persistent / runtime deps
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		libgdal1h \
		libjson-c2 \
		libproj0 \
		libxml2 \
	&& rm -rf /var/lib/apt/lists/*

ENV POSTGIS_VERSION 2.3.2
ENV GEOS_VERSION 3.6.1

ENV POSTGIS_FILENAME postgis-${POSTGIS_VERSION}.tar.gz
ENV GEOS_FILENAME geos-${GEOS_VERSION}.tar.bz2

RUN set -xe \
	&& buildDeps=" \
		binutils \
		curl \
		g++ \
		gcc \
		libgdal-dev \
		libjson-c-dev \
		libproj-dev \
		libxml2-dev \
		make \
		postgresql-server-dev-$PG_MAJOR \
	" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		$buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	# build geos
	&& curl -fSL "http://download.osgeo.org/geos/$GEOS_FILENAME" -o "$GEOS_FILENAME" \
	&& mkdir -p /usr/local/src/geos \
	&& tar -xf "$GEOS_FILENAME" -C /usr/local/src/geos --strip-components=1 \
	&& rm "$GEOS_FILENAME" \
	&& cd /usr/local/src/geos \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /root \
	&& rm -rf /usr/local/src/geos \
	# build postgis
	&& curl -fSL "http://download.osgeo.org/postgis/source/$POSTGIS_FILENAME" -o "$POSTGIS_FILENAME" \
	&& mkdir -p /usr/local/src/postgis \
	&& tar -xf "$POSTGIS_FILENAME" -C /usr/local/src/postgis --strip-components=1 \
	&& rm "$POSTGIS_FILENAME" \
	&& cd /usr/local/src/postgis \
	&& ./configure \
		--with-geos=/usr/local/bin/geos-config \
	&& make \
	&& make install \
	&& cd /root \
	&& rm -rf /usr/local/src/postgis \
	&& ldconfig \
	&& apt-get purge -y --auto-remove $buildDeps

COPY initdb-postgis.sh /docker-entrypoint-initdb.d/20-postgis.sh
