FROM ubuntu:18.04
MAINTAINER BoPo Wang <ibopo@126.com>

# COPY sources.list /etc/apt/sources.list
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y build-essential 
RUN apt-get install -y gfortran libopenblas-dev liblapack-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y apt-utils
RUN apt-get install -y wget

RUN apt-get install -y python3-setuptools python3-dev
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-scipy
RUN apt-get install -y python3-pandas
RUN apt-get install -y python3-patsy
RUN apt-get install -y python3-statsmodels
RUN apt-get install -y python3-ws4py
RUN apt-get install -y python3-tornado
RUN apt-get install -y python3-tweepy
RUN apt-get install -y python3-lxml
RUN apt-get install -y python3-bs4

# TA-Lib
RUN cd /tmp; \
	wget https://jaist.dl.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz; \
	tar -xzf ta-lib-0.4.0-src.tar.gz; \
	cd ta-lib; \
	./configure ; make; make install; \
	ln -s /usr/local/lib/libta_lib.so /usr/lib/libta_lib.so.0; \
	cd ..; rm ta-lib-0.4.0-src.tar.gz; \
	rm -rf ta-lib

RUN pip3 install ccxt
RUN pip3 install cython
RUN pip3 install TA-Lib
RUN pip3 install mootdx
RUN pip3 install tushare
RUN pip3 install mooquant==0.2.6

# clean up
RUN apt-get autoremove -y; apt-get autoclean -y

