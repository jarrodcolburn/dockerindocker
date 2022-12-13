# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
# FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
FROM "mcr.microsoft.com/devcontainers/java:1-8-${VARIANT}"

# Install flutter requirements
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update \
    && apt -y install --no-install-recommends xz-utils \
    && apt clean

# Install flutter sdk
ARG FLUTTER_VERSION="3.3.9" \
    FLUTTER_TAR="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_TAR}" \
    FLUTTER_TMP="/tmp/${FLUTTER_TAR}"
ENV FLUTTER_HOME="/sdks/flutter" \
    FLUTTER_ROOT="/sdks/flutter" \
    PATH="$PATH:${FLUTTER_HOME}/bin"
RUN wget "${FLUTTER_DOWNLOAD_URL}" -P /tmp \
    && mkdir "/sdks" \
    && tar -xf "${FLUTTER_TMP}" -C "/sdks" \
    && rm "${FLUTTER_TMP}" \
    && git config --global --add safe.directory "${FLUTTER_HOME}" \
    && flutter doctor

# Install android sdk
ARG ANDROID_SDK_VERSION="9123335" \
    ANDROID_SYS_VERSION="33" \
    ANDROID_BUILD_TOOLS_VERSION="33.0.1" \
    ANDROID_PLATFORM_VERSION="33" \
    ANDROID_SDK_ZIP="commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/${ANDROID_SDK_ZIP}" \
    ANDROID_SDK_TMP="/tmp/${ANDROID_SDK_ZIP}"

ENV ANDROID_HOME="/sdks/android" \
    PATH="$PATH:${ANDROID_HOME}/cmdline-tools/bin"
RUN wget "${ANDROID_SDK_URL}" -P /tmp \
    && unzip "${ANDROID_SDK_TMP}" -d "${ANDROID_HOME}" \
    && rm "${ANDROID_SDK_TMP}" \
    && sdkmanager --sdk_root="${ANDROID_HOME}" --install \
    "system-images;android-${ANDROID_SYS_VERSION};google_apis_playstore;x86_64" \
    "platforms;android-${ANDROID_PLATFORM_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platform-tools" \
    "patcher;v4" \
    flutter config --android-sdk="${ANDROID_HOME}" \
    yes | flutter doctor --android-licenses
