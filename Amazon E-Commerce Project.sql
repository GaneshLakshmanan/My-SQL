---------------------------------------------------------------- Amazon ECommerce Project ----------------------------------------------------------------------------------------
create database ECommerce;
use ECommerce;

----------------------------------------------------------------     Creating Tables    ------------------------------------------------------------------------------------------

-- Account Table

create table account(acc_id int primary key auto_increment,
					 Name varchar(20) not null,
                     Country varchar(20) not null,
                     CountryCode varchar(20) default (+91),
                     MobileOrEmail varchar(30) not null,
                     Password varchar(20) not null);
                     
insert into account(Name,Country,CountryCode,MobileOrEmail,Password)
			 values("Manoj","India",+91,"9025277047","Mano@123"),
				   ("Ganesh","India",+91,"8098541686","Gan@123"),
                   ("Shiva","India",+91,"8884751817","Siv@231");

select("Sign-in") as ' ' from dual;
/* Login Account */
select * from account where MobileOrEmail="9025277047" and Password="Mano@123";

                   
-- Account_info Table

create table account_info(acc_id int primary key,
						  Country varchar(20) not null,
                          Name varchar(20) not null,
                          MobileNo bigint unique not null,
                          PinCode int not null,
                          Flat_company varchar(50) not null,
                          Area varchar(30) not null,
						  Towm_City varchar(30) not null,
                          foreign key(acc_id) references account(acc_id));
                          
insert into account_info(acc_id,Country,Name,MobileNo,PinCode,Flat_company,Area,Towm_City)
				  values(1,"India","Manoj","9025277047",643217,"oops psg","peelamedu","Coimbatore"),
						(2,"India","Ganesh","8098541686",643217,"saibaba colony","town hall","Coimbatore");
                        
select ("Your Account") as ' ' from dual;
/* Create view for address details */
create view address as select Name,MobileNo,Flat_company,Area,Town_City,PinCode,Country from account_info;
select * from address;
                        
-- Department Table

create table department(dep_id int primary key,
						DepName varchar(50) not null,
                        Description varchar(100) not null);
					
insert into department(dep_id,DepName,Description)
				values(1001,"Electronics","Speakers,Headphones,Cameras"),
					  (1002,"Mens Fashion","Clothing,Watches,Shoes,Sunglass"),
                      (1003,"Home,Kitchen","Furniture,Decore,Lightning");
                      
select * from department;
/* select Electronics from department */
select * from department where DepName = "Electronics";


-- ProductType Table

create table productType(productTypeid int primary key,
						 dep_id int not null,
                         product_type varchar(30) not null,
                         foreign key (dep_id) references department(dep_id));
                         
insert into productType(productTypeid,dep_id,product_type)
				 values(10,1002,"Speakers"),
					   (007,1002,"Cameras"),
                       (01,1002,"Headphones"),
                       (100,1002,"Laptop"),
                       (104,1001,"Tablets"),
                       (111,1003,"Watches");
                       
select * from productType;
/* select Laptop from all products */
select * from productType where product_type = "Laptop";

                       
-- Products Table

create table products(prodId varchar(20) primary key,
					  productTypeid int not null,
                      supplierId varchar(20) unique,
                      productName varchar(50) not null,
                      Brand varchar(50) not null,
                      price int not null,
                      descr varchar(100) not null,
                      CustReview int check(CustReview<=5),
                      foreign key (productTypeid) references productType(productTypeid));
                      
insert into products(prodId,productTypeid,supplierId,productName,Brand,price,descr,CustReview)
			  values("VivoBook14",100,"EAHS1001","Asus VivoBook 14","Asus",25000,"14(35.36 cm) FHD, Intel Core i3-1115G4 11th Gen(8GB/256GB SSD",4),
					("VivoBook14s",100,"AHS1475","Asus VivoBook 14","Asus",28000,"14(35.36 cm) FHD, Intel Core i3-1115G4 11th Gen(16GB/512GB SSD",5),
                    ("15s-du3517TU",100,"YDBS325","HP 15s","HP",35000,"11th Gen Intel Core i5-8GB RAM/512GB SSD",5);
                    
select * from products;
select ("Choose Laptop whose rating is 5");
select * from products where CustReview>all(select avg(CustReview) from products);


-- OrdersReview Table

create table ordersReview(orderid varchar(30) primary key,
						  acc_id int not null,
                          supplierId varchar(20) unique not null,
                          prodId varchar(20) unique not null,
                          paymentId varchar(20) unique not null,
                          orderDate date not null,
                          Qty int default (1),
                          foreign key(acc_id) references account_info(acc_id),
                          foreign key(supplierId) references products(supplierId),
                          foreign key(prodId) references products(prodId));
				
insert into ordersReview(orderid,acc_id,supplierId,prodId,paymentId,orderDate,Qty)
				  values("040-01145",1,"YDBS325","15s-du3517TU","404-14755","2024-02-03",1),
						("050-01146",2,"AHS1475","VivoBook14s","405-14756","2024-02-05",1);
                        
select * from ordersReview;


		
-- CardPayment Table

create table cardPayment(paymentId varchar(20) primary key,
						 acc_id int not null,
                         cardNo bigint unique not null,
                         validFrom year not null,
                         validTill year not null,
                         foreign key(paymentId) references ordersReview(paymentId),
                         foreign key(acc_id) references account_info(acc_id));
                         
insert into cardPayment(paymentId,acc_id,cardNo,validFrom,validTill)
				 values("404-14755",1,"6428548845557455","2017","2027"),
					   ("405-14756",2,"7628458854444754","2018","2028");
                       
create view orderDetails as
select ordersReview.orderid,account_info.acc_id,ordersReview.prodId,products.productName,products.Brand,products.price,account_info.name,
account_info.MobileNo,account_info.Flat_company,account_info.area,account_info.town_city,account_info.country,account_info.pincode from
((ordersReview join products on ordersReview.prodId=products.prodId) join account_info on ordersReview.acc_id=account_info.acc_id);

select * from orderDetails;

select products.prodId,products.productName as Product,products.Brand as Brand,products.price as Amount_to_pay,
ordersReview.orderDate as orderDate from products join ordersReview on ordersReview.prodId=products.prodId;

select * from cardPayment;

select ("Payment Successful!") as "processing..." from dual;