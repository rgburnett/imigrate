grant dba to "burnetg";
grant resource to "public";



{ TABLE "burnetg".customer row size = 134 number of columns = 10 index size = 25 
              }
create table "burnetg".customer 
  (
    customer_num serial not null constraint "burnetg".n100_2,
    fname char(15),
    lname char(15),
    company char(20),
    address1 char(20),
    address2 char(20),
    city char(15),
    state char(2),
    zipcode char(5),
    phone char(18),
    primary key (customer_num) constraint "burnetg".u100_1
  );
revoke all on "burnetg".customer from "public";

create index "burnetg".zip_ix on "burnetg".customer (zipcode);
{ TABLE "burnetg".orders row size = 80 number of columns = 10 index size = 24 }
create table "burnetg".orders 
  (
    order_num serial not null constraint "burnetg".n101_5,
    order_date date,
    customer_num integer not null constraint "burnetg".n101_6,
    ship_instruct char(40),
    backlog char(1),
    po_num char(10),
    ship_date date,
    ship_weight decimal(8,2),
    ship_charge money(6,2),
    paid_date date,
    primary key (order_num) constraint "burnetg".u101_3
  );
revoke all on "burnetg".orders from "public";

{ TABLE "burnetg".manufact row size = 21 number of columns = 3 index size = 10 }
create table "burnetg".manufact 
  (
    manu_code char(3),
    manu_name char(15),
    lead_time interval day(3) to day,
    primary key (manu_code) constraint "burnetg".u102_7
  );
revoke all on "burnetg".manufact from "public";

{ TABLE "burnetg".stock row size = 43 number of columns = 6 index size = 24 }
create table "burnetg".stock 
  (
    stock_num smallint,
    manu_code char(3),
    description char(15),
    unit_price money(6,2),
    unit char(4),
    unit_descr char(15),
    primary key (stock_num,manu_code) constraint "burnetg".u103_8
  );
revoke all on "burnetg".stock from "public";

{ TABLE "burnetg".items row size = 18 number of columns = 6 index size = 40 }
create table "burnetg".items 
  (
    item_num smallint,
    order_num integer,
    stock_num smallint not null constraint "burnetg".n104_13,
    manu_code char(3) not null constraint "burnetg".n104_14,
    quantity smallint,
    total_price money(8,2),
    
    check (quantity >= 1 ) constraint "burnetg".c104_15,
    primary key (item_num,order_num) constraint "burnetg".u104_10
  );
revoke all on "burnetg".items from "public";

{ TABLE "burnetg".state row size = 17 number of columns = 2 index size = 9 }
create table "burnetg".state 
  (
    code char(2),
    sname char(15),
    primary key (code) constraint "burnetg".u105_16
  );
revoke all on "burnetg".state from "public";

{ TABLE "burnetg".call_type row size = 31 number of columns = 2 index size = 7 }
create table "burnetg".call_type 
  (
    call_code char(1),
    code_descr char(30),
    primary key (call_code) constraint "burnetg".u106_17
  );
revoke all on "burnetg".call_type from "public";

{ TABLE "burnetg".cust_calls row size = 517 number of columns = 7 index size = 42 
              }
create table "burnetg".cust_calls 
  (
    customer_num integer,
    call_dtime datetime year to minute,
    user_id char(18) 
        default user,
    call_code char(1),
    call_descr char(240),
    res_dtime datetime year to minute,
    res_descr char(240),
    primary key (customer_num,call_dtime) constraint "burnetg".u107_18
  );
revoke all on "burnetg".cust_calls from "public";

{ TABLE "burnetg".log_record row size = 25 number of columns = 6 index size = 0 }
create table "burnetg".log_record 
  (
    item_num smallint,
    ord_num integer,
    username char(8),
    update_time datetime year to minute,
    old_qty smallint,
    new_qty smallint
  );
revoke all on "burnetg".log_record from "public";

{ TABLE "burnetg".catalog row size = 377 number of columns = 6 index size = 25 }
create table "burnetg".catalog 
  (
    catalog_num serial not null constraint "burnetg".n111_23,
    stock_num smallint not null constraint "burnetg".n111_24,
    manu_code char(3) not null constraint "burnetg".n111_25,
    cat_descr text,
    cat_picture byte,
    cat_advert varchar(255,65),
    primary key (catalog_num) constraint "burnetg".u111_21
  );
revoke all on "burnetg".catalog from "public";


alter table "burnetg".orders add constraint (foreign key (customer_num) 
    references "burnetg".customer  constraint "burnetg".r101_4);

alter table "burnetg".stock add constraint (foreign key (manu_code) 
    references "burnetg".manufact  constraint "burnetg".r103_9);

alter table "burnetg".items add constraint (foreign key (order_num) 
    references "burnetg".orders  constraint "burnetg".r104_11);

alter table "burnetg".items add constraint (foreign key (stock_num,manu_code) 
    references "burnetg".stock  constraint "burnetg".r104_12);

alter table "burnetg".cust_calls add constraint (foreign key (customer_num) 
    references "burnetg".customer  constraint "burnetg".r107_19);

alter table "burnetg".cust_calls add constraint (foreign key (call_code) 
    references "burnetg".call_type  constraint "burnetg".r107_20);

alter table "burnetg".catalog add constraint (foreign key (stock_num,
    manu_code) references "burnetg".stock  constraint "burnetg".aa);


grant select on "burnetg".customer to "public" as "burnetg";
grant update on "burnetg".customer to "public" as "burnetg";
grant insert on "burnetg".customer to "public" as "burnetg";
grant delete on "burnetg".customer to "public" as "burnetg";
grant index on "burnetg".customer to "public" as "burnetg";
grant select on "burnetg".orders to "public" as "burnetg";
grant update on "burnetg".orders to "public" as "burnetg";
grant insert on "burnetg".orders to "public" as "burnetg";
grant delete on "burnetg".orders to "public" as "burnetg";
grant index on "burnetg".orders to "public" as "burnetg";
grant select on "burnetg".manufact to "public" as "burnetg";
grant update on "burnetg".manufact to "public" as "burnetg";
grant insert on "burnetg".manufact to "public" as "burnetg";
grant delete on "burnetg".manufact to "public" as "burnetg";
grant index on "burnetg".manufact to "public" as "burnetg";
grant select on "burnetg".stock to "public" as "burnetg";
grant update on "burnetg".stock to "public" as "burnetg";
grant insert on "burnetg".stock to "public" as "burnetg";
grant delete on "burnetg".stock to "public" as "burnetg";
grant index on "burnetg".stock to "public" as "burnetg";
grant select on "burnetg".items to "public" as "burnetg";
grant update on "burnetg".items to "public" as "burnetg";
grant insert on "burnetg".items to "public" as "burnetg";
grant delete on "burnetg".items to "public" as "burnetg";
grant index on "burnetg".items to "public" as "burnetg";
grant select on "burnetg".state to "public" as "burnetg";
grant update on "burnetg".state to "public" as "burnetg";
grant insert on "burnetg".state to "public" as "burnetg";
grant delete on "burnetg".state to "public" as "burnetg";
grant index on "burnetg".state to "public" as "burnetg";
grant select on "burnetg".call_type to "public" as "burnetg";
grant update on "burnetg".call_type to "public" as "burnetg";
grant insert on "burnetg".call_type to "public" as "burnetg";
grant delete on "burnetg".call_type to "public" as "burnetg";
grant index on "burnetg".call_type to "public" as "burnetg";
grant select on "burnetg".cust_calls to "public" as "burnetg";
grant update on "burnetg".cust_calls to "public" as "burnetg";
grant insert on "burnetg".cust_calls to "public" as "burnetg";
grant delete on "burnetg".cust_calls to "public" as "burnetg";
grant index on "burnetg".cust_calls to "public" as "burnetg";
grant select on "burnetg".log_record to "public" as "burnetg";
grant update on "burnetg".log_record to "public" as "burnetg";
grant insert on "burnetg".log_record to "public" as "burnetg";
grant delete on "burnetg".log_record to "public" as "burnetg";
grant index on "burnetg".log_record to "public" as "burnetg";
grant select on "burnetg".catalog to "public" as "burnetg";
grant update on "burnetg".catalog to "public" as "burnetg";
grant insert on "burnetg".catalog to "public" as "burnetg";
grant delete on "burnetg".catalog to "public" as "burnetg";
grant index on "burnetg".catalog to "public" as "burnetg";


 


create view "burnetg".custview (firstname,lastname,company,city) as 
  select x0.fname ,x0.lname ,x0.company ,x0.city from "burnetg".customer 
    x0 where (x0.city = 'Redwood City' ) with check option;               
                                                   
create view "burnetg".someorders (custnum,ocustnum,newprice) as 
  select x0.order_num ,x1.order_num ,(x1.total_price * '$1.500' ) from 
    "burnetg".orders x0 ,"burnetg".items x1 where ((x0.order_num = x1.order_num 
    ) AND (x1.total_price > '$100.00' ) ) ;        

grant select on "burnetg".custview to "public" as "burnetg";
grant update on "burnetg".custview to "public" as "burnetg";
grant insert on "burnetg".custview to "public" as "burnetg";
grant delete on "burnetg".custview to "public" as "burnetg";



create trigger "burnetg".upqty_i update of quantity on "burnetg".items referencing 
    old as pre_upd new as post_upd
    for each row
        (
        insert into "burnetg".log_record (item_num,ord_num,username,
            update_time,old_qty,new_qty)  values (pre_upd.item_num 
            ,pre_upd.order_num ,USER ,CURRENT year to fraction(3),
            pre_upd.quantity ,post_upd.quantity ));


