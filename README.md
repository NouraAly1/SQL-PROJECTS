# Library Management System

A SQLite project that tracks books, library members, and the loans that connect them.

The script is `library-project/library.sql`. Running it builds `library-project/library.db`.

## Tables

| Table | What it stores | How it connects |
| --- | --- | --- |
| Books | One row per title: ISBN, title, author, genre, and how many copies are on the shelf | ISBN is the primary key |
| Members | One row per member: id, name, email, and phone | MemberID is the primary key. Email must be unique |
| Loans | One row each time a member borrows a book: who, which book, loan date, and return date | MemberID must match a member. ISBN must match a book |

A loan cannot point at a member or a book that does not exist. A return date cannot be earlier than the loan date. The number of copies cannot go below zero.

## What the script does

1. Turns on foreign keys and recreates the three tables, so the script can be run again from a clean start.
2. Inserts five books, four members, and five loans. Books and members are added first, because a loan can only refer to rows that already exist.
3. Lists every book Sara Ahmed (MemberID 101) has borrowed, with the book details and the loan dates.
4. Updates the quantity of *A Brief History of Time* from 1 to 3.
5. Deletes Omar Khalid (MemberID 104). His loan is removed first, because a member who still has a loan cannot be deleted.

An empty return date means the book has not come back yet.

## Run it

From this folder:

```bash
sqlite3 library-project/library.db < library-project/library.sql
```

Each `SELECT` in the script prints its result in the terminal.

## Open it in the editor

The workspace includes a SQLTools connection named **library**. It uses the SQLite driver and opens `library-project/library.db`.

Install the SQLTools extension and the SQLTools SQLite driver, then connect to **library** and run `library-project/library.sql`.
