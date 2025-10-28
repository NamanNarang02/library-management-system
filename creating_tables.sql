CREATE TABLE Lib_User (
  User_ID     VARCHAR2(50) PRIMARY KEY,
  Name        VARCHAR2(100),
  Password    VARCHAR2(50),
  User_Type   VARCHAR2(20)
);

CREATE TABLE Authors (
  Author_ID   NUMBER PRIMARY KEY,
  Author_Name VARCHAR2(100)
);

CREATE TABLE Categories (
  Category_ID   NUMBER PRIMARY KEY,
  Category_Name VARCHAR2(100)
);

CREATE TABLE Publishers (
  Publisher_ID   NUMBER PRIMARY KEY,
  Publisher_Name VARCHAR2(100),
  Address        VARCHAR2(200),
  Phone_No       VARCHAR2(15)
);

CREATE TABLE Books (
  Book_ID        NUMBER PRIMARY KEY,
  Book_Title     VARCHAR2(150),
  Author_ID      NUMBER,
  Category_ID    NUMBER,
  Publisher_ID   NUMBER,
  Price          NUMBER(10,2),
  Stock          NUMBER,
  Added_Date     DATE,
  FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID),
  FOREIGN KEY (Category_ID) REFERENCES Categories(Category_ID),
  FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Publisher_ID)
);

CREATE TABLE Member (
  Member_ID    NUMBER PRIMARY KEY,
  Member_Name  VARCHAR2(100),
  Mobile_No    VARCHAR2(15)
);

-- Select_Book represents books associated with a transaction/member.
CREATE TABLE Select_Book (
  Member_ID  NUMBER,
  Book_ID    NUMBER,
  Quantity   NUMBER,
  PRIMARY KEY (Member_ID, Book_ID),
  FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
  FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- Transaction_Details: added Transaction_Type and Due_Date
CREATE TABLE Transaction_Details (
  Transaction_ID   NUMBER PRIMARY KEY,
  Member_ID        NUMBER,
  Total_Amount     NUMBER(10,2),
  Paid_Amount      NUMBER(10,2),
  Payment_Type     VARCHAR2(20),
  Transaction_Date DATE,
  Transaction_Type VARCHAR2(20),  -- 'Issue' or 'Return'
  Due_Date         DATE,
  FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

CREATE TABLE Invoice (
  Invoice_ID      NUMBER PRIMARY KEY,
  Transaction_ID  NUMBER,
  Book_Title      VARCHAR2(150),
  Quantity        NUMBER,
  Net_Price       NUMBER(10,2),
  Fine_Amount     NUMBER(10,2),
  FOREIGN KEY (Transaction_ID) REFERENCES Transaction_Details(Transaction_ID)
);
