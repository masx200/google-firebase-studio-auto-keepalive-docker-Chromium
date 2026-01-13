#!/bin/bash

# 网站存活状态监测脚本（支持网络异常自动重试）

# ===================== 可自定义配置区（修改这里即可）=====================
MONITOR_URL="https://********************************************************************************************************/"
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


# ===================== 核心监测逻辑（含自动重试）=====================

current_attempt=1

while [ $current_attempt -le $RETRY_TIMES ]; do
    
    # 获取当前时间戳（每次循环重新获取，保证日志时间准确）
    CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    
    # 核心curl命令：获取HTTP状态码
    # 注意：这里去掉了 --retry 参数，由外层的 while 循环控制重试逻辑
    HTTP_STATUS=$(curl -v -I --doh-url https://deno-dns-over-https-server.g18uibxgnb.de5.net/ --resolve deno-dns-over-https-server.g18uibxgnb.de5.net:443:188.114.97.3 -X ${REQUEST_METHOD} \
        --connect-timeout ${CONNECT_TIMEOUT} \
        -s -o /dev/null -w "%{http_code}" \
    ${MONITOR_URL})
    
    # 判断状态码
    if [ "${HTTP_STATUS}" == "200" ]; then
        # --- 成功 ---
        echo -e "--------------------------------------------------"
        echo -e "[${CURRENT_TIME}] ${COLOR_GREEN}✅ 网站存活成功 ✅${COLOR_RESET}"
        echo -e "[${CURRENT_TIME}] 监测地址：${MONITOR_URL}"
        echo -e "[${CURRENT_TIME}] HTTP状态码：${COLOR_GREEN}${HTTP_STATUS}${COLOR_RESET}"
        echo -e "[${CURRENT_TIME}] 尝试次数：第 ${current_attempt} 次即成功 | 连接超时：${CONNECT_TIMEOUT}秒"
        echo -e "--------------------------------------------------"
        
        # 成功则退出脚本，不执行后面的重启命令
        exit 0
    else
        # --- 失败 (包括 000 网络错误) ---
        echo -e "[${CURRENT_TIME}] ${COLOR_YELLOW}⚠️ 第 ${current_attempt} 次请求异常 (状态码: ${HTTP_STATUS})${COLOR_RESET}"
        
        # 如果还没达到最大重试次数，则继续重试
        if [ $current_attempt -lt $RETRY_TIMES ]; then
            echo -e "[${CURRENT_TIME}] 检测到网络问题或非200状态，等待 2 秒后自动重试...\n"
            sleep 2
        else
            echo -e "[${CURRENT_TIME}] ${COLOR_RED}❌ 已达到最大重试次数 (${RETRY_TIMES}次)，判定为彻底失败。 ❌${COLOR_RESET}\n"
            
            # ===================== 失败后的处理 ======================
            # 只有当上面的循环执行完毕且没有 exit 0 时，才会执行这里
            echo -e "[${CURRENT_TIME}] 正在重启 Docker 容器 'chromium' 以尝试恢复服务..."
            docker restart chromium
            exit 0
        fi
    fi
    
    # 计数器+1
    ((current_attempt++))
done

