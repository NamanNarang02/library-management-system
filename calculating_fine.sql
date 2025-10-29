CREATE OR REPLACE FUNCTION Calculate_Fine(
  p_due_date    IN DATE,
  p_return_date IN DATE
) RETURN NUMBER
AS
  v_fine_per_day NUMBER := 10; -- example fine per day
  v_days_late    NUMBER;
  v_total_fine   NUMBER;
BEGIN
  IF p_return_date > p_due_date THEN
    v_days_late := p_return_date - p_due_date;
    v_total_fine := v_days_late * v_fine_per_day;
  ELSE
    v_total_fine := 0;
  END IF;

  RETURN v_total_fine;
END;
/
