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
-- Table structure for table `matchings`
--

DROP TABLE IF EXISTS `matchings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matchings` (
  `matching_id` int NOT NULL AUTO_INCREMENT,
  `from_user_id` int NOT NULL,
  `to_user_id` int NOT NULL,
  `call_status` enum('PENDING','MATCHED','REJECTED') DEFAULT NULL,
  PRIMARY KEY (`matching_id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  CONSTRAINT `matchings_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `matchings_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matchings`
--

LOCK TABLES `matchings` WRITE;
/*!40000 ALTER TABLE `matchings` DISABLE KEYS */;
INSERT INTO `matchings` VALUES (1,4,7,'PENDING');
/*!40000 ALTER TABLE `matchings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pets`
--

DROP TABLE IF EXISTS `pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pets` (
  `pet_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
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
  KEY `user_id` (`user_id`),
  CONSTRAINT `pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pets`
--

LOCK TABLES `pets` WRITE;
/*!40000 ALTER TABLE `pets` DISABLE KEYS */;
/*!40000 ALTER TABLE `pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_multimedias`
--

DROP TABLE IF EXISTS `skill_multimedias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_multimedias` (
  `multimedia_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  `content_type` varchar(20) NOT NULL,
  `length` int NOT NULL,
  `ordinal` int DEFAULT NULL,
  PRIMARY KEY (`multimedia_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `skill_multimedias_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_multimedias`
--

LOCK TABLES `skill_multimedias` WRITE;
/*!40000 ALTER TABLE `skill_multimedias` DISABLE KEYS */;
/*!40000 ALTER TABLE `skill_multimedias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_imgs`
--

DROP TABLE IF EXISTS `user_imgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_imgs` (
  `img_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  `content_type` varchar(20) NOT NULL,
  `length` int NOT NULL,
  `ordinal` int DEFAULT NULL,
  PRIMARY KEY (`img_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_imgs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_imgs`
--

LOCK TABLES `user_imgs` WRITE;
/*!40000 ALTER TABLE `user_imgs` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_imgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'MALE',27,'tester1','test@petcong.com','Seoul','1997-01-29 00:00:00','ACTIVE',0,'FEMALE','SA7q9H4r0WfIkvdah6OSIW7Y6XQ2',NULL,'kakaoChocolate'),(7,'FEMALE',27,'tester2','test2@petcong.com','Seoul','1997-01-29 00:00:00','ACTIVE',0,'MALE','1997','instakilogram',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-31  5:15:58
