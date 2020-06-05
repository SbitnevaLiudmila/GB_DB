/*Практическое задание по теме “Оптимизация запросов”
Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.*/

	DROP TABLE IF EXISTS logs;
 	CREATE TABLE logs (
 	id serial,
 	created_at DATETIME,
 	table_name VARCHAR(255),
 	pr_key_id VARCHAR(255),
 	name VARCHAR(255)
 	)  ENGINE=ARCHIVE COMMENT = 'Таблица логов';
 	 

 	-- создадим триггеры 
 	 
 	DELIMITER //
 	DROP TRIGGER IF EXISTS logs_users //
 	CREATE TRIGGER logs_users AFTER INSERT ON users
 	FOR EACH ROW
 	BEGIN
 	INSERT INTO logs (created_at, table_name, pr_key_id, name)
 	VALUES (NOW(),'users', new.id, new.name);
 	END//
 	DELIMITER ; 
 
 	DELIMITER //
 	DROP TRIGGER IF EXISTS logs_catalogs //
 	CREATE TRIGGER logs_catalogs AFTER INSERT ON catalogs
 	FOR EACH ROW
 	BEGIN
 	INSERT INTO logs (created_at, table_name, pr_key_id, name)
 	VALUES (NOW(),'catalogs', new.id, new.name);
 	END//
 	DELIMITER; 
 	 
 	DELIMITER //
 	DROP TRIGGER IF EXISTS logs_products //
 	CREATE TRIGGER logs_products AFTER INSERT ON products
 	FOR EACH ROW
 	BEGIN
 	INSERT INTO logs (created_at, table_name, pr_key_id, name)
 	VALUES (NOW(),'products', new.id, new.name);
 	END//
	DELIMITER ;




-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- сделала в виде цикла

	DELIMITER //
 	DROP PROCEDURE IF EXISTS filling_users //
 	CREATE PROCEDURE filling_users(num_of_lines int)
 	BEGIN
 	DECLARE i INT DEFAULT 1;
 	WHILE i <= num_of_lines DO
 	INSERT INTO users (id, name, birthday_at) values (NULL,'user_name', NOW());
 	SET i = i + 1;
 	END WHILE;
 	END//
 	 
 	CALL filling_users(1000) -- поставила меньше, так как не дождалась выполнения миллиона своем ноуте
 	
 	-- можно вставлять частями одним insert, так быстрее будет вставлять теоретически, практически миллион у меня не вставляется
 	-- filldb быстрее, но тоже долго и лучше частями, 
 	-- расскажите, пожалуйста, как это можно быстро сделать?
 	
 	DELIMITER //
 	DROP PROCEDURE IF EXISTS filling_users_parts //
 	CREATE PROCEDURE filling_users_parts(num_of_lines int)
 	BEGIN
 	DECLARE i INT DEFAULT 1;
 	WHILE i <= num_of_lines DO
 	INSERT INTO users (id, name, birthday_at) VALUES 
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()),
			(NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW()), (NULL,'user_name', NOW());
 	SET i = i + 1;
 	END WHILE;
 	END//
 	
 	
 -- проверка 
 SELECT COUNT(*) from users;




/*Практическое задание по теме “NoSQL”

В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.*/

-- воспользуемся типом данных отсортированное множества ZSETS, удобно, что повторения не сохраняются,
-- в то время как любые несколько объектов могут иметь одинаковый счетчик. 
-- так же быстро можно осуществлять поиск, тк список хранится отсортированным и обрабатывать данные с помощью ZRANGE, ZCOUNT

ZSET ip_visited 101.0.0.1 0

-- когда заходит пользователь, счетчик  +1:

ZINCRBY ip_visited 101.0.0.1 1


/*2) При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

-- создать "зеркальные" пары 
-- возможно, что как-то можно индексировать поля в redis?  */

SET user1 user1@gmail.com

SET user1@mail.ru user1

-- тогда 
GET user1@mail.ru
GET user1

-- 3) Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
-- так как в монго объект - это документ, думаю, что нужно справочную таблицу catalogs объединить с products

db.shop.insert ({name: 'AMD FX-8', description:'Процессор Intel.', price: 10000, catalog_name: 'Процессоры', created_at: new Date(), uppdated_at: new Date()})


