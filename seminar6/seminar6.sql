# 1. Создайте функцию, которая принимает кол-во сек и форматирует их в кол-во дней, часов, минут и секунд.

CREATE FUNCTION format_time(seconds INT)
    RETURNS VARCHAR(100)
    DETERMINISTIC
BEGIN
    DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;

    SET days = seconds div 86400;
    SET seconds = seconds % 86400;
    SET hours = seconds div 3600;
    SET seconds = seconds % 3600;
    SET minutes = seconds div 60;
    SET seconds = seconds % 60;

    RETURN CONCAT(days, ' days ', hours, ' hours ', minutes, ' minutes ', seconds, ' seconds');
END;

SELECT format_time(123456);

# 2. Выведите только четные числа от 1 до 10 включительно.

DELIMITER $$
CREATE PROCEDURE even_numbers()
BEGIN
    DECLARE start_num INT DEFAULT 1;
    DECLARE result_string VARCHAR(100) DEFAULT '';

    WHILE start_num <= 10
        DO
            IF start_num % 2 <> 0 THEN
                SET start_num = start_num + 1;
            ELSE
                SET result_string = CONCAT(result_string, ' ', start_num);
                SET start_num = start_num + 1;
            END IF;
        END WHILE;

    SELECT result_string;
END $$
DELIMITER ;

CALL even_numbers();