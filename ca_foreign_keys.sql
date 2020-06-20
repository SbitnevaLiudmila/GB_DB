-- добавляем внешние ключи

-- в таблицу student_profiles

ALTER TABLE student_profiles
  ADD CONSTRAINT student_profiles_school_id_fk
  FOREIGN KEY (school_id) REFERENCES school_profiles(id)
    ON DELETE RESTRICT;
   
-- в таблицу связей student_courses

DROP TABLE IF EXISTS student_courses;
CREATE TABLE student_courses (
  adv_courses_id TINYINT  UNSIGNED NOT NULL,
  course_level_id TINYINT UNSIGNED UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (adv_courses_id, course_level_id, student_id)
);

DESC student_courses ;
SELECT * FROM student_courses;

ALTER TABLE student_courses
  ADD CONSTRAINT student_courses_adv_courses_id_fk
  FOREIGN KEY (adv_courses_id) REFERENCES advanced_courses(id)
    ON DELETE RESTRICT;
   
ALTER TABLE student_courses
  ADD CONSTRAINT student_courses_course_level_id_fk
  FOREIGN KEY (course_level_id) REFERENCES adv_course_levels(id)
    ON DELETE RESTRICT;
   
   ALTER TABLE student_courses
  ADD CONSTRAINT student_student_id_fk
  FOREIGN KEY (student_id) REFERENCES student_profiles(id)
    ON DELETE CASCADE;

 -- таблица   ounceler_evaluations два внешних ключа
 

DESC councelor_evaluations;
SELECT * FROM councelor_evaluations; 
  

ALTER TABLE councelor_evaluations
  ADD CONSTRAINT councelor_evaluations_student_id_fk
  FOREIGN KEY (student_id) REFERENCES student_profiles(id)
    ON DELETE CASCADE;

   
   ALTER TABLE councelor_evaluations
  ADD CONSTRAINT councelor_evaluations_school_id_fk
  FOREIGN KEY (school_id) REFERENCES school_profiles(id)
    ON DELETE CASCADE;
   
-- ALTER TABLE councelor_evaluations DROP FOREIGN KEY councelor_evaluations_school_id_fk;

   
 -- таблица teacher_evaluations два внешних ключа 
 
CREATE TABLE teacher_evaluations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  school_id INT UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  teacher_name VARCHAR(100) NOT NULL,
  evaluation TEXT DEFAULT NULL
);

ALTER TABLE teacher_evaluations
  ADD CONSTRAINT teacher_evaluations_student_id_fk
  FOREIGN KEY (student_id) REFERENCES student_profiles(id)
    ON DELETE CASCADE;

   
   ALTER TABLE teacher_evaluations
  ADD CONSTRAINT teacher_evaluations_school_id_fk
  FOREIGN KEY (school_id) REFERENCES school_profiles(id)
    ON DELETE CASCADE;
 
   ALTER TABLE teacher_evaluations DROP FOREIGN KEY teacher_evaluations_students_id_fk;

-- таблица результатов тестов

DROP TABLE IF EXISTS student_test_results;
CREATE TABLE student_test_results ( 
 	student_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
 	sat_math_score BIGINT,
	sat_english_score SMALLINT UNSIGNED,
	sat_subject_id SMALLINT UNSIGNED,
	sat_subject_score SMALLINT UNSIGNED
  ); 
 
 ALTER TABLE student_test_results
  ADD CONSTRAINT student_test_results_student_id_fk
  FOREIGN KEY (student_id) REFERENCES student_profiles(id)
    ON DELETE CASCADE;
 
   ALTER TABLE student_test_results
  ADD CONSTRAINT student_test_results_sat_subject_id_fk
  FOREIGN KEY (sat_subject_id) REFERENCES sat_subjects(id)
    ON DELETE SET NULL;
   
 
 -- заявление

DROP TABLE IF EXISTS applications;
 CREATE TABLE applications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  student_id BIGINT UNSIGNED NOT NULL,
  college_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  sent_at DATETIME DEFAULT NULL,
  status tinyint(1) DEFAULT NULL
); 

ALTER TABLE applications
  ADD CONSTRAINT application_student_id_fk
  FOREIGN KEY (student_id) REFERENCES student_profiles(id)
    ON DELETE CASCADE;

   
   ALTER TABLE applications
  ADD CONSTRAINT application_college_id_fk
  FOREIGN KEY (college_id) REFERENCES college_profiles(id)
    ON DELETE CASCADE;
   
   --  диаграмма см в отдельном файле

