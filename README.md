# Dockup
Docker image to backup your Docker container volumes

Why the name? Docker + Backup = Dockup

# Usage

You have a container running with one or more volumes:

```
$ docker run -d --name mysql tutum/mysql
```

From executing a `$ docker inspect mysql` we see that this container has two volumes:

```
"Volumes": {
            "/etc/mysql": {},
            "/var/lib/mysql": {}
        }
```

Launch `dockup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--volumes-from mysql \
--name dockup borja/dockup
```

The contents of `env.txt` being:

```
EC2_ACCESS_KEY=<key_here>
EC2_SECRET_KEY=<secret_here>
BACKUP_NAME=mysql
PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
S3_BUCKET_NAME=DOCKER_VOL_BACKUPS
```

`dockup` will use your AWS credentials to create a new bucket with name as per the environment variable `S3_BUCKET_NAME`, or if not defined, using the default name `DOCKER_BACKUPS`. The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and uploaded to the S3 bucket. 

![](http://s.tutum.co.s3.amazonaws.com/support/images/dockup-readme.png)
