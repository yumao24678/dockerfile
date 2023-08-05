FROM yumao24678/cicd-tools:v1

RUN set -eux; \
            \
        apt-get update; \
        apt-get install -y curl git zip less; \
            \
        curl -SL -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"; \
        unzip awscliv2.zip; \
        ./aws/install; \
        rm -rf aws*; \
            \
        apt-get remove -y zip; \
        apt-get autoremove -y; \
        apt-get clean -y; \
        rm -rf /var/lib/apt/lists/*;

###
# 构建命令
#   docker build -t noi1031/cicd-tools:v1-aws ./
###
# 测试运行
#   docker run -it --rm \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     -v ~/.kube:/root/.kube \
#     -v ~/.aws:/root/.aws \
#     noi1031/cicd-tools:v1-aws /bin/bash
# 可以对 aws 命令进行测试 : aws sts get-caller-identity
###
