# Use an official ubuntu as parent images
FROM ubuntu:latest

# Set hostname

# maintainer info
MAINTAINER massamba sow mass.sow@gmail.com

# For SSH access and port redirection
ENV ROOTPASSWORD "sample"

# Sanity check
RUN echo ============================\> SSH OK

# Update packages
RUN apt-get -y update

RUN echo ============================\> update OK

# Install system tools / libraries
RUN apt-get -y install ruby \
	ruby-dev \
	gem \
	ri \
	gcc \
	sass \
    software-properties-common \
    bzip2 \
    ssh \
    net-tools \
    curl \
    expect \
    git \
    nano \
    wget \
    build-essential \
    dialog \
    make \
    module-assistant \
    checkinstall \
    bridge-utils \
    virt-viewer

RUN echo ============================\> systools OK

# Install Node, npm
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

RUN echo ============================\> node install OK

# Make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list

RUN echo ============================\> node repo OK

# Update apt
RUN apt-get -y update

RUN echo ============================\> update OK

# Run sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo "root:$ROOTPASSWORD" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]        

RUN echo ============================\> sshd launch OK

# Make port 80 available to the world outside this container
EXPOSE 80

RUN echo ============================\> web port OK

# Expose Node.js app port
EXPOSE 8000

RUN echo ============================\> node port OK

# Set the working directory to ./public
WORKDIR ./public/

RUN echo ============================\> work dir creation OK

# Copy the current directory contents into the container at /app
ADD . /public/

RUN echo ============================\> work dir files OK

# Install app dependencies
# RUN npm install

RUN echo ============================\> npm dependencies OK

# Define environment variables

# Run when the container launches
# CMD ["pwd"]