FROM ubuntu:trusty
MAINTAINER Borja Burgos <borja@tutum.co>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install curl
RUN curl https://raw.githubusercontent.com/timkay/aws/master/aws -o aws
RUN chmod +x aws 
RUN perl aws --install

ADD backup.sh /backup.sh
RUN chmod 755 /*.sh

ENV S3_BUCKET_NAME DOCKER_BACKUPS
ENV EC2_ACCESS_KEY **DefineMe**
ENV EC2_SECRET_KEY **DefineMe**
ENV PATHS_TO_BACKUP /paths/to/backup
ENV BACKUP_NAME backup

CMD ["/backup.sh"]
