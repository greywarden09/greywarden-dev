FROM jenkins/jenkins:lts

USER root

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update >/dev/null && apt-get install -qq --no-install-recommends apt-utils >/dev/null
RUN apt-get -qq install apt-transport-https \
         ca-certificates \
         curl \
         gnupg2 \
         software-properties-common >/dev/null
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update -qq >/dev/null && \
    apt-get install docker-ce -qq >/dev/null && \
    apt-get clean >/dev/null

RUN usermod -a -G docker jenkins

USER jenkins
