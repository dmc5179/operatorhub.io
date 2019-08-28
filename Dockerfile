# Dockerfile for building customer operatorhub.io

FROM registry.redhat.io/ubi8/nodejs-10:latest

LABEL maintainer="Dan Clark <danclark@redhat.com>"

ARG OPERATORHUB_IO_REPO
ARG OPERATORHUB_IO_BRANCH
ARG COMMUNITY_REPO
ARG COMMUNITY_BRANCH
ARG OLM_REPO
ARG OLM_INSTALL_PATH

#ENV OPERATORHUB_IO_REPO=${OPERATORHUB_IO_REPO:-https://github.com/dmc5179/operatorhub.io.git}
ENV OPERATORHUB_IO_REPO=${OPERATORHUB_IO_REPO:-https://github.com/operator-framework/operatorhub.io.git}
ENV OPERATORHUB_IO_BRANCH=${OPERATORHUB_IO_BRANCH:-master}

ENV COMMUNITY_REPO=${COMMUNITY_REPO:-https://github.com/operator-framework/community-operators.git}
ENV COMMUNITY_BRANCH=${COMMUNITY_BRANCH:-master}

#ENV OLM_REPO=${OLM_REPO:-https://github.com/dmc5179/operator-lifecycle-manager}
#ENV OLM_INSTALL_PATH=${OLM_INSTALL_PATH:-0.10.1/scripts/install.sh}

WORKDIR /opt/app-root/src

RUN git clone -b "$OPERATORHUB_IO_BRANCH" "$OPERATORHUB_IO_REPO"

WORKDIR /opt/app-root/src/operatorhub.io

RUN if [ "x$OLM_REPO" != "x" ]; then sed -i "s|const olmRepo =.*|const olmRepo = '$OLM_REPO';|" 'frontend/src/components/InstallModal.js'; fi && \
    if [ "x$OLM_INSTALL_PATH" != "x" ]; then sed -i "s|const INSTALL_OLM_COMMAND =.*|const INSTALL_OLM_COMMAND = \`curl -sL \$\{olmRepo\}/${OLM_INSTALL_PATH} \| bash -s install.sh\`;|" 'frontend/src/components/InstallModal.js'; fi && \
    ./build.sh

EXPOSE 8080

CMD ["./run.sh"]

