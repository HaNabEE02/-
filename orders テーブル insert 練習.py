import pyodbc, random as r, time

server = r'HANABI\SQLEXPRESS'
database = 'UNIV'
username = 'tom'
password = 'tom123'
con_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

conn = pyodbc.connect(con_string)
cursor = conn.cursor()

insert_query = """INSERT INTO ORDERS VALUES(?, ?, ?, ?, ?, ?, ?); """


ord_check = "select order_id from orders"
cursor.execute(ord_check)
exi_ord_ids = {row[0] for row in cursor.fetchall()}

order_id = r.randint(3000, 4000)

while order_id in exi_ord_ids :
        order_id += 1

user_id = r.randint(1, 5)
product_id = r.randint(1001, 1010)
data_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
quantity = r.randint(1,5)
time_order = r.randint(0,1)


query = "select cost from products where product_id = ?"
cursor.execute(query, (product_id))
result = cursor.fetchone()
cost = int(result[0])

revenue = cost * quantity

if time_order == 1 :
        if product_id == 1010 :
                print("Please use another payment method.")
        else :
                user_query = "select charged_time from users where user_id = ?"
                cursor.execute(user_query, (user_id))
                user_result = cursor.fetchone()
                user_result = int(user_result[0])
                pre_user_result = user_result
                user_result =  int(revenue / 100 * 6)
                if user_result < 0 :
                        user_result = pre_user_result
                        print("Error : user_result cannot be negative")
                        print("Please recharge your PC room usage time or use another payment method.")
                else :
                        user_ch = "update users set charged_time = ? where user_id = ?"
                        cursor.execute(user_ch, (user_result, user_id))
                        cursor.execute(insert_query, (order_id, user_id, product_id, data_time, quantity, revenue, time_order))
                        conn.commit()
                        print(f"Data inserted successfully with ORDER_ID: {order_id}")
else :
        cursor.execute(insert_query, (order_id, user_id, product_id, data_time, quantity, revenue, time_order))
        conn.commit()
        print(f"Data inserted successfully with ORDER_ID: {order_id}")

cursor.close()
conn.close()

