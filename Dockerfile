FROM beevelop/cordova:v9.0.0

LABEL mantainer="diego2k@gmail.com"

RUN \
apt-get update && \
apt-get install -y lib32stdc++6 lib32z1 unzip

# Download and untar Android SDK tools
RUN mkdir -p /usr/local/android-sdk-linux && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O /tmp/tools.zip && \
    unzip /tmp/tools.zip -d /usr/local/android-sdk-linux && \
    rm /tmp/tools.zip

# Set Environment
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK_ROOT /usr/local/android-sdk-linux
ENV PATH $PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Make license agreement
RUN mkdir $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 24333f8a63b6825ea9c5514f83c2829b004d1fee >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license

# Update and install using sdkmanager
RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" "build-tools;27.0.3" && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" "platforms;android-27" && \
    $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository"

ENV GRADLE_USER_HOME /src/gradle

VOLUME /src

WORKDIR /src

RUN cordova telemetry off
