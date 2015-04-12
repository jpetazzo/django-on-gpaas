FROM ubuntu:12.04
RUN apt-get update -q
RUN apt-get install -qy python3.2 python3-setuptools
RUN easy_install3 pip
RUN mkdir /src
WORKDIR /src
COPY requirements.txt /src/requirements.txt
RUN pip install -r requirements.txt
