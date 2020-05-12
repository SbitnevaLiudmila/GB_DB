Задание 1.

Выполнено:
desc users;
SELECT * FROM users LIMIT 10;
ALTER TABLE profiles DROP COLUMN created_at;
SELECT * FROM profiles LIMIT 10;
ALTER TABLE profiles ADD photo_id INT UNSIGNED AFTER user_id;

CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
);
INSERT user_statuses (id, name)
VALUES
  (1, 'active'),
  (2, 'blocked'),
  (3, 'deleted');
ALTER TABLE users ADD status_id INT UNSIGNED NOT NULL DEFAULT 1 AFTER phone;

ALTER TABLE profiles ADD is_private BOOLEAN DEFAULT FALSE AFTER country;


UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

UPDATE users SET status_id = FLOOR(1+RAND()*3);


SHOW TABLES;

-- Анализируем данные пользователей
SELECT * FROM users LIMIT 10;

-- Смотрим структуру таблицы пользователей
DESC users;

-- Приводим в порядок временные метки
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

SELECT * FROM users LIMIT 10;

-- Смотрим структуру профилей
DESC profiles;

-- Анализируем данные
SELECT * FROM profiles LIMIT 10;

-- Смотрим структуру таблицы профилей
DESC profiles;

-- Добавляем ссылки на фото
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);

-- Поправим столбец пола
-- Создаём временную таблицу значений для пола
CREATE TEMPORARY TABLE genders (name CHAR(1));

-- Заполняем значениями
INSERT INTO genders VALUES ('m'), ('w');

-- Проверяем
SELECT * FROM genders;

-- Обновляем пол
UPDATE profiles 
  SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
  
-- Проставляем приватность
UPDATE profiles SET is_private = TRUE WHERE user_id > FLOOR(1 + RAND() * 100); 

SELECT * FROM profiles LIMIT 100;

-- Все таблицы
SHOW TABLES;

-- Смотрим структуру таблицы сообщений
DESC messages;

-- Анализируем данные
SELECT * FROM messages LIMIT 10;

-- Обновляем значения ссылок на отправителя и получателя сообщения
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);

-- Смотрим структуру таблицы медиаконтента 
DESC media;

-- Анализируем данные
SELECT * FROM media LIMIT 10;

-- Анализируем типы медиаконтента
SELECT * FROM media_types;

TRUNCATE media_types;

INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

SELECT * FROM media_types;

-- Анализируем данные
SELECT * FROM media LIMIT 10;

-- Обновляем данные для ссылки на тип и владельца
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- Создаём временную таблицу форматов медиафайлов
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

-- Проверяем
SELECT * FROM extensions;

-- Обновляем ссылку на файл
UPDATE media SET filename = CONCAT('https://dropbox/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- Обновляем размер файлов
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

SELECT * FROM media LIMIT 10;

-- Заполняем метаданные
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  
DESC media;
-- Возвращаем столбцу метеданных правильный тип
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- Смотрим структуру таблицы дружбы
DESC friendship;

-- Анализируем данные
SELECT * FROM friendship LIMIT 10;

-- Обновляем ссылки на друзей
UPDATE friendship SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);
 
-- Анализируем данные 
SELECT * FROM friendship_statuses;

-- Очищаем таблицу
TRUNCATE friendship_statuses;

-- Вставляем значения статусов дружбы
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
 
-- Обновляем ссылки на статус 
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 

-- Смотрим структуру таблицы групп
DESC communities;

-- Анализируем данные
SELECT * FROM communities;

-- Оставим только 20 групп
DELETE FROM communities WHERE id > 25;

-- Анализируем таблицу связи пользователей и групп
SELECT * FROM communities_users;

UPDATE communities_users SET user_id = FLOOR(1 + RAND() * 100);

UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 25);

