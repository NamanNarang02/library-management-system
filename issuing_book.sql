CREATE OR REPLACE PROCEDURE Issue_Book(
  p_transaction_id IN NUMBER,
  p_member_id      IN NUMBER,
  p_book_id        IN NUMBER,
  p_quantity       IN NUMBER,
  p_payment_type   IN VARCHAR2,
  p_total_amount   IN NUMBER
) AS
  v_stock NUMBER;
  v_due_date DATE;
BEGIN
  -- check book exists & stock
  SELECT Stock INTO v_stock FROM Books WHERE Book_ID = p_book_id;

  IF v_stock < p_quantity THEN
    DBMS_OUTPUT.PUT_LINE('Issue failed: Not enough stock for Book_ID ' || p_book_id);
    RAISE_APPLICATION_ERROR(-20002, 'Insufficient stock for Book ID ' || p_book_id);
  END IF;

  -- set due date (example: 14 days loan period)
  v_due_date := SYSDATE + 14;

  -- insert transaction (Issue)
  INSERT INTO Transaction_Details (
    Transaction_ID, Member_ID, Total_Amount, Paid_Amount, Payment_Type, Transaction_Date, Transaction_Type, Due_Date
  ) VALUES (
    p_transaction_id, p_member_id, p_total_amount, p_total_amount, p_payment_type, SYSDATE, 'Issue', v_due_date
  );

  -- insert into Select_Book (trigger will handle stock decrement)
  INSERT INTO Select_Book (Member_ID, Book_ID, Quantity) VALUES (p_member_id, p_book_id, p_quantity);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Issue transaction created (Transaction_ID=' || p_transaction_id || '). Due Date: ' || TO_CHAR(v_due_date, 'DD-MON-YYYY'));
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Issue failed: Book not found.');
    ROLLBACK;
    RAISE;
  WHEN OTHERS THEN
    -- bubble up or handle
    DBMS_OUTPUT.PUT_LINE('Issue_Book error: ' || SQLERRM);
    ROLLBACK;
    RAISE;
END;
/
