+-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 12, 2025 at 06:12 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movie_booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `img` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `name`, `price`, `img`) VALUES
(1, 'Avengers: Endgame', 10, 'https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_SL1500_.jpg'),
(2, 'Spider-Man: No Way Home', 12, 'https://images-cdn.ubuy.co.in/6502d8fad41d96757f66f08e-hukobj-superhero-spiderman-no-way-home.jpg'),
(3, 'Inception', 8, 'https://m.media-amazon.com/images/I/51zUbui+gbL.jpg'),
(4, 'Titanic', 5, 'https://m.media-amazon.com/images/I/71joD2fGdqL._AC_UF350,350_QL80_.jpg'),
(5, 'The Dark Knight', 9, 'https://m.media-amazon.com/images/I/41CRfXsE8SL._AC_UF894,1000_QL80_.jpg'),
(6, 'Interstellar', 11, 'https://m.media-amazon.com/images/I/91kFYg4fX3L._SL1500_.jpg'),
(7, 'Avatar', 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvFYVLuiIBc4dsClr-vSbRzchtKZKgy7s_cQ&s'),
(8, 'Jurassic World', 8, 'https://www.tallengestore.com/cdn/shop/products/JurassicWorld-HollywoodDinosaurMoviePoster_54ab14dd-84de-4947-a723-25be2dd46c69.jpg?v=1648215570'),
(9, 'Black Panther', 10, 'https://www.motionpictures.org/wp-content/uploads/2017/12/blackpanther.jpg'),
(10, 'Iron Man', 9, 'https://m.media-amazon.com/images/I/61SxqSs6f8L._AC_UF894,1000_QL80_.jpg'),
(11, 'Doctor Strange', 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7002Av-uZ_2RVXAFEYpTu60zi7V6fvykMdA&s'),
(12, 'Deadpool', 8, 'https://www.tallengestore.com/cdn/shop/products/Movie_Poster_Art_-_Deadpool_-_New_Face_Of_Justice_-_Tallenge_Hollywood_Poster_Collection_e2bb3bf6-2f8a-47d5-b7b6-08030964947d.jpg?v=1578044953'),
(13, 'John Wick', 9, 'https://www.tallengestore.com/cdn/shop/products/JohnWick-KeanuReeves-HollywoodEnglishActionMoviePoster-2_d2e65a82-e8e1-46f9-b5f0-7cbd47c1747c.jpg?v=1649071605'),
(14, 'Fast & Furious 7', 8, 'https://www.tallengestore.com/cdn/shop/products/Fast_Furious_7_-_Paul_Walker_-_Vin_Diesel_-_Dwayne_Johnson_-_Tallenge_Hollywood_Action_Movie_Poster_4db39f52-8057-4dac-a779-596841a0ef9a.jpg?v=1582543253'),
(15, 'The Matrix', 7, 'https://m.media-amazon.com/images/I/51EG732BV3L.jpg'),
(16, 'Joker', 10, 'https://m.media-amazon.com/images/I/81vRg6RVaFL.jpg'),
(17, 'Dune', 12, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVhz6N7qAjv9PSoHvnDSi1NE8GQX5LE-zNIw&s'),
(18, 'Oppenheimer', 14, 'https://www.tallengestore.com/cdn/shop/products/Oppenheimer-CillianMurphy-ChristopherNolan-HollywoodMoviePoster_1_f2b4d54a-6a90-4df1-b2e8-5cd7949d4c2c.jpg?v=1647424460'),
(19, 'The Batman', 12, 'https://images-cdn.ubuy.co.in/68901f6ae49b8c404602f009-the-batman-movie-poster-glossy-quality.jpg'),
(20, 'Frozen II', 7, 'https://images-cdn.ubuy.co.in/634ef4cdc7c4ff7d5a15db16-frozen-2-2019-movie-poster-reprint.jpg'),
(21, 'Minions: Rise of Gru', 6, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9caKwE-w7Iya3Thph-ln6HqLpz-vzYAuA0A&s'),
(22, 'The Lion King', 8, 'https://m.media-amazon.com/images/I/7148fvlOyOL._AC_UF894,1000_QL80_.jpg\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `seats`
--

CREATE TABLE `seats` (
  `id` int(11) NOT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `seat_number` int(11) DEFAULT NULL,
  `is_booked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `seats`
--

INSERT INTO `seats` (`id`, `movie_id`, `seat_number`, `is_booked`) VALUES
(1, 1, 1, 0),
(2, 2, 1, 0),
(3, 3, 1, 0),
(4, 4, 1, 0),
(5, 1, 2, 0),
(6, 2, 2, 0),
(7, 3, 2, 0),
(8, 4, 2, 0),
(9, 1, 3, 0),
(10, 2, 3, 1),
(11, 3, 3, 0),
(12, 4, 3, 0),
(13, 1, 4, 0),
(14, 2, 4, 0),
(15, 3, 4, 0),
(16, 4, 4, 0),
(17, 1, 5, 0),
(18, 2, 5, 0),
(19, 3, 5, 0),
(20, 4, 5, 0),
(21, 1, 6, 0),
(22, 2, 6, 0),
(23, 3, 6, 0),
(24, 4, 6, 0),
(25, 1, 7, 1),
(26, 2, 7, 0),
(27, 3, 7, 0),
(28, 4, 7, 0),
(29, 1, 8, 0),
(30, 2, 8, 0),
(31, 3, 8, 1),
(32, 4, 8, 0),
(33, 1, 9, 0),
(34, 2, 9, 1),
(35, 3, 9, 0),
(36, 4, 9, 0),
(37, 1, 10, 0),
(38, 2, 10, 0),
(39, 3, 10, 0),
(40, 4, 10, 0),
(41, 1, 11, 0),
(42, 2, 11, 0),
(43, 3, 11, 0),
(44, 4, 11, 0),
(45, 1, 12, 0),
(46, 2, 12, 0),
(47, 3, 12, 0),
(48, 4, 12, 0),
(49, 1, 13, 0),
(50, 2, 13, 0),
(51, 3, 13, 0),
(52, 4, 13, 0),
(53, 1, 14, 0),
(54, 2, 14, 0),
(55, 3, 14, 0),
(56, 4, 14, 0),
(57, 1, 15, 0),
(58, 2, 15, 0),
(59, 3, 15, 0),
(60, 4, 15, 0),
(61, 1, 16, 0),
(62, 2, 16, 0),
(63, 3, 16, 0),
(64, 4, 16, 0),
(65, 1, 17, 1),
(66, 2, 17, 0),
(67, 3, 17, 0),
(68, 4, 17, 0),
(69, 1, 18, 0),
(70, 2, 18, 0),
(71, 3, 18, 0),
(72, 4, 18, 0),
(73, 1, 19, 0),
(74, 2, 19, 0),
(75, 3, 19, 1),
(76, 4, 19, 0),
(77, 1, 20, 0),
(78, 2, 20, 0),
(79, 3, 20, 0),
(80, 4, 20, 0),
(81, 1, 21, 1),
(82, 2, 21, 0),
(83, 3, 21, 0),
(84, 4, 21, 0),
(85, 1, 22, 0),
(86, 2, 22, 0),
(87, 3, 22, 0),
(88, 4, 22, 0),
(89, 1, 23, 0),
(90, 2, 23, 0),
(91, 3, 23, 0),
(92, 4, 23, 0),
(93, 1, 24, 0),
(94, 2, 24, 0),
(95, 3, 24, 0),
(96, 4, 24, 0),
(97, 1, 25, 0),
(98, 2, 25, 0),
(99, 3, 25, 0),
(100, 4, 25, 0),
(101, 1, 26, 0),
(102, 2, 26, 0),
(103, 3, 26, 0),
(104, 4, 26, 0),
(105, 1, 27, 0),
(106, 2, 27, 0),
(107, 3, 27, 0),
(108, 4, 27, 0),
(109, 1, 28, 0),
(110, 2, 28, 0),
(111, 3, 28, 0),
(112, 4, 28, 0),
(113, 1, 29, 0),
(114, 2, 29, 0),
(115, 3, 29, 0),
(116, 4, 29, 0),
(117, 1, 30, 0),
(118, 2, 30, 0),
(119, 3, 30, 0),
(120, 4, 30, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`) VALUES
(1, 'Jeet', 'ranpariyajeet91@gmail.com', 'scrypt:32768:8:1$zkyd121E0ECVrZ3Y$9a287eb3d6eefff37c843c5461fdcf95e540b53697343a083aab21be170692e639c6777c32b01b14a8f0866eb926ab03810d25029e3fbfd6ec86a9709a86fe53', '8320025800');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `seats`
--
ALTER TABLE `seats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `seats`
--
ALTER TABLE `seats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `seats`
--
ALTER TABLE `seats`
  ADD CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
