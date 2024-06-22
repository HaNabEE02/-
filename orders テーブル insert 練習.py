import pyodbc, random as r, time

server = r'HANABI\SQLEXPRESS'
database = 'UNIV'
username = 'tom'
password = 'tom123'
con_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

conn = pyodbc.connect(con_string)
cursor = conn.cursor()

insert_query = """INSERT INTO ORDERS VALUES(?, ?, ?, ?, ?, ?, ?); """

order_id = r.randint(3000, 4000)
ord_check = "select order_id from orders"
cursor.execute(ord_check)
exi_ord_ids = {row[0] for row in cursor.fetchall()}


while order_id in exi_ord_ids :
        order_id += 1


user_id = int(input("お客様のIDを入力してください："))
user_check = "select user_id from users"
cursor.execute(user_check)
exi_use_ids = {row[0] for row in cursor.fetchall()}

while user_id not in exi_use_ids :
        user_id = int(input("IDの入力が間違っています。\n 再度入力してください："))

print("商品リスト")
product_check = "select product_id, product_name, cost from products"
cursor.execute(product_check)
exi_pro_all = [list(row) for row in cursor.fetchall()]


print(f"{'商品ID':<10} {'商品名':<20} {'商品値段':<10}")


for n in exi_pro_all :
        product_id = n[0]
        product_name = n[1].strip()
        product_price = n[2]
        print(f"{product_id:<10} {product_name:<20} {product_price:<10}")
exi_pro_ids = []
exi_pro_names = []
exi_pro_prices = []
for n in range(len(exi_pro_all)) :
        exi_pro_ids.append(str(exi_pro_all[n][0]))
        exi_pro_names.append(exi_pro_all[n][1].strip())
        exi_pro_prices.append(exi_pro_all[n][2])

product_id = input("注文する商品のIDまたは、商品の名前をお選びください：")

while product_id not in exi_pro_ids and product_id not in exi_pro_names :
        product_id = input("IDの入力が間違っています。\n 再度入力してください：")

if product_id in exi_pro_names :
        product_id = exi_pro_ids[exi_pro_names.index(product_id)]

data_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

quantity = int(input("商品の注文数量を入力してください："))

while quantity > 10 :
        quantity = int(input("商品の注文は一回に１０個以上はご購入できません。\n再度入力してください："))

query = "select cost from products where product_id = ?"
cursor.execute(query, (product_id))
result = cursor.fetchone()
cost = int(result[0])

revenue = cost * quantity
rev_time = int(revenue / 100 * 6)

user_query = "select charged_time from users where user_id = ?"
cursor.execute(user_query, (user_id))
user_result = cursor.fetchone()
user_result = int(user_result[0])
pre_user_result = user_result
user_result -= rev_time

if user_result < 0 or product_id == 1010 :
        user_result = pre_user_result
        print("利用時間を使って決済できません。")
        print("自動的に他の決済に移します。")
        time_order = 0
        time_order_chr = "クレジットカードまたは、現金"
else :
        print("利用時間を使って決済できます。")
        print("現在お客様の残りの時間：" + str(pre_user_result) + "\n総価格：" + str(rev_time) + "\n決済後残りの時間：" + str(user_result))
        time_order_chr = input("利用時間を使いますか？\n [YES, NO] \n")
        if time_order_chr in ["YES", "yes", "y", "Y", "はい"] :
                time_order = 1
                time_order_chr = "利用時間"
        else :
                user_result = pre_user_result
                time_order = 0
                time_order_chr = "クレジットカードまたは、現金"

if time_order == 1:
        print(f" ID：{user_id} \n 注文商品：{exi_pro_names[exi_pro_ids.index(product_id)]} \n 注文数量：{quantity} \n 総価格：{rev_time} \n 決済：{time_order_chr}")
else :
        print(f" ID：{user_id} \n 注文商品：{exi_pro_names[exi_pro_ids.index(product_id)]} \n 注文数量：{quantity} \n 総価格：{revenue} \n 決済：{time_order_chr}")

response = input("このまま決済を進みますか？\n [YES, NO] \n ")
if response in ["NO", "N", "n", "no", "いいえ"] :
        print("決済がキャンセルされました")
else :
        if time_order == 1:
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
