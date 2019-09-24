FROM swift:5.1

# Copy over source
RUN mkdir -p /app
WORKDIR /app

COPY . /app

# Build source
CMD ["swift", "build"]
