-- 1) Issue a book using the Issue_Book procedure
BEGIN
  -- Example: transaction_id 3001, member 1 issues 2 copies of book 101
  Issue_Book(3001, 1, 101, 2, 'Cash', 0);
END;
/

-- Check stock after issue (expected reduced by 2)
SELECT Book_ID, Book_Title, Stock FROM Books WHERE Book_ID = 101;

-- Check trigger output via DBMS_OUTPUT lines will show in SQL Developer or SQL*Plus

-- 2) Return a book using the Return_Book procedure
BEGIN
  -- Example: transaction_id 3002, member 1 returns 1 copy of book 101
  Return_Book(3002, 1, 101, 1, 'Cash');
END;
/

-- Check stock after return (expected increased by 1)
SELECT Book_ID, Book_Title, Stock FROM Books WHERE Book_ID = 101;

-- View invoices (if any fines were generated)
SELECT * FROM Invoice;

--Transaction details
SELECT * FROM transaction_details
