DELIMITER //
DROP FUNCTION IF EXISTS applicants_results_more_then //
CREATE FUNCTION applicants_results_more_then(_num INT) 
RETURNS INT
BEGIN
   DECLARE result INT;
	SELECT COUNT(DISTINCT sp.id)
	FROM student_profiles sp 
	JOIN applications a
	ON sp.id = a.student_id
	JOIN student_test_results str
	ON sp.id = str.student_id
	WHERE str.sat_math_score > _num INTO result;
RETURN (result); 
END//

DELIMITER ;
 
SELECT applicants_results_more_then(400);

SHOW FUNCTION STATUS;

SHOW CREATE FUNCTION applicants_results_more_then;