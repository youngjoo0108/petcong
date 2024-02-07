-- MySQL dump 10.13  Distrib 8.1.0, for Linux (x86_64)
--
-- Host: localhost    Database: petcongdb
-- ------------------------------------------------------
-- Server version       8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Icebreaking`
--

DROP TABLE IF EXISTS `Icebreaking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Icebreaking` (
  `Icebreaking_id` int NOT NULL,
  `content` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Icebreaking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Icebreaking`
--

LOCK TABLES `Icebreaking` WRITE;
/*!40000 ALTER TABLE `Icebreaking` DISABLE KEYS */;
/*!40000 ALTER TABLE `Icebreaking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Matching`
--

DROP TABLE IF EXISTS `Matching`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Matching` (
  `matching_id` int NOT NULL AUTO_INCREMENT,
  `from_member_id` int NOT NULL,
  `to_member_id` int NOT NULL,
  `call_status` enum('PENDING','MATCHED','REJECTED') DEFAULT NULL,
  PRIMARY KEY (`matching_id`),
  KEY `from_user_id` (`from_member_id`),
  KEY `to_user_id` (`to_member_id`),
  CONSTRAINT `Matching_ibfk_1` FOREIGN KEY (`from_member_id`) REFERENCES `Member` (`member_id`),
  CONSTRAINT `Matching_ibfk_2` FOREIGN KEY (`to_member_id`) REFERENCES `Member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Matching`
--

LOCK TABLES `Matching` WRITE;
/*!40000 ALTER TABLE `Matching` DISABLE KEYS */;
INSERT INTO `Matching` VALUES (1,4,7,'PENDING');
/*!40000 ALTER TABLE `Matching` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member`
--

DROP TABLE IF EXISTS `Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `gender` enum('MALE','FEMALE') DEFAULT NULL,
  `age` int NOT NULL,
  `nickname` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `status` enum('ACTIVE','DELETED') DEFAULT NULL,
  `callable` tinyint(1) NOT NULL,
  `preference` enum('MALE','FEMALE','BOTH') DEFAULT NULL,
  `uid` varchar(30) NOT NULL,
  `instagram_id` varchar(30) DEFAULT NULL,
  `kakao_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member`
--

LOCK TABLES `Member` WRITE;
/*!40000 ALTER TABLE `Member` DISABLE KEYS */;
INSERT INTO `Member` VALUES (4,'MALE',27,'tester1','test@petcong.com','Seoul','1997-01-29 00:00:00','ACTIVE',1,'FEMALE','SA7q9H4r0WfIkvdah6OSIW7Y6XQ2','microgram','kakaoChocolate'),(7,'FEMALE',27,'tester2','test2@petcong.com','Seoul','1997-01-29 00:00:00','ACTIVE',0,'MALE','1997','instakilogram',NULL),(8,'MALE',1,'nickname','smy@petcong.com','Korea','1997-01-29 00:00:00','ACTIVE',0,'FEMALE','1','miligram','macao'),(12,'MALE',62,'yungjoo','yj1231@gmail.com','서울특별시 강남구 역삼동 테헤란로 212, 1402호','2000-01-01 00:00:00','ACTIVE',1,'MALE','4GtzqrsSDBVSC1FkOWXXJ2i7CfA3','instaId','moon'),(13,'MALE',30,'jungho','jungho@gmail.com','서울특별시 강남구 역삼동 테헤란로 212, 1402호','2000-01-01 00:00:00','ACTIVE',1,'MALE','kS95PNT8RUc78Qr7TQ4uRaJmbw23','instaId','moon'),(14,'MALE',30,'jungho2','jungho2@gmail.com','Seoul 212, 1402','2000-01-01 00:00:00','ACTIVE',1,'MALE','gHVcvjllueRTdd9F6P1M6ZUVi283','instaId','moon'),(15,'MALE',27,'jaewon','jaewon@gmail.com','Seoul 212, 1402','2000-01-01 00:00:00','ACTIVE',0,'MALE','bXPUzT3tFOaT2UE9RdxKPHHAIhK2','instaId','moon'),(33,'MALE',10,'nickname','signuptest@signuptest.com','korea','1997-01-29 00:00:00','ACTIVE',0,'FEMALE','signuptest','instatonid','kakaochocolate');
/*!40000 ALTER TABLE `Member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MemberImg`
--

DROP TABLE IF EXISTS `MemberImg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MemberImg` (
  `img_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `bucket_key` varchar(255) NOT NULL,
  `content_type` varchar(20) NOT NULL,
  `length` int NOT NULL,
  `ordinal` int DEFAULT NULL,
  PRIMARY KEY (`img_id`),
  KEY `user_id` (`member_id`),
  CONSTRAINT `MemberImg_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MemberImg`
--

LOCK TABLES `MemberImg` WRITE;
/*!40000 ALTER TABLE `MemberImg` DISABLE KEYS */;
INSERT INTO `MemberImg` VALUES (7,4,'SA7q9H4r0WfIkvdah6OSIW7Y6XQ2/20240206-173125.jpg','multipart/form-data',122508,0),(8,4,'SA7q9H4r0WfIkvdah6OSIW7Y6XQ2/20240206-173631.jpg','jpg',122508,0);
/*!40000 ALTER TABLE `MemberImg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pet`
--

DROP TABLE IF EXISTS `Pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pet` (
  `pet_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `name` varchar(25) NOT NULL,
  `breed` varchar(25) NOT NULL,
  `age` int NOT NULL,
  `gender` enum('MALE','FEMALE') DEFAULT NULL,
  `neutered` tinyint(1) NOT NULL,
  `size` enum('SMALL','MEDIUM','LARGE') DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `dbti` char(4) DEFAULT NULL,
  `hobby` varchar(25) DEFAULT NULL,
  `snack` varchar(25) DEFAULT NULL,
  `toy` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`pet_id`),
  KEY `user_id` (`member_id`),
  CONSTRAINT `Pet_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pet`
--

LOCK TABLES `Pet` WRITE;
/*!40000 ALTER TABLE `Pet` DISABLE KEYS */;
INSERT INTO `Pet` VALUES (17,4,'야옹이','골드 리트리버',1,'FEMALE',0,'LARGE',30,'우리 개는 물어요.','INFP','산책','생닭다리','원반');
/*!40000 ALTER TABLE `Pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SkillMultimedia`
--

DROP TABLE IF EXISTS `SkillMultimedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SkillMultimedia` (
  `multimedia_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `bucket_key` varchar(255) NOT NULL,
  `content_type` varchar(20) NOT NULL,
  `length` int NOT NULL,
  `ordinal` int DEFAULT NULL,
  PRIMARY KEY (`multimedia_id`),
  KEY `user_id` (`member_id`),
  CONSTRAINT `SkillMultimedia_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SkillMultimedia`
--

LOCK TABLES `SkillMultimedia` WRITE;
/*!40000 ALTER TABLE `SkillMultimedia` DISABLE KEYS */;
INSERT INTO `SkillMultimedia` VALUES (2,4,'SA7q9H4r0WfIkvdah6OSIW7Y6XQ2/video_sample.mp4','multipart/form-data',7692518,0);
/*!40000 ALTER TABLE `SkillMultimedia` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-07  5:42:47
