CREATE OR REPLACE PROCEDURE Check_Book_Stock(p_book_id IN NUMBER) AS
  v_stock NUMBER;
  v_title VARCHAR2(150);
BEGIN
  SELECT Book_Title, Stock INTO v_title, v_stock
  FROM Books
  WHERE Book_ID = p_book_id;

  IF v_stock < 5 THEN
    DBMS_OUTPUT.PUT_LINE('Low stock for "' || v_title || '" (Stock: ' || v_stock || ')');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Stock sufficient for "' || v_title || '" (Stock: ' || v_stock || ')');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Book not found.');
END;
/
