FROM docker.io/library/debian:11

# 中科大镜像源出问题时可以使用阿里云镜像源
COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
        apt-get -y install \
            wget; \
            \
        wget https://github.com/oliver006/redis_exporter/releases/download/v1.50.0/redis_exporter-v1.50.0.linux-amd64.tar.gz; \
        tar -xvf redis_exporter*.tar.gz; \
        rm -rf *.tar.gz; \
            \
        cd redis_exporter*; \
        install -v -o root -g root -m 0755 redis_exporter /usr/local/bin/; \
            \
        cd /; \
        rm -rf redis_exporter*; \
        apt-get -y remove \
            wget;\
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "redis_exporter" ]


###
# 构建命令
#   docker build --network=host -t noi1031/redis-exporter:1.50.0 ./
###
# 可控环境变量
#   参考 : https://github.com/oliver006/redis_exporter
###