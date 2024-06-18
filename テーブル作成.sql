--drop table orders;
--drop table use_log;
--drop table pc;
--drop table products;
--drop table users;


-- USERS table
CREATE TABLE USERS (
	USER_ID			INT NOT NULL,
	NAME			CHAR(20),
	REGISTER_DATE		DATE,
	BIRTHDAY		DATE NOT NULL,
	CHARGED_TIME		INT DEFAULT 0,
	PHONE_NUM		CHAR(15) CHECK (PHONE_NUM LIKE '010-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	PRIMARY KEY(USER_ID)
);

INSERT INTO USERS VALUES(1, 'Jeon', '2024-05-11', '1999-02-16', 600, '010-4138-5722');
INSERT INTO USERS VALUES(2, 'Kim', '2024-04-11', '1999-05-01', 560, '010-5142-4875');
INSERT INTO USERS VALUES(3, 'Lee', '2023-12-11', '1999-10-28', 180, '010-1563-4587');
INSERT INTO USERS VALUES(4, 'Woo', '2020-10-11', '1999-11-27', 450, '010-4532-6458');
INSERT INTO USERS VALUES(5, 'Jun', '2024-02-16', '1999-11-01', 480, '010-1547-7568');


-- PRODUCTS table
CREATE TABLE PRODUCTS (
	PRODUCT_ID		INT NOT NULL,
	COST			INT,
	PRODUCT_NAME		CHAR(40),
	PRIMARY KEY(PRODUCT_ID),
);

INSERT INTO PRODUCTS VALUES(1001, 3000, 'cup ramen');
INSERT INTO PRODUCTS VALUES(1002, 1500, 'chocolate');
INSERT INTO PRODUCTS VALUES(1003, 4000, 'jelly');
INSERT INTO PRODUCTS VALUES(1004, 6000, 'ramen');
INSERT INTO PRODUCTS VALUES(1005, 4500, 'cheese hot dog');
INSERT INTO PRODUCTS VALUES(1006, 5000, 'coke and chicken');
INSERT INTO PRODUCTS VALUES(1007, 1000, 'pc charge 1hour');
INSERT INTO PRODUCTS VALUES(1008, 3000, 'pc charge 3hour');
INSERT INTO PRODUCTS VALUES(1009, 5000, 'pc charge 5hour');
INSERT INTO PRODUCTS VALUES(1010, 10000, 'pc charge 12hour');


-- PC table
CREATE TABLE PC (
	PC_ID		INT NOT NULL,
	CPU		CHAR(40),
	RAM		CHAR(40),
	IP_ADDRESS	CHAR(40),
	COST		INT,
	PRIMARY KEY(PC_ID)
);

INSERT INTO PC VALUES(4001, 'AMD Ryzen 7', 'Samsung DDR4 16GB', '192.168.25.28', 1500000);
INSERT INTO PC VALUES(4002, 'AMD Ryzen 7', 'Samsung DDR4 16GB', '192.145.2.31', 1500000);
INSERT INTO PC VALUES(4003, 'AMD Ryzen 7', 'Samsung DDR4 16GB', '192.121.12.24', 1500000);
INSERT INTO PC VALUES(4007, 'Intel Core i7', 'Samsung DDR4 16GB', '192.188.45.22', 1900000);
INSERT INTO PC VALUES(4008, 'Intel Core i7', 'Samsung DDR4 16GB', '192.23.23.14', 1900000);
INSERT INTO PC VALUES(4009, 'Intel Core i7', 'Samsung DDR4 16GB', '192.56.89.78', 1900000);


-- USE_LOG table
CREATE TABLE USE_LOG (
	LOG_ID			INT NOT NULL,
	PC_ID			INT,
	USER_ID			INT,
	START_TIME		DATETIME,
	END_TIME		DATETIME,
	PRIMARY KEY(LOG_ID),
	FOREIGN KEY(USER_ID) REFERENCES USERS(USER_ID)
		ON DELETE NO ACTION 
		ON UPDATE CASCADE,
	FOREIGN KEY(PC_ID) REFERENCES PC(PC_ID)
		ON DELETE NO ACTION 
		ON UPDATE CASCADE
);

INSERT INTO USE_LOG VALUES(100501, 4001, 1, '2024-05-11 14:37:00', '2024-05-11 18:13:00');
INSERT INTO USE_LOG VALUES(100502, 4002, 2, '2024-05-11 14:35:00', '2024-05-11 18:14:10');
INSERT INTO USE_LOG VALUES(100503, 4007, 3, '2024-05-11 17:00:00', '2024-05-11 19:13:00');
INSERT INTO USE_LOG VALUES(100504, 4009, 4, '2024-05-11 23:37:00', '2024-05-12 03:24:00');
INSERT INTO USE_LOG VALUES(100505, 4007, 4, '2024-05-12 08:37:00', '2024-05-12 15:24:00');
INSERT INTO USE_LOG VALUES(100506, 4003, 5, '2024-05-18 20:37:00', '2024-05-18 23:35:00');


-- ORDERS table
CREATE TABLE ORDERS (
	ORDER_ID		INT NOT NULL,
	USER_ID			INT,
	PRODUCT_ID		INT,
	DATE_TIME		DATETIME NOT NULL,
	QUANTITY		INT,
	REVENUE			INT,
	TIME_ORDER		BIT DEFAULT 0,
	PRIMARY KEY(ORDER_ID),
	FOREIGN KEY(USER_ID) REFERENCES USERS(USER_ID)
		ON DELETE NO ACTION 
		ON UPDATE CASCADE,
	FOREIGN KEY(PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID) 
		ON DELETE NO ACTION 
		ON UPDATE CASCADE
);

INSERT INTO ORDERS VALUES(3001, 1, 1001, '2024-05-11 15:13:46', 1, 3000, 0);
INSERT INTO ORDERS VALUES(3002, 2, 1001, '2024-05-11 16:13:26', 1, 3000, 0);
INSERT INTO ORDERS VALUES(3003, 3, 1004, '2024-05-11 18:30:57', 1, 6000, 0);
INSERT INTO ORDERS VALUES(3004, 4, 1005, '2024-05-12 01:22:10', 1, 4500, 0);
INSERT INTO ORDERS VALUES(3005, 1, 1002, '2024-05-11 17:35:16', 2, 3000, 0);
INSERT INTO ORDERS VALUES(3006, 4, 1003, '2024-05-12 01:22:12', 1, 4000, 0);

