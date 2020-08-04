FROM snykt/base

RUN apt-get update && apt-get install -y \
    gunicorn \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*
