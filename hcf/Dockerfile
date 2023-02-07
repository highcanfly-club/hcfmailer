FROM alpine:latest as builder
RUN apk --no-cache add ca-certificates tzdata git make musl-dev go nodejs npm yarn
RUN npm i -g yarn
RUN git clone -b hcf https://github.com/highcanfly-club/hcfmailer.git listmonk
RUN set -ex; \
    cd listmonk && \
    rm -f frontend/yarn.lock &&\
    cd frontend &&\
    yarn install &&\
    cd .. &&\
    make dist

#final image
FROM alpine:latest
COPY --from=builder /listmonk/listmonk /listmonk/
COPY --chown=root:root hcf/hcfmailer_entrypoint.sh /listmonk/hcfmailer_entrypoint.sh
RUN set -ex; \
    apk add --update --no-cache  ca-certificates tzdata\
    pwgen bash openrc openssh &&  \
    mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keygen -A \
    && echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 3022/g' /etc/ssh/sshd_config
WORKDIR /listmonk
ENTRYPOINT ["bash", "/listmonk/hcfmailer_entrypoint.sh"]
EXPOSE 9000 3022