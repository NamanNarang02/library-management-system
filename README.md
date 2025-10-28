# 📚 Library Management System (DBMS Project)

### 🧩 Project Overview
The **Library Management System** is a database-based project built using **Oracle SQL & PL/SQL**.  
It helps manage books, members, transactions, and fines in an automated way.  
The project demonstrates practical use of **database design**, **procedures**, **triggers**, and **functions** for managing real-world library operations.

---

## 🏗️ Tech Stack
- **Database:** Oracle SQL  
- **Procedural Logic:** PL/SQL (Procedures, Functions, Triggers)  
- **Tools Used:** SQL Developer / Oracle Live SQL  

---

## 📂 Database Structure

### **Tables Created**
| Table Name | Description |
|-------------|--------------|
| `Lib_User` | Stores librarian and staff credentials |
| `Authors` | Stores author information |
| `Publishers` | Stores publisher details |
| `Books` | Contains all book details with stock count |
| `Members` | Stores library members' info |
| `Select_Book` | Tracks which member has borrowed which book |
| `Transaction_Details` | Records issue and return transactions |
| `Invoice` | Generates fine or billing details for transactions |

---

## ⚙️ Key Features

### ✅ Book Management
- Add, update, and manage books with authors, categories, and publishers.
- Automatic stock tracking using **database triggers**.

### ✅ Issue & Return System
- **Issue_Book** procedure handles book issue transactions.
- **Return_Book** procedure manages book returns and applies fines for late returns.

### ✅ Fine Calculation
- Automatic fine calculation using `Calculate_Fine()` function (₹10 per late day).
- Invoice automatically generated for fines.

### ✅ Stock Management (Trigger-Based)
- Trigger automatically **reduces stock on issue** and **increases stock on return**.

---

## 🔥 Major PL/SQL Components

### **1️⃣ Procedure – Issue_Book**
Handles book issue operations, records transactions, and triggers stock updates.

### **2️⃣ Procedure – Return_Book**
Handles book returns, checks due date, calculates fine, and restores stock.

### **3️⃣ Function – Calculate_Fine**
Returns fine amount based on days overdue.

### **4️⃣ Trigger – trg_update_stock**
Automatically updates book stock after issue or return.

---

## 🧠 Example Usage

```sql
-- Issue a Book
BEGIN
  Issue_Book(SEQ_TRANSACTION.NEXTVAL, 1, 101, 1, 'Cash', 0);
END;
/

-- Return a Book
BEGIN
  Return_Book(SEQ_TRANSACTION.NEXTVAL, 1, 101, 1, 'Cash');
END;
/

-- Check Updated Stock
SELECT Book_ID, Book_Title, Stock FROM Books;
