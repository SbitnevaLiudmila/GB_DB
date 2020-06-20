DROP VIEW IF EXISTS college_applicants_sorted;
CREATE VIEW college_applicants_sorted 
AS SELECT DISTINCT sp.first_name, sp.last_name, sp.sex, sp.birthday, sp.email 
FROM student_profiles sp
JOIN applications a
ON sp.id = a.student_id WHERE a.college_id = 4 ORDER BY sp.first_name;

DROP VIEW IF EXISTS all_students_sorted_by_sat ;
CREATE VIEW all_students_sorted_by_sat 
AS
SELECT sp.first_name, sp.last_name, str.sat_math_score, str.sat_english_score, ss.name, str.sat_subject_score, 
str.sat_math_score+str.sat_english_score+str.sat_subject_score as total_sat
FROM student_profiles sp 
JOIN student_test_results str
ON sp.id = str.student_id 
JOIN sat_subjects ss
ON ss.id = str.sat_subject_id ORDER BY total_sat DESC;

show tables;

SELECT * FROM all_students_sorted_by_sat;

SELECT * FROM college_applicants_sorted ;

DESC college_applicants_sorted ;