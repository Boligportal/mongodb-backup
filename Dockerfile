# Forked from https://github.com/tutumcloud/mongodb-backup and https://bitbucket.org/taccaci/mongodb-sync
FROM ubuntu:trusty

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org-shell mongodb-org-tools python-pip && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections && \
		pip install awscli && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/* && \
		rm -rf /tmp/* && \
    mkdir /backup

ENV CRON_TIME="0 0 * * *"
ENV S3_PATH=mongodb
ENV AWS_DEFAULT_REGION=eu-west-1

COPY run.sh backup.sh restore.sh /

RUN chmod +x /run.sh && chmod +x /backup.sh && chmod +x /restore.sh
VOLUME ["/backup"]
CMD ["/run.sh"]
