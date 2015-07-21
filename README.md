
# Dockup

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

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
AWS_ACCESS_KEY_ID=<key_here>
AWS_SECRET_ACCESS_KEY=<secret_here>
AWS_DEFAULT_REGION=us-east-1
BACKUP_NAME=mysql
PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
S3_BUCKET_NAME=docker-backups.example.com
```

`dockup` will use your AWS credentials to create a new bucket with name as per the environment variable `S3_BUCKET_NAME`, or if not defined, using the default name `docker-backups.example.com`. The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and uploaded to the S3 bucket.


> [Bucket naming guidelines](http://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html):
> "Bucket names must be unique and should be DNS compliant. Bucket names can contain lowercase letters, numbers, hyphens and periods. Bucket names can only start and end with a letter or number, and cannot contain a period next to a hyphen or another period."

These rules are enforced in some regions.


[AWS S3 Regions](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)

| Region name               | Region         |
| ------------------------- | -------------- |
| US Standard               | us-east-1      |
| US West (Oregon)          | us-west-2      |
| US West (N. California)   | us-west-1      |
| EU (Ireland)              | eu-west-1      |
| EU (Frankfurt)            | eu-central-1   |
| Asia Pacific (Singapore)  | ap-southeast-1 |
| Asia Pacific (Sydney)     | ap-southeast-2 |
| Asia Pacific (Tokyo)      | ap-northeast-1 |
| South America (Sao Paulo) | sa-east-1      |


To perform a restore launch the container with the RESTORE variable set to true


![](http://s.tutum.co.s3.amazonaws.com/support/images/dockup-readme.png)
