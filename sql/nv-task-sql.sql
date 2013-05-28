/*
MySQL GUI v6.56
MySQL - 5.5.28-0ubuntu0.12.10.1 : Database - NV
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `categories` */

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `lft` int(4) DEFAULT NULL,
  `rgt` int(4) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `lft_idx` (`lft`),
  KEY `rgt_idx` (`rgt`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

/*Data for the table `categories` */

insert  into `categories`(`id`,`name`,`lft`,`rgt`,`parent_id`) values (1,'c1',1,24,0),(2,'c11',2,15,1),(3,'c111',3,8,2),(4,'c1111',4,5,3),(5,'c1112',6,7,3),(6,'c112',9,14,2),(7,'c1121',10,11,6),(8,'c1122',12,13,6),(9,'c12',16,23,1),(10,'c121',17,22,9),(11,'c1211',18,19,10),(12,'c1212',20,21,10),(13,'c2',25,31,0),(14,'c21',26,31,13),(15,'c211',27,28,14),(16,'c212',29,30,14),(17,'c3',32,37,0),(18,'c31',33,34,17),(19,'c31',35,36,17);

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `products` */

/*Table structure for table `products_categories` */

DROP TABLE IF EXISTS `products_categories`;

CREATE TABLE `products_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_idx` (`product_id`),
  KEY `category_idx` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `products_categories` */

/* Procedure structure for procedure `add_products` */

/*!50003 DROP PROCEDURE IF EXISTS  `add_products` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `add_products`(p_count Int)
BEGIN
    set @insert_query = CONCAT('INSERT INTO `products`(`name`, `price`) VALUES');
    set @ind = 1;
    set @idx  = (select IF(MAX(id),MAX(id),0) as c from products);# get max prod index
    set @glue = ''; # tool to glue bulk insert	
    while @ind <= p_count do
	set @pname = CONCAT("product_", @ind+@idx); # generate fake name
	set @price = FLOOR(1 + RAND()*10000); # generate fake price in cents between 1 cent to 100$
        set @insert_query = CONCAT(@insert_query, @glue, ' (\'',@pname,'\', ', @price, ')');
        set @ind = @ind + 1;
	set @glue = ', '; # set correct glue
    end while;
    # execute bulk insert
    prepare stmt FROM @insert_query;
    execute stmt; 
    /* assign new generated products to allowed categories list */	
    SET @max_prod_id  = (select IF(MAX(id),MAX(id),0) as c from products); # get max product id
    set @max_cat_id = (select IF(MAX(id),MAX(id),0) as c from categories); # get max cat id
    set @insert_query = 'INSERT INTO `products_categories`(`product_id`, `category_id`) VALUES';
    set @glue = '';	
    while @idx <= @max_prod_id do
	set @cat_num = FLOOR(1+RAND()*3); # geenrate up to 3 categories for each product
	set @ins = 0;
	while @ins < @cat_num do
		set @cat_id = FLOOR(1+RAND()*@max_cat_id);
		set @insert_query = CONCAT(@insert_query, @glue, ' (\'',@idx,'\', ', @cat_id, ')');
		set @ins = @ins+1; # update cursor
		set @glue = ', '; # set not empty glue
	end while;
        
        set @idx = @idx + 1;
    end while;
    # bulk insert products to categories
    prepare stmt FROM @insert_query;
    execute stmt;
    # show total products
    select count(*) from products;	
END */$$
DELIMITER ;

/* Procedure structure for procedure `task1` */

/*!50003 DROP PROCEDURE IF EXISTS  `task1` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `task1`(p1 Int, p2 int, p3 int, p4 int)
BEGIN
# for example this procedure can take only 4 products_ids but it's only example of query
SELECT DISTINCT pc.category_id, c.name
FROM products_categories as pc
JOIN categories as c ON (pc.category_id = c.id)
WHERE pc.product_id IN (p1,p2,p3,p4);
END */$$
DELIMITER ;

/* Procedure structure for procedure `task2` */

/*!50003 DROP PROCEDURE IF EXISTS  `task2` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `task2`(cid Int)
BEGIN
SELECT distinct p.id, p.name, p.price
FROM products_categories AS pc 
JOIN (
SELECT cc.id
FROM categories as c
JOIN categories as cc ON (cc.lft>= c.lft AND cc.rgt<= c.rgt)
WHERE c.id = cid
) as t On (t.id = pc.category_id)
JOIN products as p on p.id = pc.product_id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `task3` */

/*!50003 DROP PROCEDURE IF EXISTS  `task3` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `task3`(c1 Int, c2 int, c3 int, c4 int)
BEGIN
# get products count for each given cat ids
SELECT pc.category_id as cat_id, count(pc.product_id) as prod_count
FROM products_categories as pc
WHERE pc.category_id IN (c1, c2, c3, c4)
GROUP BY pc.category_id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `task4` */

/*!50003 DROP PROCEDURE IF EXISTS  `task4` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `task4`(c1 Int, c2 int, c3 int, c4 int)
BEGIN
# get total unique products count in given categories
SELECT count(*) as count from (
SELECT pc.product_id as c
FROM products_categories as pc
WHERE pc.category_id IN (c1, c2, c3, c4)
GROUP BY pc.product_id
) as tpl;
END */$$
DELIMITER ;

/* Procedure structure for procedure `task5` */

/*!50003 DROP PROCEDURE IF EXISTS  `task5` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `task5`(cid Int)
BEGIN
select c1.id, c1.name, c2.id, c2.name, c3.id, c3.name, c4.id, c4.name
FROM categories as c1
LEFT JOIN categories as c2 ON (c2.id = c1.parent_id)
LEFT JOIN categories as c3 ON (c3.id = c2.parent_id)
LEFT JOIN categories as c4 ON (c4.id = c3.parent_id)
WHERE c1.id = cid;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
