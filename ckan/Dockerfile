FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CKAN_INI=/etc/ckan/configuration.ini

# Instalar paquetes de dependencias
RUN apt-get -q -y update \
    && apt-get -q -y upgrade \
    && apt-get -q -y install \
        tzdata \
        wget \
        git-core \
        curl \
        build-essential \
        python2.7 \
        python2.7-dev \
        python-pip-whl \
        virtualenv \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        gnutls-bin \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario CKAN
RUN useradd -r -u 900 -m -c "ckan account" -d /usr/lib/ckan -s /bin/false ckan

# Crear directorios y entorno virtual
RUN mkdir -p /usr/lib/ckan/ /etc/ckan/ /var/lib/ckan && \
    virtualenv --python /usr/bin/python2.7 /usr/lib/ckan && \
    ln -s /usr/lib/ckan/bin/pip /usr/local/bin/ckan-pip &&\
    ln -s /usr/lib/ckan/bin/paster /usr/local/bin/ckan-paster

# Descargar CKAN
RUN ckan-pip install --upgrade pip
RUN ckan-pip install setuptools==36.1
RUN ckan-pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.8.12#egg=ckan[requirements]'
RUN ckan-pip install --upgrade --force-reinstall SQLAlchemy==1.3.5 vdm==0.15

#COPY patches/environment.py /usr/lib/ckan/src/ckan/config/environment.py
#COPY patches/cli.py /usr/lib/ckan/src/ckan/lib/cli.py
#COPY patches/get.py /usr/lib/ckan/src/ckan/logic/action/get.py
COPY patches/schema.py /usr/lib/ckan/src/ckan/logic/schema.py
COPY patches/meta.py /usr/lib/ckan/src/ckan/model/meta.py

RUN chown -R ckan:ckan /usr/lib/ckan /etc/ckan /var/lib/ckan


# Inicializar CKAN
RUN ln -s /usr/lib/ckan/src/ckan/who.ini /etc/ckan/who.ini
COPY configuration.ini /etc/ckan/configuration.ini

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ckan
EXPOSE 5000

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["ckan-paster","serve","/etc/ckan/configuration.ini"]
