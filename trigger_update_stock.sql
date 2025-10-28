CREATE OR REPLACE TRIGGER trg_Update_Stock_After_Transaction
AFTER INSERT ON Select_Book
FOR EACH ROW
DECLARE
  v_trans_type VARCHAR2(20);
  v_stock      NUMBER;
BEGIN
  /*
    Determine the most recent transaction type for this member.
    We pick the latest Transaction_Details row (by Transaction_Date) for the member.
    If none found, we raise an exception.
  */
  BEGIN
    SELECT Transaction_Type
    INTO v_trans_type
    FROM (
      SELECT Transaction_Type, Transaction_Date
      FROM Transaction_Details
      WHERE Member_ID = :NEW.Member_ID
      ORDER BY Transaction_Date DESC
    ) WHERE ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Trigger error: No transaction found for Member_ID ' || :NEW.Member_ID || '. Stock not changed.');
      RETURN; -- nothing to do
  END;

  -- get current stock
  SELECT Stock INTO v_stock FROM Books WHERE Book_ID = :NEW.Book_ID;

  IF v_trans_type = 'Issue' THEN
    IF v_stock < :NEW.Quantity THEN
      -- prevented negative stock; raise error to stop inconsistent insert in stricter systems
      DBMS_OUTPUT.PUT_LINE('Trigger: insufficient stock for Book_ID ' || :NEW.Book_ID || '. Requested ' || :NEW.Quantity || ', available ' || v_stock || '.');
      RAISE_APPLICATION_ERROR(-20003, 'Trigger: Insufficient stock for Book ID ' || :NEW.Book_ID);
    ELSE
      UPDATE Books
      SET Stock = Stock - :NEW.Quantity
      WHERE Book_ID = :NEW.Book_ID;
      DBMS_OUTPUT.PUT_LINE('Trigger: Book issued. Stock reduced for Book_ID ' || :NEW.Book_ID);
    END IF;
  ELSIF v_trans_type = 'Return' THEN
    UPDATE Books
    SET Stock = Stock + :NEW.Quantity
    WHERE Book_ID = :NEW.Book_ID;
    DBMS_OUTPUT.PUT_LINE('Trigger: Book returned. Stock increased for Book_ID ' || :NEW.Book_ID);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Trigger: Unrecognized Transaction_Type (' || v_trans_type || '). No stock change.');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Trigger: Book not found for Book_ID ' || :NEW.Book_ID);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Trigger error: ' || SQLERRM);
    RAISE;
END;
/
