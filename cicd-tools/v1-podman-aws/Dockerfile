FROM yumao24678/cicd-tools:v1-podman

# 中科大镜像源出问题时可以使用阿里云镜像源
COPY sources.list-zkd /etc/apt/sources.list

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
#   podman build -t noi1031/cicd-tools:v1-podman-aws ./
###
# 测试运行
#   podman run -it --rm \
#     -v /var/run/podman/podman.sock:/var/run/podman/podman.sock \
#     -v ~/.kube:/root/.kube \
#     -v ~/.aws:/root/.aws \
#     noi1031/cicd-tools:v1-podman-aws /bin/bash
# 可以对 aws 命令进行测试 : aws sts get-caller-identity
###
