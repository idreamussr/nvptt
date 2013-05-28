nvptt
=====

NVPTT - Noosphere Ventures PHP test task 

Contains
---
- simple auth app
- sql store structure
- js  conversation number to words
- php hack self reader
 
Task1 - Yii
====

Requirements
---
- Yii 1.1.x+
- php 5.3+

Usage
----
```
git clone https://github.com/idreamussr/nvptt.git /local/path
cd /local/path

```
configure hosts  in web server 
http://www.yiiframework.com/wiki/153/using-yii-with-nginx-and-php-fpm/
...
allow webserver access to protected/runtime
...

restart server
```

Frontend
---
> open browser at http://<hostname>



Task2 - SQL
=====

create new database in Mysql 5+
import dump from ./sql/nv-task-sql.sql
...
populate products in database
execute procedure
```
call fill_products(10000); 
```
you can call this procedure  as many as you want
....
execute procedures 
```
call task1(...);
call task2(...);
call task3(...);
call task4(...);
call task1(...);

```

Task3
=====
Javascript  bicycle for conversion number to words
> located in ./js/Number2Words.js

Task4
=====
Reading php source without file reading 
> located in ./scripts/selfreader.php

