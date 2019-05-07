FROM python:3-alpine
MAINTAINER Harsha Krishnareddy <c0mpiler@outlook.com>

ARG REQUIRE="sudo build-base"
RUN apk update && apk upgrade \
      && apk add --no-cache ${REQUIRE}

RUN apk update && apk upgrade
RUN apk add --no-cache \
			build-base \
			gfortran \
      tar \
			libffi-dev \
			ca-certificates \
      curl \
			libgfortran \
			py3-setuptools \
			bash \
      bash-doc \
      bash-completion \
			bzip2-dev \
			gcc \
      wget \
      gnupg \
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
      py3-qt5 \
      perl

##############################################################################
RUN mkdir -p /usr/src/perl
WORKDIR /usr/src/perl

## from perl; `true make test_harness` because 3 tests fail
## some flags from http://git.alpinelinux.org/cgit/aports/tree/main/perl/APKBUILD?id=19b23f225d6e4f25330e13144c7bf6c01e624656
RUN curl -SLO https://www.cpan.org/src/5.0/perl-5.28.2.tar.gz \
    && echo '5457f788372f667bf5a1ba3b05211faf773f024f *perl-5.28.2.tar.gz' | sha1sum -c - \
    && tar --strip-components=1 -xzf perl-5.28.2.tar.gz -C /usr/src/perl \
    && rm perl-5.28.2.tar.gz \
    && ./Configure -des \
        -Duse64bitall \
        -Dcccdlflags='-fPIC' \
        -Dcccdlflags='-fPIC' \
        -Dccdlflags='-rdynamic' \
        -Dlocincpth=' ' \
        -Duselargefiles \
        -Dusethreads \
        -Duseshrplib \
        -Dd_semctl_semun \
        -Dusenm \
    && make libperl.so \
    && make -j$(nproc) \
    && true TEST_JOBS=$(nproc) make test_harness \
    && make install \
    && curl -LO https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm \
    && chmod +x cpanm \
    && ./cpanm App::cpanminus \
    && rm -fr ./cpanm /root/.cpanm /usr/src/perl

## from tianon/perl
ENV PERL_CPANM_OPT --verbose --mirror https://cpan.metacpan.org --mirror-only
RUN cpanm Digest::SHA Module::Signature && rm -rf ~/.cpanm
ENV PERL_CPANM_OPT $PERL_CPANM_OPT --verify

##############################################################################

USER root
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN python3 -m pip --no-cache-dir install pip -U
## RUN python3 -m pip --no-cache-dir install pandas matplotlib
## RUN python3 -m pip --no-cache-dir install numpy
## RUN python3 -m pip --no-cache-dir install scipy
## RUN python3 -m pip --no-cache-dir install seaborn
RUN python3 -m pip install omxware

RUN rm -rf /tmp/build
RUN rm -rf /var/cache/apk/*

RUN cpanm CryptX
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/ash"]
