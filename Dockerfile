FROM ubi9/openjdk-11-runtime

# Setup useful environment variables
ENV JREBEL_INSTALL  /jrebel
ENV JREBEL_VERSION  3.6.4
ENV JREBEL_DOWNLOAD_URL https://dl.zeroturnaround.com/license-server/releases/license-server-${JREBEL_VERSION}.zip
LABEL Description="jRebel license server" Version="${JREBEL_VERSION}"

USER root

RUN \
  microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y unzip && \
  microdnf clean all && \
  mkdir -p "${JREBEL_INSTALL}" && \
  cd "${JREBEL_INSTALL}" && \
  curl -o /tmp/jrebel.zip "${JREBEL_DOWNLOAD_URL}" && \
  unzip -d "${JREBEL_INSTALL}" /tmp/jrebel.zip && \
  rm /tmp/jrebel.zip && \
  chown -R 1001:0 "${JREBEL_INSTALL}" && \
  chmod -R 777 "${JREBEL_INSTALL}"

USER 1001

CMD [ "bash", "-c", "${JREBEL_INSTALL}/license-server/bin/license-server.sh run" ]
