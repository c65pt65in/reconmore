FROM ubuntu:22.04
RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y sudo \
  && apt-get install python3.10 -y \
  && apt-get install -y git \
  && export GIT_SSL_NO_VERIFY=1 \
  && git clone https://github.com/c65pt65in/reconmore.git \
  && cd reconmore \
  && ./install.sh	
