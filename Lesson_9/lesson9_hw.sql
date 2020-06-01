-- Практическое задание по теме “Транзакции, переменные, представления”
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE shop.users.id = 1;
DELETE FROM shop.users WHERE shop.users.id = 1;
COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

DROP VIEW IF EXISTS prod_cat;
CREATE VIEW prod_cat AS 
SELECT p.name, c.name FROM catalogs c
JOIN products p 
ON c.id = p.catalog_id;

-- 3. по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

CREATE TABLE all_month (date DATE);
INSERT INTO all_month VALUES ('2018-08-01'), ('2016-08-02'), ('2016-08-02'), ('2016-08-03'),  ('2016-08-04'), ('2016-08-05'), 
('2016-08-06'), ('2016-08-07'), ('2016-08-08'), ('2016-08-09'), ('2016-08-10'), ('2016-08-11'), ('2016-08-12'), ('2016-08-13'), 
('2016-08-14'), ('2016-08-15'), ('2016-08-16'), ('2016-08-17'), ('2016-08-18'), ('2016-08-19'), ('2016-08-20'), ('2016-08-21'), 
('2016-08-22'), ('2016-08-23'), ('2016-08-24'), ('2016-08-25'), ('2016-08-26'), ('2016-08-27'), ('2018-08-28'), ('2018-08-29'),
('2016-08-30'), ('2016-08-31');

CREATE TABLE days (day DATE);
INSERT INTO days VALUES ('2018-08-01'), ('2016-08-04'), ('2016-08-16'), ('2016-08-17'),  ('2016-08-20');


SELECT all_month.date, 
	IF (all_month.date IN (SELECT * FROM days), 1, 0) 
	AS num FROM all_month;

-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
DROP TABLE IF EXISTS days1;
CREATE TABLE days1 (created_at DATE);
INSERT INTO days1 VALUES ('2018-08-01'), ('2016-08-04'), ('2016-08-16'), ('2016-08-17'),  ('2016-08-20'), ('2016-08-05');

DROP TABLE IF EXISTS last_5;
CREATE TEMPORARY TABLE last_5 (date DATE);
INSERT INTO last_5 SELECT * FROM days1 ORDER BY created_at DESC LIMIT 5;

SELECT date FROM last_5;

DELETE FROM days1 WHERE created_at IN (SELECT date FROM last_5);

SELECT * FROM days1;


-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".



USE vk;
DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS TINYTEXT NO SQL
BEGIN
   DECLARE hour TIME DEFAULT HOUR(NOW());
   IF hour >= 6 AND hour < 12 
  	THEN RETURN 'Доброе утро';
   ELSEIF hour >= 12 AND hour < 18 
  	THEN RETURN 'Добрый день';
   ELSEIF hour >= 18 AND hour <= 23 
  	THEN RETURN 'Добрый вечер';
   ELSE RETURN 'Доброй ночи';
    END IF;
END//
DELIMITER ;
SELECT hello();

SELECT NOW(), hello ();



-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.


DELIMITER //

CREATE TRIGGER check_name_desc_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
 IF NEW.name IS NULL AND NEW.description IS null THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'both NULL, operation canceled';
END//

   
CREATE TRIGGER check_name_desc_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
 IF NEW.name IS NULL AND NEW.description IS null THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'both NULL, operation canceled';
END//

DELIMITER ;



