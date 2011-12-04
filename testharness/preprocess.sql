{
/*
 * Database 	: dbtarget - test database for iimport. 
 *
 * Site		: n/a
 *
 * Instance	: n/a 
 *
 * Description	: Test upgrade of migratedb to dbtarget with some rudementary 
 *		  column manipulations
 *
 * Notes	: Specifics
 *		  
 * Perms	: 444 
 *
 * Status	: DEVELOPMENT TEST SCRIPT
 *
 * Sccs Id	: %W% 
 *
 * Dated	: %D% %T% 
 *
 * Owner	: Graeme Burnett
 *
 * Continuus
 * 
 * Type		: %cvtype: %
 * Created by	: %created_by: %
 * Date Created	: %date_created: %
 * Date Modified: %date_modified: %
 * Derived by	: %derived_by: %
 * File/Version	: %filespec: %
 *
 */
}


{
    Load data from migratedb:customer into dbtarget:newtable

    Example of changing values in a column from Y to T and N to F 
}

{ The following columns need to be updated to reflect the new
  values required in the table. You therefore have to drop 
  the constraint which will prevent this operation. In the real
  migrate schema, all our constraints are named - so you have to 
  find out which one.
}

ALTER TABLE customer DROP CONSTRAINT c100_3;

UPDATE
    migratedb:customer
SET
    has_ordered = 'T'
WHERE
    has_ordered = 'Y';

UPDATE
    migratedb:customer
SET
    has_ordered = 'F'
WHERE
    has_ordered = 'N';

INSERT INTO
    dbtarget:newtable
(
customer_num,
has_ordered
)
SELECT
customer_num,
has_ordered
FROM
    migratedb:customer;


{
    Load data from migratedb: into dbtarget:
    Example of changing column order
}

INSERT INTO
    dbtarget:customer
(
    customer_num,
    lname,
    fname,
    company,
    address1,
    address2,
    city,
    state,
    zipcode,
    phone
)
SELECT
    customer_num,
    lname,
    fname,
    company,
    address1,
    address2,
    city,
    state,
    zipcode,
    phone
FROM
    migratedb:customer;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:orders
(
order_num,
order_date,
customer_num,
ship_instruct,
backlog,
po_num,
ship_date,
ship_weight,
ship_charge,
paid_date
)
SELECT
order_num,
order_date,
customer_num,
ship_instruct,
backlog,
po_num,
ship_date,
ship_weight,
ship_charge,
paid_date
FROM
    migratedb:orders;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:manufact
(
manu_code,
manu_name,
lead_time
)
SELECT
manu_code,
manu_name,
lead_time
FROM
    migratedb:manufact;


{
    Load data from migratedb: into dbtarget:

    Example of a column order change
}

INSERT INTO
    dbtarget:stock
(
stock_num,
description,
unit_price,
unit,
manu_code,
unit_descr
)
SELECT
stock_num,
description,
unit_price,
unit,
manu_code,
unit_descr
FROM
    migratedb:stock;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:items
(
item_num,
order_num,
stock_num,
manu_code,
quantity,
total_price
)
SELECT
item_num,
order_num,
stock_num,
manu_code,
quantity,
total_price
FROM
    migratedb:items;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:state
(
code,
sname
)
SELECT
code,
sname
FROM
    migratedb:state;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:call_type
(
call_code,
code_descr
)
SELECT
call_code,
code_descr
FROM
    migratedb:call_type;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:cust_calls
(
customer_num,
call_dtime,
user_id,
call_code,
call_descr,
res_dtime,
res_descr
)
SELECT
customer_num,
call_dtime,
user_id,
call_code,
call_descr,
res_dtime,
res_descr
FROM
    migratedb:cust_calls;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:log_record
(
item_num,
ord_num,
username,
update_time,
old_qty,
new_qty
)
SELECT
item_num,
ord_num,
username,
update_time,
old_qty,
new_qty
FROM
    migratedb:log_record;


{
    Load data from migratedb: into dbtarget:
}

INSERT INTO
    dbtarget:catalog
(
catalog_num,
stock_num,
manu_code,
cat_descr,
cat_picture,
cat_advert
)
SELECT
catalog_num,
stock_num,
manu_code,
cat_descr,
cat_picture,
cat_advert
FROM
    migratedb:catalog;


{
    Load data from migratedb: into dbtarget:
}

