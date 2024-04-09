# 펫콩! 반려동물 실시간 랜덤 소개팅 모바일 어플리케이션


![petcong](./assets/petcong.PNG)

# 목차

### [**1. 서비스 개요**](#📌-서비스-개요)

### [**2. 기획 배경**](#☁-기획-배경)

### [**3. 서비스 기능 소개**](#🏛-서비스-기능-소개)

### [**4. 팀 구성**](#👨🏻‍💻-팀-구성)

### [**5. 기술 스택**](#🛠️-기술-스택)

### [**6. 아키텍처**](#🎨-아키텍처)

### [**7. 주요기능**](#💡-주요기능)

### [**프로젝트 산출물**](#📄-프로젝트-산출물)


# 📌 서비스 개요

- 개발 기간 : 2024.01.03 ~ 2024.02.16 (7주)
- 개요 : 반려동물 실시간 랜덤 화상 소개팅 앱

# ☁ 기획 배경

- 랜덤 매칭 화상 소개팅 서비스의 부재
- 반려동물인의 증가에 따른 새로운 사업 모델

# 🏛 서비스 기능 소개

- 랜덤 매칭 : 선호 키워드에 따른 랜덤 매칭
- 화상 채팅 : 매칭된 유저들간 WebRTC를 통한 화상채팅
- 아이스 브레이킹 : 화상 채팅 시 아이스 브레이킹할 수 있는 컨텐츠 제공

# 👨🏻‍💻팀 구성

| [박종우](https://github.com/jong29)                                                       | [강이규](https://github.com/EhighG)                                                      | [송영주](https://github.com/ztrl)                                                     | [신문영](https://github.com/ztrl)                                                   | [이정호](https://github.com/paul-lee-dev)                                                     | [주재원](https://github.com/lahmthebest)                                                 |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> | <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> | <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> | <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> | <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> | <img src="https://avatars.githubusercontent.com/u/91371560?v=4" width="150" height="150"> |
| 팀장, 풀스택                                                                               | 백엔드, WebRTC                                                                                    | 프론트엔드, WebRTC                                                                              | 백엔드, 인프라                                                                                | 프론트엔드                                                                                    | 프론트엔드                                                                                    |
| Docs 페이지 구현<br/>사용자 인증/인가<br/>                                | 은행 생성 API 개발<br/>더미데이터 API 개발<br/>                                           | CI/CD 구축<br/>이메일 인증 및 검색 API 개발<br/>                                           | 계좌, 상품 API 개발<br/> 거래내역 API 개발<br/>                                            | 애플리케이션 구현<br/>Admin 페이지 API 연동                                               | Admin 레이아웃 구현<br/> 대시보드 구현<br/>                                               |

<br/>

# 🛠️ 기술 스택

**Front**
<br/>
<img src="https://img.shields.io/badge/typescript-3178C6?style=for-the-badge&logo=typescript&logoColor=black" width="auto" height="25">
<img src="https://img.shields.io/badge/nextjs-000000?style=for-the-badge&logo=next.js&logoColor=whire" width="auto" height="25">
<img src="https://img.shields.io/badge/reactnative-00a4d3?style=for-the-badge&logo=react&logoColor=black" width="auto" height="25">
<img src="https://img.shields.io/badge/reactquery-FF4154?style=for-the-badge&logo=reactquery&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/recoil-3578E5?style=for-the-badge&logo=recoil&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/tailwind-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white" width="auto" height="25">

**Back**
<br/>
<img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/SPRING DATA JPA-6DB33F?style=for-the-badge&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/querydsl-669DF6?style=for-the-badge&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/SPRING SECURITY-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white" width="auto" height="25">

**Database**
<br/>
<img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/redis-DC382D?style=for-the-badge&logo=redis&logoColor=white" width="auto" height="25">

**Environment**
<br/>
<img src="https://img.shields.io/badge/nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" width="auto" height="25">

**Cooperation**
<br/>
<img src="https://img.shields.io/badge/gitlab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/jira-0052CC?style=for-the-badge&logo=jira&logoColor=white" width="auto" height="25">
<img src="https://img.shields.io/badge/notion-000000?style=for-the-badge&logo=notion&logoColor=white" width="auto" height="25">

<br/>

# 🎨 아키텍처

![아키텍처]()
<br/>

# 💡 주요기능



# 📄 프로젝트 산출물

### [1. 요구사항 명세서]()

![Required](./assets/Required.PNG)

### [2. ERD]()

![ERD](./assets/ERD.PNG)

### [3. API 명세서]()

![API](./assets/API.PNG)
<br/>


