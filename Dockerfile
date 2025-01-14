# this builds docker.io/openziti/zrok
FROM ubuntu:plucky

RUN apt-get update \
    && apt-get --yes install \
        jq \
        curl \
     && apt-get --yes autoremove \
     && apt-get clean autoclean \
     && rm -fr /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*


### Required OpenShift Labels 
LABEL name="openziti/zrok" \
      maintainer="support@zrok.io" \
      vendor="NetFoundry" \
      summary="Run the zrok CLI" \
      description="Run the zrok CLI" \
      org.opencontainers.image.description="Run the zrok CLI" \
      org.opencontainers.image.source="https://github.com/openziti/zrok"

USER root

### add licenses to this directory
RUN mkdir -p -m0755 /licenses
COPY ./LICENSE /licenses/apache.txt

RUN mkdir -p /usr/local/bin
COPY --chmod=0755 \
      ./nfpm/zrok-enable.bash \
      ./nfpm/zrok-share.bash \
      ./nfpm/zrok-install.bash \
      /usr/local/bin/

RUN bash /usr/local/bin/zrok-install.bash

RUN apt-get --yes autoremove curl  \
    && apt-get clean autoclean \
    && rm -fr /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
ENTRYPOINT [ "zrok" ]
