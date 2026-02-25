FROM gcc:12

WORKDIR /app
COPY ./vuln_code.c .
COPY ./exploit.sh .
COPY ./verify_fix.sh .

RUN gcc -o vuln_code vuln_code.c
