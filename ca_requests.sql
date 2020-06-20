-- все дополнительные курсы конкретного ученика с уровнями
SELECT DISTINCT sp.id, sp.first_name, sp.last_name, ac.name, acl.name
FROM student_courses sc
JOIN student_profiles sp
	ON sp.id = sc.student_id
JOIN advanced_courses ac
	ON ac.id = sc.adv_courses_id 
JOIN adv_course_levels acl
	ON acl.id = sc.adv_courses_id 
	WHERE sp.id = 55;

-- процент совершеннолетних абитуриентов среди всех абитуриентов колледжа на момент подачи заявления	

SELECT DISTINCT COUNT(sp.id) / (SELECT COUNT(*) FROM applications WHERE applications.college_id = 5) *100 AS "%%"
FROM applications a
JOIN student_profiles sp
ON sp.id = a.student_id
WHERE a.college_id = 5 AND a.status = 1 AND TIMESTAMPDIFF(YEAR, sp.birthday, a.sent_at) >= 18;


-- название школы и ФИО завуча для всех абитуриентов конкретного колледжа

SELECT DISTINCT schp.name, schp.school_councelor_name 
FROM school_profiles schp
JOIN student_profiles sp
ON schp.id = sp.school_id 
JOIN applications a
ON sp.id = a.student_id 
WHERE a.college_id = 4;

-- количество студентов с проходным баллом 400 баллом str.sat_math_score > 400 по каждой школе

SELECT sp2.id, sp2.name, COUNT(sp.id)
FROM student_profiles sp 
JOIN school_profiles sp2
	ON sp.school_id = sp2.id
JOIN student_test_results str
	ON sp.id = str.student_id
WHERE str.sat_math_score > 400
GROUP BY sp2.id;

-- имя и фамилию самого юного абитуриента каждой школы
SELECT DISTINCT school_profiles.id, school_profiles.name,
	FIRST_VALUE(student_profiles.first_name) OVER w as youngest_first_name,
	FIRST_VALUE(student_profiles.last_name) OVER w as youngest_last_name
FROM school_profiles 
	LEFT JOIN student_profiles
		ON school_profiles.id = student_profiles.school_id
	WINDOW w AS(PARTITION BY school_profiles.id ORDER BY student_profiles.birthday);

-- Количество и процент абитуриентов каждой школы среди всех абитуриентов

SELECT school_profiles.id, school_profiles.name,
	COUNT(student_profiles.id), COUNT(student_profiles.id) / (SELECT COUNT(*) FROM student_profiles) * 100 AS '%%'
FROM school_profiles 
	LEFT JOIN student_profiles
		ON school_profiles.id = student_profiles.school_id
	GROUP BY school_profiles.id;

