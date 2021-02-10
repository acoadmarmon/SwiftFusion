FROM ubuntu
FROM python:3

WORKDIR /
COPY . .

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y clang libpython-dev libblocksruntime-dev libncurses5
RUN wget -q https://storage.googleapis.com/swift-tensorflow-artifacts/releases/v0.12/rc2/swift-tensorflow-RELEASE-0.12-ubuntu18.04.tar.gz
RUN tar xzf swift-tensorflow-RELEASE-0.12-ubuntu18.04.tar.gz
RUN export PATH=$(pwd)/usr/bin:"${PATH}"

RUN swift build
RUN pip install numpy
RUN pip install matplotlib
RUN pip install shapely

CMD swift run Scripts andrew01 --track-length $TRACK_LENGTH
