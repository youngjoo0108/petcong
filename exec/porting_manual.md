# 개발 환경
Server OS
+ ubuntu : Ubuntu 20.04.6 LTS

Java
+ jdk : openjdk version "17.0.9" 2023-10-17
+ jre : OpenJDK Runtime Environment (build 17.0.9+9-Ubuntu-120.04)
+ jvm : OpenJDK 64-Bit Server VM (build 17.0.9+9-Ubuntu-120.04, mixed mode, sharing)

Spring
+ spring boot : 3.2.1

Web Server
+ nginx : nginx/1.18.0 (Ubuntu)

WAS
+ tomcat : Apache Tomcat/10.1.17 (스프링 내장)

DB
+ mysql : 8.1.0

IDE
+ IntelliJ IDEA 2023.3.2 (Ultimate Edition)
+ Build #IU-233.13135.103, built on December 20, 2023
+ Runtime version: 17.0.9+7-b1087.9 amd64
+ VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
+ Windows 10.0
+ Non-Bundled Plugins: com.intellij.spring.websocket (233.11799.196)

Container
+ docker : 25.0.0, build e758fe5

Deploy
+ jenkins : 2.426.2

SSL/TLS
+ letsencrypt : certbot 0.40.0

Firebase SDK
+ firebase-admin : 9.2.0

AWS SDK
+ awssdk : 2.21.1

QueryDSL
+ querydsl-jpa : 5.0.0

WebSocket
+ sockjs-client : 1.5.1
+ stomp-websocket : 2.3.4

SpringDoc
+ springdoc-openapi-starter-webmvc-ui : 2.1.0 

Flutter
+ Flutter : 3.16.9
+ Dart : 3.2.6
+ DevTools 2.28.5

Android
+ Kotlin : 1.7.10
+ minSDKVersion : 21
+ targetSDKVersion : 34
+ jvmTarget : 1.8
---
# application.yml
```
server:
  port: 8080

spring:
  datasource:
    hikari:
      driver-class-name: com.mysql.cj.jdbc.Driver
      jdbc-url: jdbc:mysql://{서버 주소}:{포트 번호}/petcongdb?serverTimezone=UTC&useUniCode=yes&characterEncoding=UTF-8
      username: {MySQL 접속 계정 이름}
      password: {MySQL 접속 계정 비밀번호}
  jpa:
    properties:
      hibernate:
        show_sql: true
        format_sql: true

springdoc:
  api-docs:
    enabled: true
    path: /api-docs/json
  swagger-ui:
    enabled: true
    path: /api-docs
    tags-sorter: alpha
    operations-sorter: alpha
    display-request-duration: true
  cache:
    disabled: true
  packages-to-scan: com.example.ssafy.petcong

allowed-url:
  urls:
  patterns:
    - /api-docs/**
    - /swagger-ui/**
    - /websocket/**
```
---
# Firebase
+ 프로젝트 추가 : https://firebase.google.com/?hl=ko -> 콘솔로 이동 -> 새 프로젝트 추가 
+ SDK 초기화 : https://firebase.google.com/docs/admin/setup?hl=ko#initialize_the_sdk_in_non-google_environments

##### 환경변수 설정 (윈도우: 시스템 환경 변수 편집 -> 환경 변수 -> 사용자 변수 새로 만들기, 리눅스: export)
+ GOOGLE_APPLICATION_CREDENTIALS="서비스 계정으로 만든 비공개 키 파일의 경로"


# AWS S3
+ S3 가이드 : https://docs.aws.amazon.com/ko_kr/AmazonS3/latest/userguide/Welcome.html

##### 환경변수 설정 (윈도우: 시스템 환경 변수 편집 -> 환경 변수 -> 사용자 변수 새로 만들기, 리눅스: export)
+ S3_BUCKET_NAME="S3 버킷 이름"
+ AWS_ACCESS_KEY_ID="엑세스 키 아이디"
+ AWS_SECRET_ACCESS_KEY="시크릿 엑세스 키"
---
# 배포 시나리오
1. 서버에 Docker, MySQL, Nginx, Certbot 등 필요한 프로그램 설치
2. Docker를 통해 Jenkins 컨테이너 띄우기
3. Jenkins 컨테이너 환경에 Java와 Docker를 설치
4. 파이프라인 설정
5. Repository에서 deploy 브랜치에 merge request가 accepted 된 경우 젠킨스가 인식하고 서버에 자동 배포
---
# 1. Nginx와 Let's Encrypt, Certbot 설치
```
# 방화벽 확인
sudo ufw status

# 방화벽 허용
sudo ufw allow {포트 번호}

# Nginx 설치
sudo apt install nginx -y

# Nginx 상태 확인
sudo systemctl status nginx

sudo apt-get update

# Let's encrypt 와 certbot 설치
sudo apt-get install letsencrypt
sudo apt-get install certbot python3-certbot-nginx

# Certbot Nginx 연결
sudo certbox --nginx
# 이메일 입력
# 약관 동의 - Y
# 이메일 수신 동의
# 도메인 입력
# http 입력 시 리다이렉트 여부 - 2 (리다이렉트함)

# default 설정파일 안에 아래 코드가 있는지 확인
cat /etc/nginx/sites-available/default
# ...
# listen [::]:443 ssl ipv6only=on; # managed by Certbot
# listen 443 ssl; # managed by Certbot
# ssl_certificate /etc/letsencrypt/live/{서버 주소}/fullchain.pem; # managed by Certbot
# ssl_certificate_key /etc/letsencrypt/live/{서버 주소}/privkey.pem; # managed by Certbot
# include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
# ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
# ...
#
# server {
#     if ($host = {서버 주소}) {
#         return 301 https://$host$request_uri;
#     } # managed by Certbot
#
#
#         listen 80 ;
#         listen [::]:80 ;
#     server_name {서버 주소};
#     return 404; # managed by Certbot
#}

# default 설정 수정
vi /etc/nginx/sites-available/default
# root가 /var/www/html이면서 
# server_name이 {서버 주소}인 
# server { ... } 블록 안에 아래 맵핑 설정 추가하기
#
#        location / {
#                proxy_pass http://localhost:8080;
#                proxy_set_header Host $http_host;
#                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#                proxy_set_header X-Real-IP $remote_addr;
#        }
#
#        location /websocket {
#                proxy_pass http://localhost:8080/websocket;
#                proxy_set_header Host $http_host;
#                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#                proxy_set_header X-Real-IP $remote_addr;
#                proxy_http_version 1.1;
#                proxy_set_header Upgrade $http_upgrade;
#                proxy_set_header Connection "upgrade";
#        }
```
---
# 2. 도커 설치 
https://www.hostwinds.kr/tutorials/install-docker-debian-based-operating-system
```
# apt 패키지 색인 업데이트
sudo apt-get update

# Debian용 Docker 필수 패키지 설치
sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
gnupg2 \
software-properties-common

# 키 링에 GPG 키 추가
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# 키 지문이 일치하는지 확인
sudo apt-key fingerprint 0EBFCD88

# 저장소를 운영 체제 목록에 추가
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian \
$(lsb_release -cs) \
stable"

# apt 패키지 색인 업데이트
sudo apt-get update

# Docker 엔진 설치
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
---
# 3. 도커에 젠킨스 올리기
```
# 젠킨스 저장소 설치
mkdir -p /var/jenkins_home

# 권한 설정
chown -R 1000:1000 /var/jenkins_home/

# 호스트 8001:컨테이너 8080 매핑
# 호스트 50000:컨테이너 50000을 도커 소켓 통신 위해 매핑
docker run --restart=on-failure --user='root' \
-p 8001:8080 -p 50000:50000 \
--env JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
-v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-d --name jenkins jenkins/jenkins:lts
```
---
# 4. 젠킨스 컨테이너 환경에서 java와 docker를 설치(Dood)
```
# 젠킨스 컨테이너 내부의 프로세스와 환경에 대해 명령을 실행시키기 위해 인터랙티브 모드로 쉘 실행
docker exec -it jenkins bash

# apt 색인 업데이트
apt-get update

# Java 설치
apt-get install openjdk-17-jdk -y

# Docker 설치
apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg2 \
software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian \
$(lsb_release -cs) \
stable"

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

# 설치 다 했으면 쉘에서 exit
exit
```
---
# 5. 다음 내용을 갖는 Dockerfile을 작성한 후 /var/jenkins_home/workspace/dockerfiles에 위치시키기
```
FROM gradle:7.4-jdk17 as builder
WORKDIR /build

# 그래들 파일이 변경되었을 때만 새롭게 의존패키지 다운로드 받게함.
COPY build.gradle settings.gradle /build/
RUN gradle build -x test --parallel --continue > /dev/null 2>&1 || true

# 빌더 이미지에서 애플리케이션 빌드
COPY . /build
RUN gradle build -x test --parallel

# APP
FROM openjdk:17-ea-4-jdk-slim
WORKDIR /app

# 빌더 이미지에서 jar 파일만 복사
COPY --from=builder /build/build/libs/petcong-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

# root 대신 nobody 권한으로 실행
USER nobody
ENTRYPOINT [ \
        "java", \
        "-jar", \
        "-Djava.security.egd=file:/dev/./urandom", \
        "-Dsun.net.inetaddr.ttl=0", \
        "petcong-0.0.1-SNAPSHOT.jar" \
]
```
---
# 6. 젠킨스 설정하기
먼저 {서버 주소}:8001으로 접속해서 jenkins를 unlock 후 Install suggested plugins

##### 플러그인 설치 
1. Dashboard에서 jenkins 관리
2. Plugins에서 gitlab으로 검색
3. GitLab API Plugin, GitLab Authentication plugin, GitLab Branch Source, GitLab Plugin 설치

##### Credentials 설정
1. Dashboard에서 jenkins 관리
2. Security 항목에 있는 Credentials 클릭
3. Stores scoped to Jenkins에서 (global) 클릭
4. Add Credentials 클릭, Kind를 GitLab API token으로 설정
5. Gitlab에서 Edit profile -> Access Tokens -> Add new token으로 토큰 발급
6. 발급 받은 토큰을 API token 칸에 입력하고 새로운 credential을 create
7. Add Credentials 클릭, Kind를 Username with password로 설정
8. Gitlab 계정의 아이디를 Username에, 비밀번호는 Password에 입력하고 새로운 credential을 create

##### 시스템 설정
1. Dashboard에서 jenkins 관리
2. System Configuration 항목에 있는 System 클릭
3. GitLab 항목의 GitLab connections 찾기
4. GitLab host URL에는 Gitlab 호스트 주소(ex.https://lab.ssafy.com/)
5. Credentials은 GitLab API token
6. test connection을 눌러 연결 되는지 확인하고 저장

##### 파이프라인 설정
1. Dashboard에서 새로운 Item을 만들어서 파이프라인 생성
2. 구성 화면에서 GitHub project 체크 후, Project url에 레포지토리 주소 입력
3. Build Triggers 항목에서 Build when a change is pushed to GitLab. 체크
4. Enabled GitLab triggers에서 Accepted Merge Request Events 체크 (다른 트리거를 쓰고 싶으면 다른 항목 체크)
5. 고급을 눌러 Filter branches by name 선택한 후 Include에 deploy 입력 (deploy 브랜치만 인식)
6. Secret token 아래 Generate를 눌러 Secret token 발급 받기
7. 깃랩 Repository 가서 Settings -> Webhooks 에서 Add new webhook
8. URL 칸에 http://{서버 주소}:8001/project/{파이프라인 이름} 입력
9. Secret token 칸에는 파이프라인에서 발급받은 Secret token 입력
10. Trigger 항목에서 Merge request events 체크 후 test 해본 뒤 Add webhook

##### 파이프라인 스크립트 작성 (파이프라인 구성에서 Pipeline 항목에 있는 Script 칸에 작성)
```
pipeline
{
    agent any
    stages
    {
        stage('gitlab connection')
        {
            steps
            {
                git branch: 'deploy',
                credentialsId: 'Username with password로 만든 credentials의 ID',
                url: '깃 url'
            }
        }
        stage('build server')
        {
            steps
            {
                dir('server_petcong') {
                    sh 'cd /var/jenkins_home/workspace/petcong/server_petcong/'
                    sh 'chmod +x gradlew'
                    sh './gradlew clean build -x test'
                }
            }
        }
        stage('server deploy')
        {
            steps
            {
                script 
                {
                    try {
                        sh 'docker stop spring'
                    } catch(e) {
                        print(e)
                    }
                    try {
                        sh 'docker rm spring'
                    } catch(e) {
                        print(e)
                    }
                    try {
                        sh 'docker rmi backend'
                    } catch(e) {
                        print(e)
                    }
                }
                dir('server_petcong')
                {
                    sh 'cp /var/jenkins_home/workspace/dockerfiles/Dockerfile .'
                    sh 'docker build -t backend .'
                    sh '''
                        docker run -d\
                        -p 8080:8080\
                        -v `Firebase credentails json 파일 경로`:/app/petcong-firebase-credentials.json\
                        -e GOOGLE_APPLICATION_CREDENTIALS=/app/petcong-firebase-credentials.json\
                        -e AWS_ACCESS_KEY_ID=`AWS 엑세스 키`\
                        -e AWS_SECRET_ACCESS_KEY=`AWS 시크릿 엑세스 키`\
                        -e S3_BUCKET_NAME=`S3 버킷 이름` --name spring backend
                    '''
                }
            }
        }
    }
}
```
---
# 7. MySQL 설치
```
# Docker로 MySQL 컨테이너 띄우기
docker run -d \
-e MYSQL_ROOT_PASSWORD={root 계정 비밀번호} \
-v mysql_data:/var/lib/mysql \
-p 3306:3306 \
--name mysql-container mysql:8.1.0

# MySQL 컨테이너 인터렉티브 모드로 쉘 실행
docker exec -it mysql-container bash

# MySQL 연결 후 덤핑
mysql -uroot -p{root 계정 비밀번호} < {덤프 파일 위치}
```

# 8. Firebase Flutter 설정

[Flutter에서 Firebase 인증 시작하기](https://firebase.google.com/docs/auth/flutter/start?hl=ko)

[Flutter 앱에 Firebase 추가](https://firebase.google.com/docs/flutter/setup?hl=ko&_gl=1*1fwwexv*_up*MQ..*_ga*MTgxNzI5NTA5OS4xNzA3OTIxMDg3*_ga_CW55HF8NVT*MTcwNzkyMTA4Ni4xLjAuMTcwNzkyMTA4Ni4wLjAuMA..&platform=android)

[안드로이드 앱 설치 링크](https://linkhere/)
