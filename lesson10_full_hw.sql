-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
-- индексы с занятия
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE UNIQUE INDEX users_email_uq ON users(email);

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- домашнее задание

CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);
 
CREATE INDEX communities_name_idx ON communities(name);
 
CREATE INDEX friendship_status_id_idx ON friendship(status_id);
-- не нужно, так как это внешний ключ, на него автоматом делается индекс
-- удалить нельзя тоже его
DROP INDEX friendship_status_id_idx ON friendship;

CREATE INDEX friendship_user_id_friend_id_idx ON friendship(user_id, friend_id);

CREATE INDEX posts_head_idx ON posts(head);
 
CREATE INDEX posts_created_at_idx ON posts(created_at);

CREATE INDEX likes_user_id_target_id_idx ON likes(user_id, target_id);

CREATE INDEX media_user_id_media_type_id_idx ON media(user_id, media_type_id);


/*2 . Задание на оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы
среднее количество пользователей в группах
самый молодой пользователь в группе
самый старший пользователь в группе
общее количество пользователей в группе
всего пользователей в системе
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100 */

/*По оконным функциям - хорошо, но есть и недоработки:
1. В total_users не будут учтены пользователи, которые не входят в группы.
2. В отчёт не попадут группы без пользователей.  мой коммент: не может быть групп без пользователей, так как в таблице comm_users оба поля первичные ключи */

SELECT DISTINCT communities.name AS group_name,
COUNT(communities_users.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
MAX(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS youngest,
MIN(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS oldest,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) AS users_in_group,
(SELECT COUNT(profiles.user_id) FROM profiles) AS total_users,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) / (SELECT COUNT(profiles.user_id) FROM profiles)* 100 AS "%%",
(SELECT communities.name from communities where not exists (select 1 from communities_users where communities_users.community_id = communities.id)) as empty_group
FROM communities_users 
      JOIN communities
        ON communities.id = communities_users.community_id
     right JOIN profiles 
       	ON communities_users.user_id = profiles.user_id;
       
       
-- Выведите все группы а не пользователей, сделайте самой левой или самой правой таблицу групп, а количество пользователей в системе считайте вложенным запросом.

SELECT DISTINCT communities.name AS group_name,
COUNT(communities_users.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
MAX(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS youngest,
MIN(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS oldest,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) AS users_in_group,
(SELECT COUNT(profiles.user_id) FROM profiles) AS total_users,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) / (SELECT COUNT(profiles.user_id) FROM profiles)* 100 AS "%%"
FROM communities 
     LEFT JOIN communities_users
        ON communities.id = communities_users.community_id
     LEFT JOIN profiles 
       	ON communities_users.user_id = profiles.user_id;
       
 -- FULL OUTER JOIN
 
SELECT DISTINCT communities.name AS group_name, 
COUNT(communities_users.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
MAX(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS youngest,
MIN(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS oldest,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) AS users_in_group,
(SELECT COUNT(profiles.user_id) FROM profiles) AS total_users,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) / (SELECT COUNT(profiles.user_id) FROM profiles)* 100 AS "%%"
FROM communities_users 
     RIGHT JOIN communities
        ON communities.id = communities_users.community_id
     RIGHT JOIN profiles 
       	ON communities_users.user_id = profiles.user_id    
UNION
SELECT DISTINCT communities.name AS group_name, 
COUNT(communities_users.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
MAX(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS youngest,
MIN(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS oldest,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) AS users_in_group,
(SELECT COUNT(profiles.user_id) FROM profiles) AS total_users,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) / (SELECT COUNT(profiles.user_id) FROM profiles)* 100 AS "%%"
FROM communities_users 
     RIGHT JOIN communities
        ON communities.id = communities_users.community_id
     LEFT JOIN profiles 
       	ON communities_users.user_id = profiles.user_id;


       
select * from communities_users;
select * FROM communities;
select DISTINCT user_id FROM communities_users;



DESC communities;

DELETE FROM communities_users WHERE community_id = 1;
DELETE FROM communities_users WHERE community_id = 10;
INSERT INTO communities_users VALUES (1,8);



-- нельзя, так как это первичный ключ он нот налл

alter table communities_users modify column user_id int unsigned;
UPDATE communities_users SET user_id=NULL WHERE dept='IT';

-- проверочный запрос среднее количество пользователей в группах
SELECT AVG(_users) AS average_users 
	FROM (SELECT COUNT(communities_users.user_id) as _users 
FROM communities_users 
      JOIN communities
        ON communities.id = communities_users.community_id
group by communities_users.community_id order by communities_users.community_id)
	 AS _total;

-- проверочный запрос
SELECT DISTINCT communities.name AS group_name, 
(select COUNT(user_id)from communities_users) / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
FROM communities; 

