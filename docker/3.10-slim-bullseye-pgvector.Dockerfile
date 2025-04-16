FROM pgvector/pgvector:pg17

# Install Python 3.10 and supervisor
RUN --mount=type=bind,source=fs,target=/mnt apt-get update && apt-get install -y \
    wget curl build-essential \
    zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev \
    libsqlite3-dev libbz2-dev \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10 from source
RUN curl -O https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz && \
    tar -xf Python-3.10.13.tgz && \
    cd Python-3.10.13 && \
    ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make altinstall && \
    cd .. && rm -rf Python-3.10.13*

# Symlink python and pip
RUN ln -s /usr/local/bin/python3.10 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3.10 /usr/local/bin/pip

# Start supervisord
CMD ["/usr/bin/supervisord"]
