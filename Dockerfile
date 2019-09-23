# FROM swift:5.0
FROM norionomura/swift:swift-5.1-branch

# Copy over source
RUN mkdir -p /app
WORKDIR /app

COPY . /app

# Build source
CMD ["swift", "build"]
