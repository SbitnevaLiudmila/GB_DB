-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
-- индексы с занятия
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE UNIQUE INDEX users_email_uq ON users(email);

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- домашнее задание

CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);
 
CREATE INDEX communities_name_idx ON communities(name);
 
CREATE INDEX friendship_status_id_idx ON friendship(status_id);
 
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


SELECT DISTINCT communities.name AS group_name, 
COUNT(communities_users.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities) AS av_users_in_groups,
MAX(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS youngest,
MIN(profiles.birthday) OVER(PARTITION BY communities_users.community_id) AS oldest,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) AS users_in_group,
COUNT(profiles.user_id) OVER () AS total_users,
COUNT(communities_users.user_id) OVER(PARTITION BY communities_users.community_id) / COUNT(profiles.user_id) OVER ()* 100 AS "%%"
FROM communities_users 
      JOIN communities
        ON communities.id = communities_users.community_id
      JOIN profiles 
       	ON communities_users.user_id = profiles.user_id;


  
 
-- проверочный запрос среднее количество пользователей в группах
SELECT AVG(_users) AS average_users 
	FROM (SELECT COUNT(communities_users.user_id) as _users 
FROM communities_users 
      JOIN communities
        ON communities.id = communities_users.community_id
group by communities_users.community_id order by communities_users.community_id)
	 AS _total;

