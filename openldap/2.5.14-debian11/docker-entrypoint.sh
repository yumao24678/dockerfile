#!/bin/bash

set -eux

# 如果配置目录中没有配置则执行初始化步骤
if [ ! -e "/usr/local/etc/openldap/slapd.d/cn=config.ldif" ]; then
    # 导入基础配置
    slapadd -n 0 -l /usr/local/etc/openldap/slapd.ldif -F /usr/local/etc/openldap/slapd.d
    # 修改 config 访问认证模式
    sed -i -r \
        -e "/^\s*olcAccess/s/\<none\>/manage/g" \
        /usr/local/etc/openldap/slapd.d/cn\=config/olcDatabase\=\{0\}config.ldif
    # 临时启动 openldap
    /usr/local/libexec/slapd -F /usr/local/etc/openldap/slapd.d -h "ldap:/// ldapi:///"
    # 修改初始化文件中需要自定义的值
    sed -i -r \
        -e "s/==LDAP_BASE_DN==/${LDAP_BASE_DN}/g" \
        -e "s/==LDAP_BASE_ROOT_DN==/${LDAP_BASE_ROOT_DN}/g" \
        -e "s@==LDAP_BASE_ROOT_DN_PWD==@$(slappasswd -s ${LDAP_BASE_ROOT_DN_PWD})@g" \
        -e "s/==BASE_DN_DC==/$(echo "${LDAP_BASE_DN}" |sed -r -e "s/^dc=(.*),dc.*$/\1/g")/g" \
        /ldap_init/*.ldif
    # 应用修改基础域的配置
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /ldap_init/base_modify.ldif; \
    # 应用修改 config 访问授权配置
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /ldap_init/config-olcaccess_modify.ldif; \
    # 导入模块模板
    set +e
    for i in $(seq 5); do
        find /usr/local/etc/openldap/schema -type f -iname "*.ldif" |\
        while read -r line; do
            ldapadd -H ldapi:/// -f "$line" -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}";
        done
        sleep 0.5;
    done
    set -e
    # 应用基础域初始化配置
    ldapadd -H ldapi:/// -f /ldap_init/base_init.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"
    # 创建两个基础 ou (Group、People)
    ldapadd -H ldapi:/// -f /ldap_init/base_ou.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"
    # 开启 memberof 模块
    ldapadd -H ldapi:/// -f /ldap_init/memberof-module.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"
    # 创建 memberof 模块测试用户和用户组
    ldapadd -H ldapi:/// -f /ldap_init/memberof-test.ldif -D "${LDAP_BASE_ROOT_DN}" -w "${LDAP_BASE_ROOT_DN_PWD}"
    # 停止 ldap
    ps -ef
    ldap_pid="$(ps -ef |grep slap[d] |grep -vE "grep|docker-entrypoint.sh" |awk '{print $2}')"
    kill "${ldap_pid}"
    sleep 2
    if ps -ef |grep slap[d] |grep -vEq "grep|docker-entrypoint.sh"; then
        ldap_pid="$(ps -ef |grep slap[d] |grep -vE "grep|docker-entrypoint.sh" |awk '{print $2}')"
        kill -9 "${ldap_pid}";
    fi
fi

exec "$@"
