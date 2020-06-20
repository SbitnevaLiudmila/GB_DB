DELIMITER //
DROP TRIGGER IF EXISTS application_send //

CREATE TRIGGER application_send BEFORE UPDATE ON applications
FOR EACH ROW BEGIN
	 	IF new.status = 1 
	 	THEN SET NEW.sent_at = NOW();
 	END IF;
 	END//

 	DELIMITER;


