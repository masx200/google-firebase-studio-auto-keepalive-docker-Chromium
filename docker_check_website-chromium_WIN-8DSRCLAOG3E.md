```yaml
networks:
  trim-default:
    external: false

    driver: bridge
    enable_ipv6: true
    ipam:
      config:
        - subnet: "172.31.125.0/24"
        - subnet: "fd12:5687:4425:5557::/64"
    name: "trim-default"
services:
  check_website-chromium:

    cap_drop:
      - "AUDIT_CONTROL"
      - "BLOCK_SUSPEND"
      - "DAC_READ_SEARCH"
      - "IPC_LOCK"
      - "IPC_OWNER"
      - "LEASE"
      - "LINUX_IMMUTABLE"
      - "MAC_ADMIN"
      - "MAC_OVERRIDE"
      - "NET_ADMIN"
      - "NET_BROADCAST"
      - "SYSLOG"
      - "SYS_ADMIN"
      - "SYS_BOOT"
      - "SYS_MODULE"
      - "SYS_NICE"
      - "SYS_PACCT"
      - "SYS_PTRACE"
      - "SYS_RAWIO"
      - "SYS_RESOURCE"
      - "SYS_TIME"
      - "SYS_TTY_CONFIG"
      - "WAKE_ALARM"

    command:
      - "while true; do bash /app/server/check_website.sh;sleep 600;done;"

    container_name: "check_website-chromium"

    entrypoint:
      - "bash"
      - "-c"

    environment:
      - "APP_NAME=dpanel"
      - "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      - "APP_ENV=lite"
      - "APP_VERSION=1.9.2"
      - "APP_FAMILY=ce"
      - "APP_SERVER_PORT=8080"
      - "DOCKER_HOST=unix:///var/run/docker.sock"
      - "STORAGE_LOCAL_PATH=/dpanel"
      - "DB_DATABASE=/dpanel/dpanel.db"
      - "TZ=Asia/Shanghai"
      - "DP_ACME_CONFIG_HOME=/dpanel/acme"
      - "DP_SYSTEM_STORAGE_LOCAL_PATH=/dpanel"
      - "DP_DB_DATABASE=/dpanel/dpanel.db"

    expose:
      - "443/tcp"
      - "80/tcp"
      - "8080/tcp"

    hostname: "63dad87a24e8"

    image: "docker.cnb.cool/masx200/docker_mirror/dpanel-curl:latest"

    ipc: "private"

    logging:
      driver: "json-file"
      options: {}

    networks:
      - "trim-default"

    privileged: true

    security_opt:
      - "label=disable"

    stdin_open: true

    tty: true

    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "9edd58dd93b88ddaea83e69e00eb5cca4182aafc699adf0aacd23684f6d62c26:/dpanel"
      - "E:\\docker-chromium-data-backup\\check_website.sh:/app/server/check_website.sh"

    working_dir: "/app/server"

version: "3.6"

volumes:
  9edd58dd93b88ddaea83e69e00eb5cca4182aafc699adf0aacd23684f6d62c26:
    external: true
```

```bash

#!/bin/bash

# 网站存活状态监测脚本

# 请求方式：GET | 重试次数：4次 | 连接超时：15秒 | 状态码200判定为存活


# ===================== 可自定义配置区（修改这里即可）=====================
MONITOR_URL="https://2053-firebase-node-express-web-ts-1767709386194.cluster-czg6tuqjtffiaszlkqfihyc3dq.cloudworkstations.dev/"
# 需要监测的目标网站地址
RETRY_TIMES=4
# 重试次数（固定4次，按需求）
CONNECT_TIMEOUT=15
# 连接超时时间（固定15秒，按需求）
REQUEST_METHOD="GET"
# 请求方法（固定GET，按需求）

# ========================================================================


# 定义日志颜色（提升可读性，控制台高亮显示）
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_RESET="\033[0m"


# 核心curl命令：获取HTTP状态码（无多余输出，精准返回数字状态码）

# curl默认就是GET请求，此处显式指定更严谨
HTTP_STATUS=$(curl -X ${REQUEST_METHOD} \
    --retry ${RETRY_TIMES} \
    --connect-timeout ${CONNECT_TIMEOUT} \
    -s -o /dev/null -w "%{http_code}" \
${MONITOR_URL})


# 获取当前时间戳（日志必备，精确到秒）
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")


# 状态判断逻辑 + 控制台日志打印
if [ "${HTTP_STATUS}" == "200" ]; then
    echo -e "[${CURRENT_TIME}] ${COLOR_GREEN}✅ 网站存活成功 ✅${COLOR_RESET}"
    echo -e "[${CURRENT_TIME}] 监测地址：${MONITOR_URL}"
    echo -e "[${CURRENT_TIME}] HTTP状态码：${COLOR_GREEN}${HTTP_STATUS}${COLOR_RESET}"
    echo -e "[${CURRENT_TIME}] 请求方式：${REQUEST_METHOD} | 重试次数：${RETRY_TIMES}次 | 连接超时：${CONNECT_TIMEOUT}秒\n"
else
    echo -e "[${CURRENT_TIME}] ${COLOR_RED}❌ 网站访问失败 ❌${COLOR_RESET}"
    echo -e "[${CURRENT_TIME}] 监测地址：${MONITOR_URL}"
    echo -e "[${CURRENT_TIME}] HTTP状态码：${COLOR_RED}${HTTP_STATUS}${COLOR_RESET}"
    echo -e "[${CURRENT_TIME}] 请求方式：${REQUEST_METHOD} | 重试次数：${RETRY_TIMES}次 | 连接超时：${CONNECT_TIMEOUT}秒\n"
    
    
    docker restart chromium
fi
```

