# Library Management System

A SQLite script for a small library: books, members, and the loans that connect them.

The script is [`library-project/library.sql`](library-project/library.sql). It creates the tables, loads sample rows, and then retrieves, updates, and deletes data.

## Try it

macOS and most Linux systems already include `sqlite3`. From this folder:

```bash
sqlite3 -header -column :memory: < library-project/library.sql
```

The command runs the whole script in memory and prints each result with column headers. It does not save a database file.

The output ends with three members and four loans. Omar Khalid and his loan are gone. In the book list just before that, *A Brief History of Time* has quantity 3.

## What the script shows

- Three related tables. `Loans` links a member to a book.
- Primary keys, a unique email, and checks: quantity cannot go below zero, and a return date cannot come before the loan date.
- Foreign keys, so a loan must refer to a real member and a real book.
- A join that lists every book Sara Ahmed has borrowed.
- An update that adds two copies of one book, chosen by its ISBN.
- A delete that removes a member's loan first, because a member who still has a loan cannot be deleted.

## Tables

| Table | What it stores | How it connects |
| --- | --- | --- |
| Books | One row per title: ISBN, title, author, genre, and how many copies are on the shelf | ISBN is the primary key |
| Members | One row per member: id, name, email, and phone | MemberID is the primary key. Email must be unique |
| Loans | One row each time a member borrows a book: who, which book, loan date, and return date | MemberID must match a member. ISBN must match a book |

An empty return date means the book has not come back yet.

## What happens, in order

1. Turns on foreign keys and recreates the three tables, so the script can be run again from a clean start.
2. Inserts five books, four members, and five loans. Books and members are added first, because a loan can only refer to rows that already exist.
3. Lists every book Sara Ahmed (MemberID 101) has borrowed, with the book details and the loan dates.
4. Adds 2 to the quantity of *A Brief History of Time*, which takes it from 1 to 3.
5. Deletes Omar Khalid (MemberID 104). His loan is removed first.

## Open it in the editor

This folder includes a SQLTools connection named **library**. It uses the SQLite driver and opens `library-project/library.db`.

To create that file and then browse it:

```bash
sqlite3 library-project/library.db < library-project/library.sql
```

Connect to **library** in SQLTools after the file exists.
