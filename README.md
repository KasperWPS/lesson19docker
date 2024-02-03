# Домашнее задание № 13 по теме: "Docker". К курсу Administrator Linux. Professional

- Установить Docker на host-машину
- Установите Docker Compose
- Создайте свой кастомный образ nginx на базе alpine

Собрвнный образ на dockerhub: https://hub.docker.com/repository/docker/kasperwps/nginxcustomotus/general


## Установка Docker, Docker Compose

Установка произведена в системе Gentoo, для корректной работы проверяем конфиг ядра (в данном случае версия 6.7.2-gentoo-r1), если необходимо исправить параметры и пересобрать ядро:

```
~/otus/docker $ /usr/share/docker/contrib/check-config.sh

info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: cgroupv2
  Controllers:
  - cpu: available
  - cpuset: available
  - io: available
  - memory: available
  - pids: available
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_KEYS: enabled
- CONFIG_VETH: enabled
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled
- CONFIG_IP_NF_FILTER: enabled
- CONFIG_IP_NF_MANGLE: enabled
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled
- CONFIG_NETFILTER_XT_MATCH_IPVS: enabled
- CONFIG_NETFILTER_XT_MARK: enabled
- CONFIG_IP_NF_NAT: enabled
- CONFIG_NF_NAT: enabled
- CONFIG_POSIX_MQUEUE: enabled
- CONFIG_CGROUP_BPF: enabled

Optional Features:
- CONFIG_USER_NS: enabled
- CONFIG_SECCOMP: enabled
- CONFIG_SECCOMP_FILTER: enabled
- CONFIG_CGROUP_PIDS: enabled
- CONFIG_MEMCG_SWAP: missing
    (cgroup swap accounting is currently enabled)
- CONFIG_BLK_CGROUP: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: enabled
- CONFIG_NET_CLS_CGROUP: enabled
- CONFIG_CGROUP_NET_PRIO: enabled
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_IP_NF_TARGET_REDIRECT: enabled
- CONFIG_IP_VS: enabled
- CONFIG_IP_VS_NFCT: enabled
- CONFIG_IP_VS_PROTO_TCP: enabled
- CONFIG_IP_VS_PROTO_UDP: enabled
- CONFIG_IP_VS_RR: enabled
- CONFIG_SECURITY_SELINUX: enabled
- CONFIG_SECURITY_APPARMOR: missing
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Network Drivers:
  - "overlay":
    - CONFIG_VXLAN: enabled
    - CONFIG_BRIDGE_VLAN_FILTERING: enabled
      Optional (for encrypted networks):
      - CONFIG_CRYPTO: enabled
      - CONFIG_CRYPTO_AEAD: enabled
      - CONFIG_CRYPTO_GCM: enabled
      - CONFIG_CRYPTO_SEQIV: enabled
      - CONFIG_CRYPTO_GHASH: enabled
      - CONFIG_XFRM: enabled
      - CONFIG_XFRM_USER: enabled
      - CONFIG_XFRM_ALGO: enabled
      - CONFIG_INET_ESP: enabled
      - CONFIG_NETFILTER_XT_MATCH_BPF: missing
  - "ipvlan":
    - CONFIG_IPVLAN: enabled
  - "macvlan":
    - CONFIG_MACVLAN: enabled
    - CONFIG_DUMMY: enabled
  - "ftp,tftp client in container":
    - CONFIG_NF_NAT_FTP: enabled
    - CONFIG_NF_CONNTRACK_FTP: enabled
    - CONFIG_NF_NAT_TFTP: enabled
    - CONFIG_NF_CONNTRACK_TFTP: enabled
- Storage Drivers:
  - "btrfs":
    - CONFIG_BTRFS_FS: enabled
    - CONFIG_BTRFS_FS_POSIX_ACL: enabled
  - "devicemapper":
    - CONFIG_BLK_DEV_DM: enabled
    - CONFIG_DM_THIN_PROVISIONING: enabled
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled
  - "zfs":
    - /dev/zfs: missing
    - zfs command: missing
    - zpool command: missing

Limits:
- /proc/sys/kernel/keys/root_maxkeys: 1000000
```

Были установлены: app-containers/docker и app-containers/docker-compose с зависимостями


## Создайте свой кастомный образ nginx на базе alpine

- Создать Dockerfile

```
FROM alpine:latest
RUN apk add --no-cache nginx
COPY root /
EXPOSE 80/tcp
CMD /usr/sbin/nginx -g "daemon off;"
```

- Создать кастомные конфиг и начальную страницу

```
mkdir -p ./root/etc/nginx/http.d
mkdir -p ./root/srv/www
```

- /etc/nginx/http.d

```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # Everything is a 404
        location / {
                root /srv/www;
                index index.html;
        }

        # You may need this to prevent return 404 recursion.
        location = /404.html {
                internal;
        }
}

```

- /srv/www/index.html

```
<html>
        <head>
                <title>Home work 13. Docker</title>
        </head>
        <body>
                <h3>Test for home work 13. Docker. Otus</h3>
        </body>
</html>
```

- Собрать образ

```
docker build -t kasperwps/nginxcustomotus .
```

- Запустить контейнер с пробросом порта 8080 -> 80

```
docker run -dt -p 8080:80 nginx-custom
```

- Проверить доступность http://localhost:8080

- Запушить образ на dockerhub (https://hub.docker.com/repository/docker/kasperwps/nginxcustomotus/general)

```
docker login -u kasperwps
docker push kasperwps/nginxcustomotus:latest
```

## Вопросы к упражнению

- Разница между контейнером и образом

Образ (Docker Image) - это шаблон, на основе которого создается контейнер. Образ невозможно изменить, его можно только пересобрать. Можно утверждать, что это снимок приложения и окружающей среды в определенный момент времени.

Контейнер (Docker Container) - изолированная среда для запуска приложений создается из образов

- Можно ли в контейнере собрать ядро

Можно, для этого понадобится контейнер созданный из образа в котором должны присутствовать необходимые библиотеки, заголовочные файлы, средства компиляции и сборки. Ниже пример Dockerfile для сборки образа со сборкой ядра (директория dkernel):

```
FROM debian:latest
RUN apt-get update
RUN apt-get install gcc perl-base make flex bison xz-utils wget libelf-dev bc libssl-dev -y
RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.3.tar.xz -O /usr/src/linux-6.7.3.tar.xz
RUN cd /usr/src && tar xf linux-6.7.3.tar.xz
RUN rm /usr/src/linux-6.7.3.tar.xz
COPY ./.config /usr/src/linux-6.7.3/
RUN cd /usr/src/linux-6.7.3 && make -j12

CMD sleep 100000
```

## Задание с *

- Написать Docker-compose для приложения Redmine, с использованием опции build.
- Добавить в базовый образ redmine любую кастомную тему оформления.
- Убедиться что после сборки новая тема доступна в настройках.
- Настроить volumes, для сохранения всей необходимой информации

## Выполнение

- Docker-compose

```yaml
version: '3.1'

services:

  redminecustom:
    build:
      context: ./custom
      dockerfile: Dockerfile-redmine
    restart: always
    ports:
      - 8081:3000
    environment:
      REDMINE_DB_MYSQL: db
      REDMINE_DB_PASSWORD: example
      REDMINE_SECRET_KEY_BASE: supersecretkey
    image: redminecustom
    volumes:
      - "/tmp:/usr/src/redmine/files"


  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: redmine
```

Для примера volume расположил в /tmp

```bash
docker compose -f docker-compose.yml up
```

- Добавить тему

```bash
cd ./custom
git clone https://github.com/farend/redmine_theme_farend_bleuclair.git public/themes/bleuclair
```

./redmine/custom/Dockerfile-redmine

```
FROM redmine
COPY public /usr/src/redmine/public
```

Все необходимые файлы присутствуют в данном репозитории
