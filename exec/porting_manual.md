# 개발 환경

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

SSL
+ Let's Encrypt : certbot 0.40.0

Firebase
+ firebase-admin : 9.2.0

AWS
+ awssdk : 2.21.1

QueryDSL
+ querydsl-jpa : 5.0.0

WebSocket
+ sockjs-client : 1.5.1
+ stomp-websocket : 2.3.4

SpringDoc
+ springdoc-openapi-starter-webmvc-ui : 2.1.0 



---



# 도커 설치 
https://www.hostwinds.kr/tutorials/install-docker-debian-based-operating-system

# apt 패키지 색인 업데이트
sudo apt-get update

# debian용 docker 필수 패키지 설치
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



---



# 도커에 젠킨스 올리기
```
# 젠킨스 저장소 설치
mkdir -p /var/jenkins_home

# 권한 설정
chown -R 1000:1000 /var/jenkins_home/

# 호스트 8888:컨테이너8080 매핑/ 포트50000을 도커 소켓 통신 위해 매핑
docker run --restart=on-failure --user='root' \
-p 8888:8080 -p 50000:50000 \
--env JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
-v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-d --name jenkins jenkins/jenkins:lts
```


---



# 젠킨스 컨테이너 환경에서 java와 docker를 설치(Dood)
```
# 젠킨스 컨테이너 내부의 프로세스와 환경에 대해 명령을 실행시키기 위해 인터랙티브 모드로 쉘 실행
docker exec -it jenkins bash

# apt 색인 업데이트
apt-get update

# 자바 설치
apt-get install openjdk-17-jdk -y

# 도커 설치
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
```


---



# 다음 내용을 갖는 Dockerfile을 작성한 후 /var/jenkins_home/workspace/petcong/server_petcong 에 위치시키기
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



# Firebase sdk 설정
https://firebase.google.com/docs/admin/setup?hl=ko#initialize-sdk

+ 환경변수
+ GOOGLE_APPLICATION_CREDENTIALS="서비스 계정으로 만든 비공개 키 경로"


# AWS sdk 설정
https://docs.aws.amazon.com/ko_kr/AmazonS3/latest/userguide/Welcome.html

+ 환경변수
+ S3_BUCKET_NAME="S3 버킷 이름"
+ AWS_ACCESS_KEY_ID="엑세스 키 아이디"
+ AWS_SECRET_ACCESS_KEY="시크릿 엑세스 키"
