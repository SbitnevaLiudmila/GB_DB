CREATE INDEX student_profiles_first_name_idx ON student_profiles(first_name);
CREATE INDEX student_profiles_last_name_idx ON student_profiles(last_name);
CREATE INDEX student_profiles_birthday_idx ON student_profiles(birthday);
CREATE UNIQUE INDEX student_profiles_email_idx ON student_profiles(email);

CREATE UNIQUE INDEX school_profiles_name_idx ON school_profiles(name);
 
CREATE UNIQUE INDEX college_profiles_name_idx ON college_profiles(name);
CREATE UNIQUE INDEX college_profiles_admission_email_idx ON college_profiles(admission_email);

CREATE INDEX student_test_results_sat_math_score_idx ON student_test_results(sat_math_score);
CREATE INDEX student_test_results_sat_english_score_idx ON student_test_results(sat_english_score);
CREATE INDEX student_test_results_sat_subject_score_idx ON student_test_results(subject_score_idx);
  
 

CREATE INDEX application_sent_at_idx ON applications(sent_at);

SHOW INDEX FROM student_test_results;