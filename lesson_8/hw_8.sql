-- 1. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

USE vk;

DESC profiles ;

-- likes, profiles
-- left join так как у пользователей может не быть лайков

DESC likes;

-- не знаю, как еще подсчитать сумму, только через вложенный запрос получилось,
-- наверное, как-то проще можно?

SELECT SUM(likes) AS total_likes 
	FROM (SELECT count(likes.id) as likes
		FROM profiles
		LEFT JOIN likes 
		ON likes.target_id = profiles.user_id AND likes.target_type_id = 2
	group by profiles.user_id 
	ORDER BY profiles.birthday DESC
    LIMIT 10) AS total;
    
  
   
 -- 2. Определить кто больше поставил лайков (всего) - мужчины или женщины?
  SELECT p.gender, COUNT(*) AS total
  	FROM likes l
  	JOIN profiles p 
  	ON l.user_id = p.user_id 
  GROUP BY p.gender
  ORDER BY total DESC
  LIMIT 1;

    
  
-- 3. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.    
 
 SELECT users.id, CONCAT(first_name, ' ', last_name), 
 COUNT(l.id) + COUNT(p.id) + COUNT(m.id) + COUNT(messages.id) AS activity
 FROM users
 	LEFT JOIN likes l ON l.user_id = users.id
 	LEFT JOIN posts p ON p.user_id = users.id
 	LEFT JOIN media m ON m.user_id = users.id
 	LEFT JOIN messages ON messages.from_user_id = users.id
 GROUP BY users.id
 ORDER BY activity
 LIMIT 10;
 


 