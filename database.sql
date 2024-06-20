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
INSERT INTO `alembic_version` VALUES ('6005cf7cbb65');
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
INSERT INTO `book_genres` VALUES (3,1),(5,1),(19,1),(30,1),(31,1),(32,1),(33,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (3,'Гарри Поттер и узник Азкабана','Начало нового учебного года оказывается не слишком удачным для Гарри Поттера. Семейство Дурслей, как всегда, игнорирует день рождение главного героя и ему приходится отмечать его в одиночестве. По пути в Хогвартс Гарри становится известно, что из особой тюрьмы, где находятся волшебники-преступники, сбежал Сириус Блэк. До этого момента никому еще не удавалось совершить побег из Азкабана, но Сириус смог это каким-то образом сделать. Гарри рассказывают, что теперь этот преступник начал разыскивать именно его…',1999,'Росмэн','Дж. К. Роулинг',512,7),(5,'Гарри Поттер и Орден Феникса','Как всегда, под конец каникул у Гарри возникли проблемы, и на этот раз он был просто вынужден использовать свои магические способности. Когда Гарри ругался со своим кузеном их атаковали дементоры, один из которых был чуть не съел душу Дадли. Ценой огромных усилий Гарри удалось выгнать страшных созданий, но сразу же пришло письмо из Министерства о том, что Гарри оказывается претендентом на исключение из школы волшебства с дальнейшим уничтожением его волшебной палочки. Однако это не самая большая неприятность в жизни главного героя. К Гарри приходят представители Ордена Феникса, который был создан для борьбы с последователями лорда Волан-де-Морта. Вскоре Гарри с товарищами организовывают Отряд Дамблдора, который является союзником Ордена в нелегкой борьбе с темными волшебниками…',2003,'Росмэн','Дж. К. Роулинг',832,5),(19,'Гарри Поттер и Принц-полукровка','Директор школы Альбус Дамблдор рассказывает Гарри о крестражах – магических артефактах, в которые Волан-де-Морт вложил частички своей души. Вместе с профессором юный волшебник начинает погружаться в прошлое Тёмного Лорда. В воспоминаниях о его юности Гарри надеется отыскать ключ к победе над злом.\n\nТем временем учёба в Хогвартсе продолжается, и в руки Поттера попадает старый учебник по зельеварению. В нём – подпись некого Принца-Полукровки и ряд неизвестных заклинаний. Скоро волшебнику предстоит узнать, кто скрывается под этим именем, и стать свидетелем трагического убийства.',2005,'Росмэн','Дж. К. Роулинг',685,15),(30,'Гарри Поттер и философский камень','В первой книге о Гарри Поттере читатели знакомятся с главным героем, который в это время проживает в семье Дурслей. Его опекуны всеми силами стараются оградить его от магии, хотя сам Гарри все чаще замечает проявления своих необычных магических способностей. В итоге в какой-то момент за юным волшебником прибывает Хагрид — лесничий магической школы Хогвартс. Он раскрывает Гарри всю правду о его родителях и считает, что ему следует отправиться на обучение в Хогвартс. По пути туда будущий великий волшебник знакомится с Роном и Гермионой, которые станут его самыми близкими друзьями и участниками грядущих приключений…',1997,'Росмэн','Дж. К. Роулинг',400,23),(31,'Гарри Поттер и Тайная комната','Наступили летние каникулы и Гарри стало казаться, что все о нём забыли. От Рона и Гермионы не приходит ни весточки, а эльф Добби постоянно пугает мальчика об опасности школы волшебства и не советует туда возвращаться. Но Гарри не боится и наоборот по возвращении в магическую школу наконец обретает чувство, что он снова дома. Его ожидают новые приключения и опасные передряги, ведь именно в это время он узнает о легенде про тайную комнату, которую способен открыть лишь избранный. Получится ли у Гарри и его друзей найти эту комнату и избавить Хогвартс от страшного монстра?',1998,'Росмэн','Дж. К. Роулинг',480,24),(32,'Гарри Поттер и Кубок огня','Снова летние каникулы завершаются, и Гарри с Роном направляются в Хогвартс, чтобы продолжить обучение. Этот школьный год ознаменован необычным событием — Турниром Трех Волшебников, который ожидают многие. Несколько лет это соревнование не проводилось, поскольку оно слишком опасно. Неоднократно случались трагедии, когда чемпионы погибали во время выполнения заданий. Теперь в Турнире могут участвовать лишь кандидаты возрастом не младше 17 лет. Однако выясняется, что Кубок Огня выбирает Гарри для участия, хотя ему исполнилось лишь четырнадцать…',2000,'Росмэн','Дж. К. Роулинг',667,25),(33,'Гарри Поттер и Дары Смерти','<p>Теперь ни у кого нет сомнений в том, что Гарри Поттеру было суждено стать легендарным волшебником. Длинный список его опасных приключений регулярно пополняется. На счету Гарри много успехов не только в магических турнирах, но и в реальных сражениях с более сильными и опытными врагами. Однако самая важная битва в жизни Гарри еще впереди. Могущество Волан-де-Морта неустанно растет и даже думать страшно, чем это может обернуться для магического мира, если Гарри не победит Темного Лорда… Но в этот раз Гарри будет вынужден полагаться лишь на свои силы.</p>',2007,'Росмэн','Дж. К. Роулинг',640,2);
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
  `file_name` varchar(128) DEFAULT NULL,
  `mime_type` varchar(128) DEFAULT NULL,
  `md5_hash` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `covers`
--

LOCK TABLES `covers` WRITE;
/*!40000 ALTER TABLE `covers` DISABLE KEYS */;
INSERT INTO `covers` VALUES (2,'2Harry_Potter_and_the_Deathly_Hallows.jpg','image/jpg','de1b39063e17274116d7ed9f56c27f36'),(5,'5Harry_Potter_and_the_Order_of_the_Phoenix.jpg','image/jpg','525bb031a78c341c3401af370b1673f1'),(7,'7Harry_Potter_and_the_Prisoner_of_Azkaban.jpg','image/jpg','6178a9ff1897e6586eef40afc13a4674'),(15,'11_10_Harry_Potter_and_the_Half-Blood_Prince.jpg','image/jpeg','8426180ee3ed1f8f10424c276aff0988'),(23,'22_Harry_Potter_and_the_Philosophers_Stone.jpg','image/jpeg','55d46823fcb7cf479d4c3eeb2540b9f3'),(24,'18_Harry_Potter_and_the_Chamber_of_Secrets.jpg','image/jpeg','b8d4653673800496aa0c4a0004406400'),(25,'12_Harry_Potter_and_the_Goblet_of_Fire.jpg','image/jpeg','9b00a9ae0bc2d9eca3d0812a5b2b1566');
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (3,5,4,4,'Хорошая книга','2024-06-13 17:35:28'),(8,33,2,5,'Очень хорошая книга!','2024-06-15 14:39:53');
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
  KEY `fk_visits_user_id_users` (`user_id`),
  KEY `fk_visits_book_id_books` (`book_id`),
  CONSTRAINT `fk_visits_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_visits_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
INSERT INTO `visits` VALUES (1,NULL,3,'2024-06-14 00:52:18'),(5,2,3,'2024-06-14 01:50:34'),(11,NULL,3,'2024-06-14 14:12:38'),(20,NULL,5,'2024-06-15 13:16:20'),(25,2,5,'2024-06-15 13:45:07'),(26,2,5,'2024-06-15 13:45:19'),(27,2,5,'2024-06-15 13:45:27'),(28,2,5,'2024-06-15 13:45:28'),(29,2,5,'2024-06-15 13:45:35'),(30,2,5,'2024-06-15 13:45:36'),(31,2,5,'2024-06-15 13:45:48'),(32,2,5,'2024-06-15 13:46:53'),(36,2,5,'2024-06-15 13:50:04'),(37,2,5,'2024-06-15 13:53:02'),(48,2,19,'2024-06-15 14:02:04'),(60,2,30,'2024-06-15 14:19:58'),(61,2,31,'2024-06-15 14:21:05'),(62,2,32,'2024-06-15 14:22:17'),(65,2,33,'2024-06-15 14:31:37'),(66,2,33,'2024-06-15 14:32:08'),(67,2,33,'2024-06-15 14:32:20'),(69,2,33,'2024-06-15 14:32:48'),(72,2,33,'2024-06-15 14:39:01'),(73,2,33,'2024-06-15 14:39:37'),(74,2,33,'2024-06-15 14:39:42'),(75,2,33,'2024-06-15 14:39:53'),(76,2,33,'2024-06-15 14:40:39'),(77,2,33,'2024-06-15 14:40:48'),(93,2,3,'2024-06-15 14:52:13'),(94,2,32,'2024-06-15 15:07:25'),(95,2,31,'2024-06-15 15:07:30'),(99,3,33,'2024-06-15 15:13:29'),(100,NULL,33,'2024-06-15 15:13:45'),(101,4,33,'2024-06-15 15:14:06'),(102,NULL,33,'2024-06-15 15:29:55'),(110,2,33,'2024-06-19 04:11:38'),(114,2,32,'2024-06-19 10:56:12'),(115,2,19,'2024-06-19 10:56:15'),(120,2,33,'2024-06-19 16:05:23'),(121,4,19,'2024-06-19 16:08:22'),(125,2,33,'2024-06-19 18:56:07'),(126,2,33,'2024-06-19 18:56:20'),(127,2,33,'2024-06-19 18:56:24'),(128,2,33,'2024-06-19 18:56:45'),(129,2,5,'2024-06-19 18:56:49'),(130,2,5,'2024-06-19 18:57:03'),(131,2,33,'2024-06-19 18:57:09'),(133,2,33,'2024-06-19 21:34:52'),(134,2,33,'2024-06-19 21:35:07'),(135,2,31,'2024-06-19 21:50:28'),(136,2,31,'2024-06-19 21:50:48'),(189,2,30,'2024-06-19 23:38:08'),(209,2,33,'2024-06-20 00:08:49'),(213,2,30,'2024-06-20 00:10:02'),(214,2,3,'2024-06-20 00:10:10'),(215,2,33,'2024-06-20 00:12:59'),(216,2,33,'2024-06-20 00:13:06'),(217,2,33,'2024-06-20 00:13:25'),(218,2,33,'2024-06-20 00:13:32');
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

-- Dump completed on 2024-06-20  3:30:05
