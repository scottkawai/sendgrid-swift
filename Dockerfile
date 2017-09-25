FROM ubuntu:16.04

RUN apt-get update; apt-get install -y \
  clang \
  git \
  libicu-dev \
  wget \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev

# Install Swift
RUN mkdir -p /swift
WORKDIR /swift

ENV SWIFT_BRANCH swift-4.0-release
ENV SWIFT_VERSION swift-4.0-RELEASE
RUN wget https://swift.org/builds/${SWIFT_BRANCH}/ubuntu1604/${SWIFT_VERSION}/${SWIFT_VERSION}-ubuntu16.04.tar.gz
RUN tar xzvf ${SWIFT_VERSION}-ubuntu16.04.tar.gz -C /swift
ENV PATH /swift/${SWIFT_VERSION}-ubuntu16.04/usr/bin:$PATH

# Copy over source
RUN mkdir -p /app
WORKDIR /app

COPY . /app

# Build source
CMD ["swift", "build"]