CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(
               calendar_date DATE
) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE fiscal_year INT;
        SET fiscal_year = Year(DATE_ADD(calendar_date, interval 4 month));
        RETURN fiscal_year;
RETURN 1;
END