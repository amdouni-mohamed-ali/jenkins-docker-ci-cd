FROM jenkins/jenkins

USER root

# Install pip
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py

# Install Docker
RUN apt-get update && \
   apt-get -y install apt-transport-https \
   ca-certificates \
   curl \
   gnupg2 \
   software-properties-common && \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
   add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
   apt-get update && \
   apt-get -y install docker-ce

# Install docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Add jenkins to the docker group (so you can run docker commands without sudo)
RUN usermod -aG docker jenkins

# switch to the jenkins user
USER jenkins

