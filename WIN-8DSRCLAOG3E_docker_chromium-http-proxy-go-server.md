帐号

```plain
m8dkatnya1zst1n
```

密码

```plain
m8dkatnya1zst1n
```

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
  chromium:
    privileged: true
    depends_on:
      - "chromium-http-proxy-go-server"
    user: "0:0"

    container_name: "chromium"

    entrypoint:
      - "/init"

    environment:
      - "CUSTOM_USER=m8dkatnya1zst1n"
      - "PASSWORD=m8dkatnya1zst1n"
      - "PUID=0"
      - "PGID=0"
      - "TZ=Etc/UTC"
      - "SUBFOLDER=/chromium/"
      - "LC_ALL=zh_CN.UTF-8"
      - "CHROME_CLI=--proxy-server=http://chromium-http-proxy-go-server:57788 https://idx.google.com/node-express-web-ts-31822042"
      - "PATH=/lsiopy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      - "HOME=/config"
      - "LANGUAGE=en_US.UTF-8"
      - "LANG=en_US.UTF-8"
      - "TERM=xterm"
      - "S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0"
      - "S6_VERBOSITY=1"
      - "S6_STAGE2_HOOK=/docker-mods"
      - "VIRTUAL_ENV=/lsiopy"
      - "DISPLAY=:1"
      - "PERL5LIB=/usr/local/bin"
      - "OMP_WAIT_POLICY=PASSIVE"
      - "GOMP_SPINCOUNT=0"
      - "START_DOCKER=true"
      - "PULSE_RUNTIME_PATH=/defaults"
      - "NVIDIA_DRIVER_CAPABILITIES=all"
      - "LSIO_FIRST_PARTY=true"
      - "TITLE=Chromium"

    hostname: "d9f2f11c9b2f"

    image: docker.cnb.cool/masx200/docker_mirror/linuxserver-chromium:latest-linux-amd64
    #"registry.cn-guangzhou.aliyuncs.com/fnapp/trim-chromium:latest"

    ipc: "private"

    labels:
      build_version: "Linuxserver.io version:- 85edbc44-ls80 Build-date:- 2024-07-31T09:27:44+00:00"
      com.docker.compose.config-hash: "0a690e0dd41f33f6a5175faba916c3c45043dc07fd5f34e0f445b3faa6d4ce1a"
      com.docker.compose.container-number: "1"
      com.docker.compose.depends_on: ""
      com.docker.compose.image: "sha256:d01bc5fffc8d5f17d76bffeb41a7fe4c98016daaed35f7eee5a8d18203173d20"
      com.docker.compose.oneoff: "False"
      com.docker.compose.project: "chromium"
      com.docker.compose.project.config_files: "/vol2/@appcenter/docker-chromium/app/docker-compose.yaml"
      com.docker.compose.project.working_dir: "/vol2/@appcenter/docker-chromium/app"
      com.docker.compose.service: "chromium"
      com.docker.compose.version: "2.40.3"
      com.kasmweb.image: "true"
      maintainer: "thelamer"
      org.opencontainers.image.authors: "linuxserver.io"
      org.opencontainers.image.created: "2024-07-31T09:27:44+00:00"
      org.opencontainers.image.description:
        "[Chromium](https://www.chromium.org/chromium-projects/) is    an open-source browser project that aims to build a safer, faster, and more stable way for all    users to experience the web."
      org.opencontainers.image.documentation: "https://docs.linuxserver.io/images/docker-chromium"
      org.opencontainers.image.licenses: "GPL-3.0-only"
      org.opencontainers.image.ref.name: "d3bfa2295656410097130f05186949c34a54ec2c"
      org.opencontainers.image.revision: "d3bfa2295656410097130f05186949c34a54ec2c"
      org.opencontainers.image.source: "https://github.com/linuxserver/docker-chromium"
      org.opencontainers.image.title: "Chromium"
      org.opencontainers.image.url: "https://github.com/linuxserver/docker-chromium/packages"
      org.opencontainers.image.vendor: "linuxserver.io"
      org.opencontainers.image.version: "85edbc44-ls80"

    logging:
      driver: "json-file"
      options:
        max-file: "5"
        max-size: "100m"
    networks:
      trim-default:
        ipv4_address: 172.31.125.20
        ipv6_address: fd12:5687:4425:5557::20

    extra_hosts:
      - "chromium-http-proxy-go-server:172.31.125.10"
      - "chromium-http-proxy-go-server:fd12:5687:4425:5557::10"
    # networks:
    #   #container:http-proxy-go-server
    #   - "trim-default"

    ports:
      - "23000:3000/tcp"
      - "23001:3001/tcp"

    restart: "always"

    security_opt:
      - "seccomp:unconfined"

    volumes:
      - "e:/docker-chromium-data-backup/config:/config"
      - "e:/docker-chromium-data-backup/wrapped-chromium:/usr/bin/wrapped-chromium"

    working_dir: "/"

  chromium-http-proxy-go-server:
    domainname: chromium-http-proxy-go-server
    privileged: true
    networks:
      trim-default:
        ipv4_address: 172.31.125.10
        ipv6_address: fd12:5687:4425:5557::10
    
    extra_hosts:
      - "chromium:172.31.125.20"
      - "chromium:fd12:5687:4425:5557::20"
      
    # networks:
      # - "trim-default"
    ports:
      - "57788:57788/tcp"

    command:
      - "sh"
      - "-c"
      - "-x"
      - "'./main'    '-dohurl' 'https://doh-server.masx200.ddns-ip.net' '-dohip' '104.21.14.41' '--dohalpn=h2'    '-port' '57788'  '-dohalpn=h3'    '-dohurl' 'https://doh-server.masx200.ddns-ip.net' '--dohip=104.21.9.230'   '-dohurl' 'https://deno-dns-over-https-server.g18uibxgnb.de5.net/' '-dohip' '104.21.9.230' '--dohalpn=h2'    '-dohurl' 'https://deno-dns-over-https-server.g18uibxgnb.de5.net/' '-dohip' '104.21.9.230' '--dohalpn=h2'    '-dohurl' 'https://deno-dns-over-https-server.g18uibxgnb.de5.net/' '-dohip' '104.21.9.230' '--dohalpn=h2'    '-dohurl' 'https://deno-dns-over-https-server.g18uibxgnb.de5.net/' '-dohip' '104.21.9.230' '--dohalpn=h3'    '-dohurl' 'https://deno-dns-over-https-server.g18uibxgnb.de5.net/' '-dohip' '104.21.9.230' '--dohalpn=h3'  -cache-file ./dns_cache.json -cache-aof-file dns_cache.aof   '-upstream-address' 'http://192.168.31.245:58877' '-upstream-type' 'http'   -upstream-username=admin -upstream-password=933cgaxekq5vnz6shebzc --upstream-resolve-ips=true"

    container_name: "chromium-http-proxy-go-server"

    environment:
      - "GOLANG_VERSION=1.24.4"
      - "GOTOOLCHAIN=local"
      - "GOPATH=/go"
      - "TZ=Asia/Shanghai"
      - "PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

    image: docker.gh-proxy.com/ghcr.io/masx200/http-proxy-go-server:20260109031050-main-9a8ebda

    ipc: "private"

    logging:
      driver: "json-file"
      options:
        max-file: "5"
        max-size: "100m"

    restart: "always"

    stdin_open: true

    tty: true

    working_dir: "/app"
    volumes:
      - "e:/docker/http-proxy-go-server/dns_cache.aof:/app/dns_cache.aof"

      - "e:/docker/http-proxy-go-server/dns_cache.json:/app/dns_cache.json"

version: "3.6"

```

```plain
https://m8dkatnya1zst1n:m8dkatnya1zst1n@127.0.0.1:23001/chromium/
```

```bash
/usr/lib/chromium/chromium --show-component-extension-options --enable-gpu-rasterization --no-default-browser-check --disable-pings --media-router=0 --disable-dev-shm-usage --enable-remote-extensions --load-extension --no-first-run --no-sandbox --password-store=basic "--simulate-outdated-no-au=Tue, 31 Dec 2099 23:59:59 GMT" --start-maximized --test-type --user-data-dir $CHROME_CLI
```

```plain
/usr/bin/wrapped-chromium
```

```bash
#!/bin/bash

# 检查 /usr/lib/chromium/chromium 进程是否已经存在
if pgrep -f "/usr/lib/chromium/chromium" > /dev/null; then
    echo "检测到 Chromium 正在运行，退出当前程序。"
    exit 1
fi

bash -c "while true ; do /usr/lib/chromium/chromium --show-component-extension-options --enable-gpu-rasterization --no-default-browser-check --disable-pings --media-router=0 --disable-dev-shm-usage --enable-remote-extensions --load-extension --no-first-run --no-sandbox --password-store=basic \"--simulate-outdated-no-au=Tue, 31 Dec 2099 23:59:59 GMT\" --start-maximized --test-type --user-data-dir $CHROME_CLI ; sleep 5; done;"
```

```bash
nano /vol2/1000/chromium/var/apps/docker-chromium/shares/chromium/wrapped-chromium

chmod 777 /vol2/1000/chromium/var/apps/docker-chromium/shares/chromium/wrapped-chromium

```





Auto Refresh Plus

<font style="color:rgb(68, 71, 70);">hgeljhfekpckiiplhkigfehkdpldcggm</font>

### <font style="color:rgb(7, 29, 43);">设置备份</font>
```json
{
  "local": {
    "InstallDate": 1767841307884,
    "clientId": "d85320a9-69a7-418a-82b8-6e37bdc52b6f",
    "domain_config": {
      "https://idx.google.com/node-express-web-ts-31822042": {
        "autoclick": "",
        "checkme": "",
        "countdownTime": 600000,
        "countdownType": "time",
        "custom_interval": 12,
        "hardRefresh": false,
        "inNewTab": false,
        "interactions": false,
        "openLink": false,
        "pmOptions": {
          "emailEnabled": false,
          "refresh": "1",
          "restart": false,
          "source": false,
          "type": "1",
          "visual": true
        },
        "pm_p_type": "A",
        "randomMax": 30,
        "randomMin": 5,
        "refreshNumber": false,
        "setRefNumber": 0,
        "time_type": "stand-600000",
        "timerHour": 0,
        "timerMinute": 10,
        "timerSecond": 0,
        "visual": false
      }
    },
    "format_update_date": "January 8, 2026",
    "last-heartbeat": 1767850909346,
    "options": {
      "asrefresh": true,
      "asrestart": true,
      "asurl": "https://idx.google.com/node-express-web-ts-31822042",
      "autostart": true,
      "clickInteraction": false,
      "default_time": 12,
      "defaultpgtxt": "",
      "domains": {},
      "hotkeys": false,
      "ignoreInputField": true,
      "interactions": false,
      "keyboardInteraction": false,
      "pdcheck": false,
      "pdurl": "",
      "pm_sound_til": "sound",
      "pm_sound_timeout": 5,
      "pmemail": "",
      "pmpattern": "A",
      "random_time": true,
      "restartDefault": false,
      "rpt": false,
      "rpttext": "",
      "scrollToKeyword": true,
      "sound": "3",
      "soundurl": "",
      "soundvolume": 1,
      "tabAlertSection": true,
      "tabAlertTime": 1,
      "timercheck": true,
      "urlChangeFollow": 1,
      "visualPosition": "1",
      "visualtimer": false,
      "windowFocus": false
    },
    "version": 8
  },
  "sync": {},
  "storage": {}
}
```



