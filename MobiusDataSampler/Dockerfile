FROM alpine:latest

ARG version=11.0.17.8.1

ARG MV_URL=http://asg-mobius-view:80/mobius
ARG MV_REPOSITORY=Mobius

ARG MV_BASIC_AUTH_USER=admin
ARG MV_BASIC_AUTH_PASS=ASG_ENC(c1LpoXEIRe3h7b6TVoDfNP91rGK/9wGM)
                    #  ASG_ENC(IzrmGPXQqWV3/d6f1kq/Bw==) 

ARG MV_SECRET_SEC=5##)MbIPy?%_vFx*5Cm0G15MLc0rV/SK.cY

ARG MV_DEMO_DEFINITIONS=./_XML/CreateAllDataSamplerStructures.xml
ARG MV_DEMO_LOAD_DATA=./_XML/LoadAllDataSamplerContents.xml

# Please note that the THIRD-PARTY-LICENSE could be out of date if the base image has been updated recently. 
# The Corretto team will update this file but you may see a few days' delay.
RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-11=$version-r0 && \
    apk add --update bash && \
    rm -rf /var/cache/apk/*
    
ENV MV_URL=$MV_URL
ENV MV_REPOSITORY=$MV_REPOSITORY

ENV MV_BASIC_AUTH_USER=$MV_BASIC_AUTH_USER
ENV MV_BASIC_AUTH_PASS=$MV_BASIC_AUTH_PASS

ENV MV_SECRET_SEC=$MV_SECRET_SEC

ARG MV_DEMO_DEFINITIONS=$MV_DEMO_DEFINITIONS
ARG MV_DEMO_LOAD_DATA=$MV_DEMO_LOAD_DATA

ENV LANG C.UTF-8

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

# Create demo directory
RUN mkdir -p /home/demo

# Copy demo files
COPY ./DAFs /home/demo/DAFs

COPY ./_XML /home/demo/_XML
COPY ./BOOT-INF /home/demo/BOOT-INF
COPY ./asg /root/asg

COPY ./copy_demo.sh /home/demo
COPY ./delete_demo.sh /home/demo

RUN chmod +x /home/demo/*.sh

# Set default working dir
WORKDIR /home/demo

CMD [ "sh", "copy_demo.sh" ]
