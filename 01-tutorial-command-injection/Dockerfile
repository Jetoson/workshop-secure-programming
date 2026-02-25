FROM python:3.11-slim

RUN apt-get update && apt-get install -y iputils-ping && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./vuln_code.py .
COPY ./exploit.sh .
COPY ./verify_fix.sh .
