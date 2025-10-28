CREATE OR REPLACE FUNCTION Calculate_Fine(p_due_date IN DATE, p_return_date IN DATE) RETURN NUMBER IS
  v_days_over NUMBER;
  v_fine      NUMBER := 0;
  v_rate_per_day NUMBER := 10; -- example: 10 currency units per day
BEGIN
  IF p_return_date > p_due_date THEN
    v_days_over := TRUNC(p_return_date) - TRUNC(p_due_date);
    v_fine := v_days_over * v_rate_per_day;
  ELSE
    v_fine := 0;
  END IF;
  RETURN v_fine;
END;
/
