FROM gcc:12

WORKDIR /app
COPY ./vuln_code.c .
COPY ./exploit.sh .
COPY ./verify_fix.sh .

# -fno-stack-protector: disable stack canary so the overflow is observable
# -w: suppress the gets() deprecation warning (it's intentionally there)
RUN gcc -fno-stack-protector -w -o vuln_code vuln_code.c
