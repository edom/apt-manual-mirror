FROM ubuntu:14.04
MAINTAINER software@spacetimecat.com

ADD files /
RUN apt-key add /etc/apt/key/postgres && apt-get update
