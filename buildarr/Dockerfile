FROM python:3.11-alpine

# Ensure stdout/stderr writes straight through to the Docker logs without buffering.
ENV PYTHONUNBUFFERED=1

# Buildarr user UID/GID. User is created at runtime.
ENV PUID=1000
ENV PGID=1000

# Mark the Buildarr configuration folder as an external volume mount point.
VOLUME ["/config"]

# Copy the container bootstrap script into the image.
COPY bootstrap.sh /bootstrap.sh
COPY requirements.txt /requirements.txt

# Run the image setup script.
RUN apk add su-exec tzdata git && \
  chmod +x /bootstrap.sh && \
  python -m pip install --no-cache-dir -r /requirements.txt

# Set the Buildarr configuration folder as the default Docker container working folder.
WORKDIR /config

# Setup the Docker image entry point to bootstrap packages and start Buildarr daemon.
ENTRYPOINT ["/bootstrap.sh"]
CMD ["daemon"]
