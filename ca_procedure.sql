USE commonapp;

DELIMITER //
DROP procedure IF EXISTS total_sat //
CREATE PROCEDURE total_sat(_num int)
BEGIN
	DECLARE summ INT default 0;
 	SELECT str.sat_english_score+str.sat_math_score +str.sat_subject_score 
	FROM student_test_results str
	WHERE student_id = _num INTO @summ;
END//
DELIMITER ;

SHOW CREATE PROCEDURE total_sat;

CALL total_sat(3);
SELECT @summ;
