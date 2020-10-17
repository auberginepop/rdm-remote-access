# https://github.com/nginxinc/docker-nginx/blob/master/stable/buster/Dockerfile

FROM ubuntu:bionic
#ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y nginx fcgiwrap libcgi-application-perl jq awscli
# for debug
RUN apt install -y vim
RUN mkdir -vp /opt/encompass/rdm-remote-access \
    && rm -rfv /etc/nginx/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
COPY git-source/aws_commands /opt/encompass/rdm-remote-access/aws_commands
COPY git-source/nginx /etc/nginx
CMD /etc/init.d/fcgiwrap start \
    && nginx -g 'daemon off;'
