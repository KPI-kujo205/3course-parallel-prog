FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    gnat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# ✅ Enable Ada 202x features using -gnatX
RUN gnatmake -gnatX lab5.adb

CMD ["./lab5"]
