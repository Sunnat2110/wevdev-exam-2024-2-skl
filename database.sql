-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_2533_exam
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

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
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('9763dd8f9b96');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genres`
--

DROP TABLE IF EXISTS `book_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genres` (
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `fk_book_genres_genre_id_genres` (`genre_id`),
  CONSTRAINT `fk_book_genres_book_id` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_book_genres_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_book_genres_genre_id_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genres`
--

LOCK TABLES `book_genres` WRITE;
/*!40000 ALTER TABLE `book_genres` DISABLE KEYS */;
INSERT INTO `book_genres` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(7,1);
/*!40000 ALTER TABLE `book_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `year` int(11) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `pages` int(11) NOT NULL,
  `cover_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_cover_id_covers` (`cover_id`),
  CONSTRAINT `fk_books_cover_id_covers` FOREIGN KEY (`cover_id`) REFERENCES `covers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Гарри Поттер и философский камень','В первой книге о Гарри Поттере читатели знакомятся с главным героем, который в это время проживает в семье Дурслей. Его опекуны всеми силами стараются оградить его от магии, хотя сам Гарри все чаще замечает проявления своих необычных магических способностей. В итоге в какой-то момент за юным волшебником прибывает Хагрид — лесничий магической школы Хогвартс. Он раскрывает Гарри всю правду о его родителях и считает, что ему следует отправиться на обучение в Хогвартс. По пути туда будущий великий волшебник знакомится с Роном и Гермионой, которые станут его самыми близкими друзьями и участниками грядущих приключений…',1997,'Росмэн','Дж. К. Роулинг',400,6),(2,'Гарри Поттер и Тайная комната','Наступили летние каникулы и Гарри стало казаться, что все о нём забыли. От Рона и Гермионы не приходит ни весточки, а эльф Добби постоянно пугает мальчика об опасности школы волшебства и не советует туда возвращаться. Но Гарри не боится и наоборот по возвращении в магическую школу наконец обретает чувство, что он снова дома. Его ожидают новые приключения и опасные передряги, ведь именно в это время он узнает о легенде про тайную комнату, которую способен открыть лишь избранный. Получится ли у Гарри и его друзей найти эту комнату и избавить Хогвартс от страшного монстра?',1998,'Росмэн','Дж. К. Роулинг',480,1),(3,'Гарри Поттер и узник Азкабана','Начало нового учебного года оказывается не слишком удачным для Гарри Поттера. Семейство Дурслей, как всегда, игнорирует день рождение главного героя и ему приходится отмечать его в одиночестве. По пути в Хогвартс Гарри становится известно, что из особой тюрьмы, где находятся волшебники-преступники, сбежал Сириус Блэк. До этого момента никому еще не удавалось совершить побег из Азкабана, но Сириус смог это каким-то образом сделать. Гарри рассказывают, что теперь этот преступник начал разыскивать именно его…',1999,'Росмэн','Дж. К. Роулинг',512,7),(4,'Гарри Поттер и Кубок огня','Снова летние каникулы завершаются, и Гарри с Роном направляются в Хогвартс, чтобы продолжить обучение. Этот школьный год ознаменован необычным событием — Турниром Трех Волшебников, который ожидают многие. Несколько лет это соревнование не проводилось, поскольку оно слишком опасно. Неоднократно случались трагедии, когда чемпионы погибали во время выполнения заданий. Теперь в Турнире могут участвовать лишь кандидаты возрастом не младше 17 лет. Однако выясняется, что Кубок Огня выбирает Гарри для участия, хотя ему исполнилось лишь четырнадцать…',2000,'Росмэн','Дж. К. Роулинг',667,3),(5,'Гарри Поттер и Орден Феникса','Как всегда, под конец каникул у Гарри возникли проблемы, и на этот раз он был просто вынужден использовать свои магические способности. Когда Гарри ругался со своим кузеном их атаковали дементоры, один из которых был чуть не съел душу Дадли. Ценой огромных усилий Гарри удалось выгнать страшных созданий, но сразу же пришло письмо из Министерства о том, что Гарри оказывается претендентом на исключение из школы волшебства с дальнейшим уничтожением его волшебной палочки. Однако это не самая большая неприятность в жизни главного героя. К Гарри приходят представители Ордена Феникса, который был создан для борьбы с последователями лорда Волан-де-Морта. Вскоре Гарри с товарищами организовывают Отряд Дамблдора, который является союзником Ордена в нелегкой борьбе с темными волшебниками…',2003,'Росмэн','Дж. К. Роулинг',832,5),(7,'Гарри Поттер и Дары Смерти','Теперь ни у кого нет сомнений в том, что Гарри Поттеру было суждено стать легендарным волшебником. Длинный список его опасных приключений регулярно пополняется. На счету Гарри много успехов не только в магических турнирах, но и в реальных сражениях с более сильными и опытными врагами. Однако самая важная битва в жизни Гарри еще впереди. Могущество Волан-де-Морта неустанно растет и даже думать страшно, чем это может обернуться для магического мира, если Гарри не победит Темного Лорда… Но в этот раз Гарри будет вынужден полагаться лишь на свои силы.',2007,'Росмэн','Дж. К. Роулинг',640,2);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `covers`
--

DROP TABLE IF EXISTS `covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `covers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(50) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `md5_hash` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `covers`
--

LOCK TABLES `covers` WRITE;
/*!40000 ALTER TABLE `covers` DISABLE KEYS */;
INSERT INTO `covers` VALUES (1,'1Harry_Potter_and_the_Chamber_of_Secrets.jpg','image/jpg','b8d4653673800496aa0c4a0004406400'),(2,'2Harry_Potter_and_the_Deathly_Hallows.jpg','image/jpg','de1b39063e17274116d7ed9f56c27f36'),(3,'3Harry_Potter_and_the_Goblet_of_Fire.jpg','image/jpg','9b00a9ae0bc2d9eca3d0812a5b2b1566'),(5,'5Harry_Potter_and_the_Order_of_the_Phoenix.jpg','image/jpg','525bb031a78c341c3401af370b1673f1'),(6,'6Harry_Potter_and_the_Philosophers_Stone.jpg','image/jpg','55d46823fcb7cf479d4c3eeb2540b9f3'),(7,'7Harry_Potter_and_the_Prisoner_of_Azkaban.jpg','image/jpg','6178a9ff1897e6586eef40afc13a4674');
/*!40000 ALTER TABLE `covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genres_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (5,'Драма'),(4,'Комедия'),(2,'Путешествие'),(3,'Роман'),(1,'Фэнтези');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `text` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,7,2,5,'Очень хорошая книга!','2024-06-13 15:59:30'),(2,7,4,3,'Средняя книга(','2024-06-13 17:34:32'),(3,5,4,4,'Хорошая книга','2024-06-13 17:35:28');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','administrator'),(2,'moder','moderator'),(3,'user','user');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'admin','scrypt:32768:8:1$hPzqrbvqbgiYdZLT$8fb1f456f16c43cbe4c3f6686ec7c4fd231a325bd0e6f08f1a82c2a8943f060f7693833113c6e621b3157939efaff695bdf604dc3ac442f146c41be2d8112bef','Иванов','Иван','Иванович',1),(3,'moder','scrypt:32768:8:1$MoqBOD7SBVVOJwZh$ed9b6c8403f6367b85352a5f54e69631b6eb428f6a1aaf07aa350cfe4a7daaeac6c7926cd5182017549fd604bed38edc1d809624cd674c8c73eaaef722be1e44','Петров','Иван','Иванович',2),(4,'user','scrypt:32768:8:1$K4Qxzz8INTuK4wtA$cfcaf9488bb037c4ebabf7a2dbfe5df1657b7f38e84789e36fc1be1a0efa17fb863f860d2dccf7e620da6871338a2644c3f405481332043b8e81555e6465f164','Петров','Петр','Иванович',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visits`
--

DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `book_id` int(11) NOT NULL,
  `visit_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `visits_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
INSERT INTO `visits` VALUES (1,NULL,3,'2024-06-14 00:52:18'),(2,NULL,7,'2024-06-14 00:52:23'),(3,NULL,7,'2024-06-14 01:04:55'),(4,NULL,7,'2024-06-14 01:04:58'),(5,2,3,'2024-06-14 01:50:34'),(6,NULL,7,'2024-06-14 12:14:23'),(8,2,7,'2024-06-14 14:10:35'),(9,NULL,7,'2024-06-14 14:11:05'),(10,NULL,7,'2024-06-14 14:12:16'),(11,NULL,3,'2024-06-14 14:12:38'),(12,NULL,7,'2024-06-14 14:19:59'),(13,NULL,7,'2024-06-14 14:20:27'),(14,NULL,7,'2024-06-14 14:29:01'),(15,NULL,7,'2024-06-14 14:35:37'),(16,NULL,4,'2024-06-14 14:35:46');
/*!40000 ALTER TABLE `visits` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-14 22:30:55
