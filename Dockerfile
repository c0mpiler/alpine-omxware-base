FROM python:3-alpine
MAINTAINER Harsha Krishnareddy <c0mpiler@outlook.com>

ARG REQUIRE="sudo build-base"
RUN apk update && apk upgrade \
      && apk add --no-cache ${REQUIRE}

RUN apk update && apk upgrade
RUN apk add --no-cache \
			build-base \
			gfortran \
			libffi-dev \
			ca-certificates \
			libgfortran \
			py3-setuptools \
			bash \
      bash-doc \
      bash-completion \
			bzip2-dev \
			gcc \
			gdbm-dev \
			libc-dev \
			linux-headers \
			ncurses-dev \
			openssl \
			openssl-dev \
			pax-utils \
			readline-dev \
			sqlite-dev \
			tcl-dev \
			tk \
			tk-dev \
			zlib-dev \
			git \
      lapack-dev \
      libstdc++ \
      gfortran \
      g++ \
      make \
      python3-dev \
      py3-qt5

  USER root
	RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

  RUN python3 -m pip --no-cache-dir install pip -U
  RUN python3 -m pip --no-cache-dir install pandas matplotlib
  # RUN python3 -m pip --no-cache-dir install numpy
  # RUN python3 -m pip --no-cache-dir install scipy
  # RUN python3 -m pip --no-cache-dir install seaborn
  RUN python3 -m pip install omxware

  RUN rm -rf /tmp/build
  RUN rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]
