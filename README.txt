Shamlah Import
==============
Imports .bok, .mdb books from AlShamelah library into Drupal's database.

The main workflow:
1- Convert .mdb (.bok) Access DB into SQL queries files (the results 
are two files 'title.sql' and 'book.sql'.
2- Import these two files into temporary MySQL tables for fast
access/CRUD queries on them.
3- Get Shamelah specific schema and create new books pages based
on the previous files contents.
4- Make use of 'hand-made' Book API methods to create the new book.


Requirements:
=============
MDB Tools
Perl
