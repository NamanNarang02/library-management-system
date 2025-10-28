CREATE OR REPLACE PROCEDURE Return_Book(
  p_transaction_id IN NUMBER,
  p_member_id      IN NUMBER,
  p_book_id        IN NUMBER,
  p_quantity       IN NUMBER,
  p_payment_type   IN VARCHAR2  -- e.g., 'Cash' for paying fine
)
AS
  v_return_date     DATE := SYSDATE;
  v_fine            NUMBER := 0;
  v_invoice_id      NUMBER;
  v_existing_due    DATE;
  v_net_price       NUMBER;
BEGIN
  -- 1️⃣ Get the last issue's due date for this member and book
  BEGIN
    SELECT Due_Date 
    INTO v_existing_due
    FROM (
      SELECT td.Due_Date
      FROM Transaction_Details td
      WHERE td.Member_ID = p_member_id 
        AND td.Transaction_Type = 'Issue'
      ORDER BY td.Transaction_Date DESC
    )
    WHERE ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_existing_due := NULL;
  END;

  -- 2️⃣ Calculate fine
  IF v_existing_due IS NOT NULL THEN
    v_fine := Calculate_Fine(v_existing_due, v_return_date);
  END IF;

  -- 3️⃣ Insert return transaction
  INSERT INTO Transaction_Details (
    Transaction_ID, Member_ID, Total_Amount, Paid_Amount, Payment_Type, Transaction_Date, Transaction_Type, Due_Date
  )
  VALUES (
    p_transaction_id,
    p_member_id,
    v_fine,
    v_fine,
    p_payment_type,
    v_return_date,
    'Return',
    NULL
  );

  -- 4️⃣ Generate invoice if fine applies
  IF v_fine > 0 THEN
    SELECT NVL(MAX(Invoice_ID), 6000) + 1 INTO v_invoice_id FROM Invoice;
    SELECT Price INTO v_net_price FROM Books WHERE Book_ID = p_book_id;

    INSERT INTO Invoice (Invoice_ID, Transaction_ID, Book_Title, Quantity, Net_Price, Fine_Amount)
    VALUES (
      v_invoice_id,
      p_transaction_id,
      (SELECT Book_Title FROM Books WHERE Book_ID = p_book_id),
      p_quantity,
      v_net_price * p_quantity,
      v_fine
    );

    DBMS_OUTPUT.PUT_LINE('Fine applicable: ' || v_fine || '. Invoice generated (Invoice_ID=' || v_invoice_id || ').');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No fine applicable.');
  END IF;

  -- 5️⃣ Add record for return (trigger will restore stock)
  INSERT INTO Select_Book (Member_ID, Book_ID, Quantity)
  VALUES (p_member_id, p_book_id, p_quantity);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Return transaction created (Transaction_ID=' || p_transaction_id || ').');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Return failed: Book not found.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Return_Book error: ' || SQLERRM);
    ROLLBACK;
END;
/
