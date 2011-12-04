grant dba to "root";



{ TABLE "root".customer row size = 135 number of columns = 11 index size = 25 }
create table "root".customer 
  (
    customer_num serial not null constraint "root".n100_2,
    fname char(15),
    lname char(15),
    company char(20),
    address1 char(20),
    address2 char(20),
    city char(15),
    state char(2),
    zipcode char(5),
    phone char(18),
    has_ordered char(1),
    
    check (has_ordered IN ('Y' ,'N' )) constraint "root".c100_3,
    primary key (customer_num) constraint "root".u100_1
  );
revoke all on "root".customer from "public";

create index "root".zip_ix on "root".customer (zipcode);
{ TABLE "root".orders row size = 80 number of columns = 10 index size = 24 }
create table "root".orders 
  (
    order_num serial not null constraint "root".n101_4,
    order_date date,
    customer_num integer not null constraint "root".n101_5,
    ship_instruct char(40),
    backlog char(1),
    po_num char(10),
    ship_date date,
    ship_weight decimal(8,2),
    ship_charge money(6,2),
    paid_date date,
    primary key (order_num) constraint "root".u101_3
  );
revoke all on "root".orders from "public";

{ TABLE "root".manufact row size = 21 number of columns = 3 index size = 10 }
create table "root".manufact 
  (
    manu_code char(3),
    manu_name char(15),
    lead_time interval day(3) to day,
    primary key (manu_code) constraint "root".u102_6
  );
revoke all on "root".manufact from "public";

{ TABLE "root".stock row size = 43 number of columns = 6 index size = 24 }
create table "root".stock 
  (
    stock_num smallint,
    manu_code char(3),
    description char(15),
    unit_price money(6,2),
    unit char(4),
    unit_descr char(15),
    primary key (stock_num,manu_code) constraint "root".u103_7
  );
revoke all on "root".stock from "public";

{ TABLE "root".items row size = 18 number of columns = 6 index size = 40 }
create table "root".items 
  (
    item_num smallint,
    order_num integer,
    stock_num smallint not null constraint "root".n104_9,
    manu_code char(3) not null constraint "root".n104_10,
    quantity smallint,
    total_price money(8,2),
    
    check (quantity >= 1 ) constraint "root".c104_11,
    primary key (item_num,order_num) constraint "root".u104_8
  );
revoke all on "root".items from "public";

{ TABLE "root".state row size = 17 number of columns = 2 index size = 9 }
create table "root".state 
  (
    code char(2),
    sname char(15),
    primary key (code) constraint "root".u105_12
  );
revoke all on "root".state from "public";

{ TABLE "root".call_type row size = 31 number of columns = 2 index size = 7 }
create table "root".call_type 
  (
    call_code char(1),
    code_descr char(30),
    primary key (call_code) constraint "root".u106_13
  );
revoke all on "root".call_type from "public";

{ TABLE "root".cust_calls row size = 517 number of columns = 7 index size = 42 }
create table "root".cust_calls 
  (
    customer_num integer,
    call_dtime datetime year to minute,
    user_id char(18) 
        default user,
    call_code char(1),
    call_descr char(240),
    res_dtime datetime year to minute,
    res_descr char(240),
    primary key (customer_num,call_dtime) constraint "root".u107_14
  );
revoke all on "root".cust_calls from "public";

{ TABLE "root".log_record row size = 25 number of columns = 6 index size = 0 }
create table "root".log_record 
  (
    item_num smallint,
    ord_num integer,
    username char(8),
    update_time datetime year to minute,
    old_qty smallint,
    new_qty smallint
  );
revoke all on "root".log_record from "public";

{ TABLE "root".catalog row size = 777 number of columns = 6 index size = 25 }
create table "root".catalog 
  (
    catalog_num serial not null constraint "root".n109_16,
    stock_num smallint not null constraint "root".n109_17,
    manu_code char(3) not null constraint "root".n109_18,
    cat_descr varchar(255),
    cat_picture varchar(255),
    cat_advert varchar(255,65),
    primary key (catalog_num) constraint "root".u109_15
  );
revoke all on "root".catalog from "public";


alter table "root".orders add constraint (foreign key (customer_num) 
    references "root".customer  constraint "root".r101_19);

alter table "root".stock add constraint (foreign key (manu_code) 
    references "root".manufact  constraint "root".r103_20);

alter table "root".items add constraint (foreign key (order_num) 
    references "root".orders  constraint "root".r104_21);

alter table "root".items add constraint (foreign key (stock_num,manu_code) 
    references "root".stock  constraint "root".r104_22);

alter table "root".cust_calls add constraint (foreign key (customer_num) 
    references "root".customer  constraint "root".r107_23);

alter table "root".cust_calls add constraint (foreign key (call_code) 
    references "root".call_type  constraint "root".r107_24);

alter table "root".catalog add constraint (foreign key (stock_num,
    manu_code) references "root".stock  constraint "root".aa);


grant select on "root".customer to "public" as "root";
grant update on "root".customer to "public" as "root";
grant insert on "root".customer to "public" as "root";
grant delete on "root".customer to "public" as "root";
grant index on "root".customer to "public" as "root";
grant select on "root".orders to "public" as "root";
grant update on "root".orders to "public" as "root";
grant insert on "root".orders to "public" as "root";
grant delete on "root".orders to "public" as "root";
grant index on "root".orders to "public" as "root";
grant select on "root".manufact to "public" as "root";
grant update on "root".manufact to "public" as "root";
grant insert on "root".manufact to "public" as "root";
grant delete on "root".manufact to "public" as "root";
grant index on "root".manufact to "public" as "root";
grant select on "root".stock to "public" as "root";
grant update on "root".stock to "public" as "root";
grant insert on "root".stock to "public" as "root";
grant delete on "root".stock to "public" as "root";
grant index on "root".stock to "public" as "root";
grant select on "root".items to "public" as "root";
grant update on "root".items to "public" as "root";
grant insert on "root".items to "public" as "root";
grant delete on "root".items to "public" as "root";
grant index on "root".items to "public" as "root";
grant select on "root".state to "public" as "root";
grant update on "root".state to "public" as "root";
grant insert on "root".state to "public" as "root";
grant delete on "root".state to "public" as "root";
grant index on "root".state to "public" as "root";
grant select on "root".call_type to "public" as "root";
grant update on "root".call_type to "public" as "root";
grant insert on "root".call_type to "public" as "root";
grant delete on "root".call_type to "public" as "root";
grant index on "root".call_type to "public" as "root";
grant select on "root".cust_calls to "public" as "root";
grant update on "root".cust_calls to "public" as "root";
grant insert on "root".cust_calls to "public" as "root";
grant delete on "root".cust_calls to "public" as "root";
grant index on "root".cust_calls to "public" as "root";
grant select on "root".log_record to "public" as "root";
grant update on "root".log_record to "public" as "root";
grant insert on "root".log_record to "public" as "root";
grant delete on "root".log_record to "public" as "root";
grant index on "root".log_record to "public" as "root";
grant select on "root".catalog to "public" as "root";
grant update on "root".catalog to "public" as "root";
grant insert on "root".catalog to "public" as "root";
grant delete on "root".catalog to "public" as "root";
grant index on "root".catalog to "public" as "root";


 


create view "root".custview (firstname,lastname,company,city) as 
  select x0.fname ,x0.lname ,x0.company ,x0.city from "root".customer 
    x0 where (x0.city = 'Redwood City' ) with check option;    
create view "root".someorders (custnum,ocustnum,newprice) as 
  select x0.order_num ,x1.order_num ,(x1.total_price * '$1.5' ) from 
    "root".orders x0 ,"root".items x1 where ((x0.order_num = x1.order_num 
    ) AND (x1.total_price > '$100' ) ) ;                      

grant select on "root".custview to "public" as "root";
grant update on "root".custview to "public" as "root";
grant insert on "root".custview to "public" as "root";
grant delete on "root".custview to "public" as "root";



create trigger "root".upqty_i update of quantity on "root".items referencing 
    old as pre_upd new as post_upd
    for each row
        (
        insert into "root".log_record (item_num,ord_num,username,
            update_time,old_qty,new_qty)  values (pre_upd.item_num 
            ,pre_upd.order_num ,USER ,CURRENT year to fraction(3),
            pre_upd.quantity ,post_upd.quantity ));


