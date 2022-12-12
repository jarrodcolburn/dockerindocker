# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
# FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
FROM "mcr.microsoft.com/devcontainers/java:1-8-${VARIANT}"
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
RUN git config --global --add safe.directory /sdks/flutter

ARG ANDROID_SDK_VERSION="9123335"
ARG ANDROID_SDK_ZIP="commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip"
ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/${ANDROID_SDK_ZIP}"
RUN wget "${ANDROID_SDK_URL}" -P /tmp \
    && unzip "/tmp/${ANDROID_SDK_ZIP}" -d "/sdks/android"

ARG ANDROID_SYS_VERSION="33"
ARG ANDROID_BUILD_TOOLS_VERSION="33.0.1"
ARG ANDROID_PLATFORM_VERSION="33"

RUN sdkmanager --sdk_root="/sdks/android" --install \
    "system-images;android-${ANDROID_SYS_VERSION};google_apis_playstore;x86_64" \
    "platforms;android-${ANDROID_PLATFORM_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platform-tools" \
    "patcher;v4" \
    flutter config --android-sdk="/sdks/android" \
    yes | flutter doctor --android-licenses