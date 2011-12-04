{ DATABASE dbtarget  delimiter | }

{ TABLE newtable row size = 94 number of columns = 6 index size = 12 }

create table newtable 
  (
    customer_num serial not null,
    has_ordered char(1),
    check (has_ordered IN ('T', 'F')),
    primary key (customer_num)
  ) extent size 32 next size 32 lock mode page;
revoke all on newtable from "public";

{ TABLE customer row size = 134 number of columns = 10 index size = 61 
              }

create table customer 
  (
    customer_num serial not null,
    lname char(15),
    fname char(15),
    company char(20),
    address1 char(20),
    address2 char(20),
    city char(15),
    state char(2),
    zipcode char(5),
    phone char(18),
    primary key (customer_num)
  ) extent size 32 next size 32 lock mode page;
revoke all on customer from "public";

create index zip_ix on customer (zipcode);
create index add_ix on customer (address1);
{ TABLE orders row size = 84 number of columns = 10 index size = 24 }

create table orders 
  (
    order_num serial not null,
    order_date datetime year to second,
    customer_num integer not null,
    ship_instruct char(40),
    backlog char(1),
    po_num char(10),
    ship_date date,
    ship_weight decimal(8,2),
    ship_charge money(6,2),
    paid_date date,
    primary key (order_num)
  ) extent size 32 next size 32 lock mode page;
revoke all on orders from "public";

{ TABLE manufact row size = 21 number of columns = 3 index size = 10 }

create table manufact 
  (
    manu_code char(3),
    manu_name char(15),
    lead_time interval day(3) to day,
    primary key (manu_code)
  ) extent size 32 next size 32 lock mode page;
revoke all on manufact from "public";

{ TABLE stock row size = 43 number of columns = 6 index size = 24 }

create table stock 
  (
    stock_num smallint,
    description char(15),
    unit_price money(6,2),
    unit char(4),
    manu_code char(3),
    unit_descr char(15),
    primary key (stock_num,manu_code)
  ) extent size 32 next size 32 lock mode page;
revoke all on stock from "public";

{ TABLE items row size = 18 number of columns = 6 index size = 40 }

create table items 
  (
    item_num smallint,
    order_num integer,
    stock_num smallint not null,
    manu_code char(3) not null,
    quantity smallint,
    total_price money(8,2),
    
    check (quantity >= 1 ),
    primary key (item_num,order_num)
  ) extent size 32 next size 32 lock mode page;
revoke all on items from "public";

{ TABLE state row size = 17 number of columns = 2 index size = 9 }

create table state 
  (
    code char(2),
    sname char(15),
    primary key (code)
  ) extent size 32 next size 32 lock mode page;
revoke all on state from "public";

{ TABLE call_type row size = 31 number of columns = 2 index size = 7 }

create table call_type 
  (
    call_code char(1),
    code_descr char(30),
    primary key (call_code)
  ) extent size 32 next size 32 lock mode page;
revoke all on call_type from "public";

{ TABLE cust_calls row size = 517 number of columns = 7 index size = 42 
              }

create table cust_calls 
  (
    customer_num integer,
    call_dtime datetime year to minute,
    user_id char(18) 
        default user,
    call_code char(1),
    call_descr char(240),
    res_dtime datetime year to minute,
    res_descr char(240),
    primary key (customer_num,call_dtime)
  ) extent size 32 next size 32 lock mode page;
revoke all on cust_calls from "public";

{ TABLE log_record row size = 22 number of columns = 6 index size = 0 }

create table log_record 
  (
    item_num smallint,
    ord_num integer,
    username char(8),
    update_time date,
    old_qty smallint,
    new_qty smallint
  ) extent size 32 next size 32 lock mode page;
revoke all on log_record from "public";

{ TABLE catalog row size = 777 number of columns = 6 index size = 25 }

create table catalog 
  (
    catalog_num serial not null,
    stock_num smallint not null,
    manu_code char(3) not null,
    cat_descr varchar(255),
    cat_picture varchar(255),
    cat_advert varchar(255,65),
    primary key (catalog_num)
  ) extent size 32 next size 32 lock mode page;
revoke all on catalog from "public";


alter table orders add constraint (foreign key (customer_num) 
    references customer );

alter table stock add constraint (foreign key (manu_code) 
    references manufact );

alter table items add constraint (foreign key (order_num) 
    references orders );

alter table items add constraint (foreign key (stock_num,manu_code) 
    references stock );

alter table cust_calls add constraint (foreign key (customer_num) 
    references customer );

alter table cust_calls add constraint (foreign key (call_code) 
    references call_type );

alter table catalog add constraint (foreign key (stock_num,
    manu_code) references stock  constraint aa);


grant select on customer to "public";
grant update on customer to "public";
grant insert on customer to "public";
grant delete on customer to "public";
grant index on customer to "public";
grant select on orders to "public";
grant update on orders to "public";
grant insert on orders to "public";
grant delete on orders to "public";
grant index on orders to "public";
grant select on manufact to "public";
grant update on manufact to "public";
grant insert on manufact to "public";
grant delete on manufact to "public";
grant index on manufact to "public";
grant select on stock to "public";
grant update on stock to "public";
grant insert on stock to "public";
grant delete on stock to "public";
grant index on stock to "public";
grant select on items to "public";
grant update on items to "public";
grant insert on items to "public";
grant delete on items to "public";
grant index on items to "public";
grant select on state to "public";
grant update on state to "public";
grant insert on state to "public";
grant delete on state to "public";
grant index on state to "public";
grant select on call_type to "public";
grant update on call_type to "public";
grant insert on call_type to "public";
grant delete on call_type to "public";
grant index on call_type to "public";
grant select on cust_calls to "public";
grant update on cust_calls to "public";
grant insert on cust_calls to "public";
grant delete on cust_calls to "public";
grant index on cust_calls to "public";
grant select on log_record to "public";
grant update on log_record to "public";
grant insert on log_record to "public";
grant delete on log_record to "public";
grant index on log_record to "public";
grant select on catalog to "public";
grant update on catalog to "public";
grant insert on catalog to "public";
grant delete on catalog to "public";
grant index on catalog to "public";



 


create view custview (firstname,lastname,company,city) as 
  select x0.fname ,x0.lname ,x0.company ,x0.city from customer 
    x0 where (x0.city = 'Redwood City' ) with check option;               
                                                   
create view someorders (custnum,ocustnum,newprice) as 
  select x0.order_num ,x1.order_num ,(x1.total_price * '$1.5' ) from 
    orders x0 ,items x1 where ((x0.order_num = x1.order_num 
    ) AND (x1.total_price > '$100' ) ) ;             

grant select on custview to "public";
grant update on custview to "public";
grant insert on custview to "public";
grant delete on custview to "public";



create trigger upqty_i update of quantity on items referencing 
    old as pre_upd new as post_upd
    for each row
        (
        insert into log_record (item_num,ord_num,username,
            update_time,old_qty,new_qty)  values (pre_upd.item_num 
            ,pre_upd.order_num ,USER ,CURRENT year to fraction(3),
            pre_upd.quantity ,post_upd.quantity ));



 

