FROM docker.io/library/debian:11

COPY sources.list-zkd /etc/apt/sources.list
COPY docker-entrypoint.sh /usr/local/bin
COPY openldap_init /ldap_init
# ADD openldap-2.5.14.tgz /

ENV LDAP_BASE_DN dc=noise,dc=com
ENV LDAP_BASE_ROOT_DN cn=admin,dc=noise,dc=com
ENV LDAP_BASE_ROOT_DN_PWD 123456

RUN set -eux; \
            \
        # 设置入口脚本运行权限
        chmod 0755 /usr/local/bin/docker-entrypoint.sh; \
            \
        # ls -l openldap_init; \
        # sleep 60; \
            \
        # 安装编译工具
        apt-get update; \
        apt-get -y install \
            wget curl vim tree procps gnupg ca-certificates \
            net-tools inetutils-ping telnet dnsutils; \
        apt-get -y install gcc g++ make automake libssl-dev libsasl2-dev libltdl-dev; \
            \
        # 安装 openldap 依赖组件
        apt-get -y install libltdl7 libsasl2-2 libssl1.1; \
        apt-get -y install man-db; \
            \
        # 下载并解压 openldap 源码包
        wget https://mirror-hk.koddos.net/OpenLDAP/openldap-release/openldap-2.5.14.tgz; \
        tar -xvf openldap*; \
        rm -rf *.tgz; \
        cd /openldap*; \
        pwd; \
        sleep 5; \
            \
        # 编译安装 openldap
        ./configure --with-cyrus-sasl --enable-modules --enable-overlays; \
        make depend && make -j "$(nproc)" && make install -j "$(nproc)"; \
        ldconfig -v; \
            \
        # 创建 openldap 运行需要的目录
        mkdir -p /usr/local/var/openldap-data; \
        chown -R root:root /usr/local/var/openldap-data; \
        chmod -R 700 /usr/local/var/openldap-data; \
        mkdir -p /usr/local/etc/openldap/slapd.d;\ 
            \
        # 初始化 openldap
        # slapadd -n 0 -l /usr/local/etc/openldap/slapd.ldif -F /usr/local/etc/openldap/slapd.d; \
        # sed -i -r -e "/^\s*olcAccess/s/\<none\>/manage/g" /usr/local/etc/openldap/slapd.d/cn\=config/olcDatabase\=\{0\}config.ldif; \
        # /usr/local/libexec/slapd -F /usr/local/etc/openldap/slapd.d -h "ldap:/// ldapi:///"; \
        #     \
        # # 修改初始化文件中需要自定义的值
        # sed -i -r \
        #     -e "s/==LDAP_BASE_DN==/${LDAP_BASE_DN}/g" \
        #     -e "s/==LDAP_BASE_ROOT_DN==/${LDAP_BASE_ROOT_DN}/g" \
        #     -e "s@==LDAP_BASE_ROOT_DN_PWD==@$(slappasswd -s ${LDAP_BASE_ROOT_DN_PWD})@g" \
        #     -e "s/==BASE_DN_DC==/$(echo "${LDAP_BASE_DN}" |sed -r -e "s/^dc=(.*),dc.*$/\1/g")/g" \
        #     /ldap_init/*.ldif; \
        #     \
        # # 应用修改基础域的配置
        # ldapmodify -Y EXTERNAL -H ldapi:/// -f /ldap_init/base_modify.ldif; \
        #     \
        # # 应用修改 config 访问授权配置
        # ldapmodify -Y EXTERNAL -H ldapi:/// -f /ldap_init/config-olcaccess_modify.ldif; \
        #     \
        # # 导入模块模板
        # set +e; \
        # for i in $(seq 5); do find /usr/local/etc/openldap/schema -type f -iname "*.ldif" |while read -r line; do ldapadd -H ldapi:/// -f "$line" -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"; done; sleep 0.5; done; \
        # set -e; \
        #     \
        # # 应用基础域初始化配置
        # ldapadd -H ldapi:/// -f /ldap_init/base_init.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"; \
        #     \
        # # 创建两个基础 ou (Group、People)
        # ldapadd -H ldapi:/// -f /ldap_init/base_ou.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"; \
        #     \
        # # 开启 memberof 模块
        # ldapadd -H ldapi:/// -f /ldap_init/memberof-module.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"; \
        # # 创建 memberof 模块测试用户和用户组
        # ldapadd -H ldapi:/// -f /ldap_init/memberof-test.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"; \
            \
        # 清理阶段
        apt-get -y remove \
            wget curl vim tree gnupg ca-certificates \
            net-tools inetutils-ping telnet dnsutils; \
        apt-get -y remove gcc g++ make automake libssl-dev libsasl2-dev libltdl-dev; \
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
        rm -rf /openldap*;

VOLUME [ "/usr/local/var/openldap-data", "/usr/local/etc/openldap/slapd.d" ]

EXPOSE 389 636

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "/usr/local/libexec/slapd", "-d", "256", "-F", "/usr/local/etc/openldap/slapd.d", "-h", "ldap:/// ldapi:///" ]


###
# 构建指令
#     docker build --network=host -f Dockerfile -t noi1031/openldap:2.5.14-debian11 ./
###
