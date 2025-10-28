CREATE OR REPLACE PROCEDURE Update_Stock_After_Issue(
  p_book_id  IN NUMBER,
  p_quantity IN NUMBER
) AS
  v_current_stock NUMBER;
BEGIN
  SELECT Stock INTO v_current_stock FROM Books WHERE Book_ID = p_book_id;

  IF v_current_stock >= p_quantity THEN
    UPDATE Books
    SET Stock = Stock - p_quantity
    WHERE Book_ID = p_book_id;
    DBMS_OUTPUT.PUT_LINE('Book stock updated successfully for Book_ID ' || p_book_id);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not enough books in stock! Only ' || v_current_stock || ' available for Book_ID ' || p_book_id);
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for Book ID ' || p_book_id);
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Book not found.');
    RAISE;
END;
/
