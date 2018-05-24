FROM mooquant:0.2.6
MAINTAINER BoPo Wang <ibopo@126.com>

run pip3 install jupyter
# clean up
RUN apt-get autoremove -y; apt-get autoclean -y
RUN jupyter notebook --allow-root --generate-config
