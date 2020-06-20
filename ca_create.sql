/* За образец взят сайт commonapp.org
 * Это платформа для подачи заявлений в американские колледжи на программу бакалавриата.
 * Абитуриент заполняет свой профиль student_profiles, результаты тестов student_test_results и продвинутые курсы advanced_courses, которые он посещал.
 * Школьная администрация имеет свой профиль school_profiles. Школьный завуч загружает файл с ведомостью успеваемости и рекомендацию councelor_evaluations.
 * Учиталя также загружают свои рекомендации teacher_evaluations.
 * Колледж заполняет свой профиль college_profiles
 * Студент подает заявление applications
 */
CREATE DATABASE commonapp;
USE commonapp;
-- Создаем и заполняем данными таблицы
-- student_profiles заполнена с помощью filldb.info, см. отдельный файл

DROP TABLE IF EXISTS student_profiles;
CREATE TABLE student_profiles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  sex CHAR(1) NOT NULL,
  birthday DATE,
  citizenship VARCHAR(130),
  address VARCHAR(255)
  email VARCHAR(100) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);  
DESC student_profiles;

SELECT * FROM student_profiles;

-- добавим еще столбец в таблицу

ALTER TABLE student_profiles ADD COLUMN school_id INT UNSIGNED NOT NULL AFTER email;
UPDATE student_profiles SET school_id = FLOOR(1 + RAND() * 100);


-- Приводим в порядок временные метки
UPDATE student_profiles SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Поменяем тип данных пола SEX на ENUM

ALTER TABLE student_profiles MODIFY COLUMN sex ENUM('m', 'w') NOT NULL;


-- Таблица предметов advanced
DROP TABLE IF EXISTS advanced_courses;
CREATE TABLE advanced_courses (
  id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
);

INSERT INTO advanced_courses VALUES ('algebra'), ('geometry'), ('informatics'), ('physics'), ('astronomy'), ('chemistry'), ('biology'), 
('english language'), ('literature'), ('history');

SELECT * FROM advanced_courses;

-- Таблица уровней предметов
DROP TABLE IF EXISTS adv_course_levels;
CREATE TABLE adv_course_levels (
  id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
);

INSERT INTO adv_course_levels VALUES ('advanced'), ('college_level');

SELECT * FROM adv_course_levels;

-- таблица связки студента, курса и уровня , заполнена filldb (отдельный файл)

DROP TABLE IF EXISTS student_courses;
CREATE TABLE student_courses (
  adv_courses_id TINYINT  UNSIGNED NOT NULL,
  course_level_id TINYINT UNSIGNED UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (adv_courses_id, course_level_id, student_id)
);

DESC student_courses ;
SELECT * FROM student_courses;


-- таблица школ, заполнена filldb (отдельный файл)

DROP TABLE IF EXISTS school_profiles;
CREATE TABLE school_profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  school_councelor_name VARCHAR(100) NOT NULL,
  school_info TEXT DEFAULT NULL
); 

ALTER TABLE school_profiles RENAME COLUMN school_counceler_name TO school_councelor_name;

-- поле school_info
-- Создаём временную таблицу форматов файла school_info
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('pdf');

-- Проверяем
SELECT * FROM extensions;

-- Обновляем ссылку на файл
UPDATE school_profiles SET school_info = CONCAT('https://dropbox/ca/',
  school_info,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

DESC school_profiles ;
SELECT * FROM school_profiles;

-- таблица рекомендаций завуча, заполнена filldb (отдельный файл)


DROP TABLE IF EXISTS councelor_evaluations;
CREATE TABLE councelor_evaluations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  school_id INT UNSIGNED NOT NULL,
  student_id INT UNSIGNED NOT NULL,
  grades TEXT DEFAULT NULL,
  evaluation TEXT DEFAULT NULL
); 
DESC councelor_evaluations;
SELECT * FROM councelor_evaluations;

-- привести тип данных в соответствие с таблицей student_profiles

ALTER TABLE councelor_evaluations MODIFY COLUMN student_id BIGINT UNSIGNED NOT NULL;

-- нужно привести в соответствие student_id и school_id
UPDATE councelor_evaluations
        INNER JOIN student_profiles ON student_profiles.id = councelor_evaluations.student_id 
SET 
    councelor_evaluations.school_id = student_profiles.school_id;
   
   
-- Обновляем ссылку на файл grades

UPDATE councelor_evaluations SET grades = CONCAT('https://dropbox/ca/',
  grades,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- Обновляем ссылку на файл evaluation

UPDATE councelor_evaluations SET evaluation = CONCAT('https://dropbox/ca/',
  evaluation,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- таблица рекомендаций учителя, заполнена filldb (отдельный файл)

DROP TABLE IF EXISTS teacher_evaluations;
CREATE TABLE teacher_evaluations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  school_id INT UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  teacher_name VARCHAR(100) NOT NULL,
  evaluation TEXT DEFAULT NULL
); 
DESC teacher_evaluations;
SELECT * FROM teacher_evaluations;

-- Обновляем ссылку на файл evaluation

UPDATE teacher_evaluations SET evaluation = CONCAT('https://dropbox/ca/',
  (SELECT LEFT(evaluation, 5)), 
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- нужно привести в соответствие student_id и school_id
UPDATE teacher_evaluations
        INNER JOIN student_profiles ON student_profiles.id = teacher_evaluations.student_id 
SET 
    teacher_evaluations.school_id = student_profiles.school_id;
   
   
-- таблица колледжей, заполнена filldb (отдельный файл)

   
DROP TABLE IF EXISTS college_profiles;
CREATE TABLE college_profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255) NOT NULL,
  admission_email VARCHAR(100) NOT NULL UNIQUE
  college_info TEXT DEFAULT NULL,
  requirements TEXT DEFAULT NULL
); 

DESC college_profiles;

SELECT * FROM college_profiles;

UPDATE college_profiles SET requirements = CONCAT('https://dropbox/ca/',
  (SELECT LEFT(requirements, 5)), 
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

UPDATE college_profiles SET college_info = CONCAT('https://dropbox/ca/',
  (SELECT LEFT(college_info, 5)), 
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);


-- таблица результатов тестов

DROP TABLE IF EXISTS student_test_results;
CREATE TABLE student_test_results ( 
 	student_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
 	sat_math_score BIGINT,
	sat_english_score SMALLINT UNSIGNED,
	sat_subject_id SMALLINT UNSIGNED,
	sat_subject_score SMALLINT UNSIGNED
  ); 
 
 SELECT * FROM student_test_results;
 DESC student_test_results ;
 
-- справочник sat subject

DROP TABLE IF EXISTS sat_subjects;
CREATE TABLE sat_subjects (
  id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE
); 
 
INSERT INTO sat_subjects(name) VALUES ('math1'),('math2'),('physics'),('chemistry'),('biology1'), ('biology2'),
('english_language'),('literature'),('history');

SELECT * FROM sat_subjects;
DESC sat_subjects; 

-- заявление, заполнено filldb

DROP TABLE IF EXISTS applications;
 CREATE TABLE applications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  student_id BIGINT UNSIGNED NOT NULL,
  college_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  sent_at DATETIME DEFAULT NULL,
  status tinyint(1) DEFAULT NULL
); 

DESC applications;
-- ставим sent_at = NULL там где статус = 0, те заявление не подано
UPDATE applications SET sent_at = NULL WHERE status = 0;

-- Приводим в порядок временные метки
UPDATE applications SET sent_at = CURRENT_TIMESTAMP WHERE created_at > sent_at;


SELECT * FROM applications;


SHOW tables;





