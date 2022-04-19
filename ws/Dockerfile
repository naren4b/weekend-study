FROM alpine:3.15.4
USER root

RUN export http_proxy="http://10.20.48.24:8080" && \
    export https_proxy="http://10.20.48.24:8080"

RUN apk update

# default
RUN apk add --no-cache util-linux pciutils usbutils coreutils binutils findutils grep openssl git netcat-openbsd ca-certificates jq bash bash-doc bash-completion udisks2 udisks2-doc curl 

# install java 
RUN apk fetch openjdk8 && \
    apk add openjdk8 maven 
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# install python3
COPY requirements.txt  .
RUN apk add py3-pip && \
    pip3 install -r requirements.txt

# minIo Client 
RUN curl -s -q https://dl.minio.io/client/mc/release/linux-amd64/mc -o /usr/bin/mc  && \
    chmod +x /usr/bin/mc   

# Kubectl 
RUN curl -s -q -LO \
    "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    mkdir /root/.kube
	
COPY k8s.sh /root/

# install docker 
RUN apk add --update docker openrc
RUN rc-update add docker boot
