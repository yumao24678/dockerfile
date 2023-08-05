# \[ cicd-tools -- 容器环境下常用 cicd 工具镜像 \] 

该镜像中包含 k8s、容器环境下 cicd 的常用工具套件 ( docker、podman、kubectl 等 )

:warning: `kubectl`、`docker|podman`、`git` 是所有 tag 镜像中的默认工具，基础容器工具 ( `docker|podman` ) 根据镜像 tag 区分，tag 中出现 podman 的其基础容器工具即为 podman，如果 tag 中没有出现 podman 的其基础容器工具为 docker 

Dockerfile 地址 : https://github.com/yumao24678/dockerfile/tree/main/cicd-tools

## 镜像说明 

镜像 tag 说明

- `*-podman*` : 表示该镜像中的基础容器工具为 podman，如果没有 podman 标志则默认为 docker
- `*-aws*` : 该镜像中包含基础工具及其 tag 包含工具的前提下包含 `aws-cli` 工具

镜像版本说明

- `v1` : 工具版本如下 `podman_v3.4.4`、`kubectl_v1.26.3`、`aws-cli_v2`、`docker_20.10.x`、`git_2.30.2` ( 仅列出可能存在的工具版本，具体工具是否存在于镜像根据 tag 决定 )

## 镜像使用示例 

**v1 镜像** 

```shell
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.kube:/root/.kube \
  yumao24678/cicd-tools:v1 /bin/bash
```

> 测试 docker
>
> ```shell
> root@77963c5fd7ab:/# docker version
> Client:
>  Version:           20.10.17
>  API version:       1.41
>  Go version:        go1.17.11
>  Git commit:        100c701
>  Built:             Mon Jun  6 22:56:42 2022
>  OS/Arch:           linux/amd64
>  Context:           default
>  Experimental:      true
> 
> Server: Docker Engine - Community
>  Engine:
>   Version:          23.0.6
>   API version:      1.42 (minimum version 1.12)
>   Go version:       go1.19.9
>   Git commit:       9dbdbd4
>   Built:            Fri May  5 21:18:28 2023
>   OS/Arch:          linux/amd64
>   Experimental:     false
>  containerd:
>   Version:          1.6.21
>   GitCommit:        3dce8eb055cbb6872793272b4f20ed16117344f8
>  runc:
>   Version:          1.1.7
>   GitCommit:        v1.1.7-0-g860f061
>  docker-init:
>   Version:          0.19.0
>   GitCommit:        de40ad0
> ```

**aws 镜像** 

```shell
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.kube:/root/.kube \
  -v ~/.aws:/root/.aws \
  yumao24678/cicd-tools:v1-aws /bin/bash
```

> 执行 aws 命令测试
>
> ```shell
> root@493f0978666a:/# aws sts get-caller-identity
> {
>  "UserId": "xxxxxxxx",
>  "Account": "xxxxxxxx",
>  "Arn": "arn:aws:iam::xxxxxxxx:user/xxxx"
> }
> ```

**podman 镜像** 

```shell
podman run -it --rm \
  -v /var/run/podman/podman.sock:/var/run/podman/podman.sock \
  -v ~/.kube:/root/.kube \
  yumao24678/cicd-tools:v1-podman /bin/bash
```

> 容器中的 podman 仅为客户端，必须挂载宿主机的 `podman.sock` 才能正常使用，宿主机上必须正确安装 podman 工具
>
> 安装文档 : [Podman Installation | Podman](https://podman.io/docs/installation#linux-distributions)

