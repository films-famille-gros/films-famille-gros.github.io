FROM debian:bullseye

RUN apt update && apt upgrade -y
RUN apt update && apt install -y python3 python3-pip
RUN pip install --upgrade pip
RUN pip install \
sphinx==5.3.0 \
ablog==0.10.29 \
sphinxcontrib-video==0.0.1.dev3 \
pydata-sphinx-theme==0.11.0

RUN apt update && apt install -y ffmpeg
RUN apt update && apt install -y mediainfo
RUN apt update && apt install -y git
RUN apt update && apt install -y locales-all
