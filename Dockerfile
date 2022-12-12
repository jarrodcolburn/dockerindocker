# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV FLUTTER_HOME="/sdks/flutter"
ENV FLUTTER_ROOT="/sdks/flutter"
ARG FLUTTER_VERSION="3.3.9"
ARG FLUTTER_TAR="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
ARG FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_TAR}"
RUN apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends xz-utils \
    && apt clean
RUN wget "${FLUTTER_DOWNLOAD_URL}" -P /tmp \
    && mkdir /sdks \
    &&  tar -xf /tmp/${FLUTTER_TAR} -C /sdks 
ENV PATH="${FLUTTER_HOME}/bin:$PATH"
