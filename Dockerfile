FROM ubuntu:16.04

MAINTAINER Sébastien Allamand "sebastien@allamand.com"

LABEL forked_from dlsniper/docker-intellij

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ADD ./jdk.table.xml /home/developer/.IdeaIC2016.2.3/config/options/jdk.table.xml
ADD ./jdk.table.xml /home/developer/.jdk.table.xml


RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget \
	telnet curl net-tools && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \

    echo 'Creating user: developer wit UID $UID' && \
    mkdir -p /home/developer && \
    echo "developer:x:71519:100:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:100:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo && \

    mkdir -p /home/developer/.IdeaIC2016.2.3/config/options && \
    mkdir -p /home/developer/.IdeaIC2016.2.3/config/plugins && \


    echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-2016.2.3.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz && \

    echo 'Downloading Go 1.6.3' && \
    wget https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz -O /tmp/go.tar.gz -q && \
    echo 'Installing Go 1.6.3' && \
    sudo tar -zxf /tmp/go.tar.gz -C /usr/local/ && \
    rm -f /tmp/go.tar.gz && \

    echo 'Installing Go plugin' && \
    wget https://plugins.jetbrains.com/files/5047/27278/Go-0.12.1724.zip -O /home/developer/.IdeaIC2016.2.3/config/plugins/go.zip -q && \
    cd /home/developer/.IdeaIC2016.2.3/config/plugins/ && \
    unzip -q go.zip && \
    rm go.zip && \

    echo 'Installing Markdown plugin' && \
    wget https://plugins.jetbrains.com/files/7793/25156/markdown-2016.1.20160405.zip -O markdown.zip -q && \
    unzip -q markdown.zip && \
    rm markdown.zip

USER developer
ENV HOME /home/developer
ENV GOPATH /home/developer/go
ENV PATH $PATH:/home/developer/go/bin:/usr/local/go/bin
WORKDIR /home/developer/go

ADD ./entrypoint.sh /entrypoint.sh

RUN sudo chmod +x /entrypoint.sh && \
    sudo chown developer:developer -R /home/developer/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["intellij"]
