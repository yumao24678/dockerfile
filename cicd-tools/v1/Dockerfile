FROM docker.io/library/debian:11

# 中科大镜像源出问题时可以使用阿里云镜像源
COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
        apt-get install -y curl git; \
            \
        curl -SL -o "docker-20.10.17.tgz" "https://download.docker.com/linux/static/stable/x86_64/docker-20.10.17.tgz"; \
        tar -xvf docker*.tgz; \
        mv docker/docker /usr/local/bin/; \
        chmod +x /usr/local/bin/docker*; \
        rm -rf docker*; \
            \
        curl -SL -o "/usr/bin/kubectl" "https://dl.k8s.io/release/v1.26.3/bin/linux/amd64/kubectl"; \
        chmod +x /usr/bin/kubectl; \
            \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

###
# 构建命令
#   docker build -t noi1031/cicd-tools:v1 ./
###
# 测试运行
#   docker run -it --rm \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     -v ~/.kube:/root/.kube \
#     noi1031/cicd-tools:v1 /bin/bash
###
