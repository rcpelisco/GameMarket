from datetime import datetime
from game_market import bcrypt

class User(object):
    def __init__(self, mysql, user_data=None):
        self.mysql = mysql
        
        self.id = 0
        self.username = user_data['username'] if not user_data == None else None
        self.email = user_data['email'] if not user_data == None else None
        self.name = user_data['name'] if not user_data == None else None
        self.password = user_data['password'] if not user_data == None else None
        self.created_at = None
        self.is_admin = user_data['is_admin'] if not user_data == None else False

    def save(self):
        hashed = bcrypt.generate_password_hash(self.password).decode('utf-8')

        query = '''INSERT INTO users (`username`, `email`, `password`, `name`, `is_admin`)
            values ("{}", "{}", "{}", "{}", "{}")'''.format(self.username, self.email, 
            hashed, self.name, self.is_admin)
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

    def all(self):
        query = 'SELECT * users'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def login(self, cred):
        query = 'SELECT * FROM users WHERE username="{}"'.format(
            cred['username'])

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()
        
        if result and bcrypt.check_password_hash(result['password'], 
            cred['password']):
            return result
            
        return False
    
    def get_history(self, id):
        query = '''
        SELECT
            `items`.`name`,
            `transaction_history`.`action`,
            `transaction_history`.`created_at`
        FROM
            `items`,
            `users`,
            `transaction_history`
        WHERE
            `transaction_history`.`item_id`=`items`.`id` AND
            `transaction_history`.`user_id`=`users`.`id` AND
            `transaction_history`.`user_id`={}
        '''.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

class Item(object):
    def __init__(self, mysql, item_data=None):
        self.mysql = mysql
        
        self.id = 0
        self.name = item_data['name'] if not item_data == None else None
        self.description = item_data['description'] if not item_data == None else None
        self.price = item_data['price'] if not item_data == None else None
        self.img_path = item_data['img_path'] if not item_data == None else None
        self.created_at = None

    def save(self):
        query = '''INSERT INTO items (`name`, `description`, `price`, `img_path`)
            VALUES ("{}", "{}", "{}", "{}")'''.format(self.name, self.description, 
            self.price, self.img_path)
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

    def update(self, item_data):
        query = 'UPDATE items SET `name`="{}", `description`="{}", `price`="{}" WHERE `id` = {}'.format(item_data['name'], item_data['description'], item_data['price'], item_data['id'])
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

    def get(self, id):
        query = 'SELECT * FROM items WHERE id={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()

        return result

    def all_active(self):
        query = 'SELECT * FROM get_all_active_items'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def all(self):
        query = 'SELECT * FROM items'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def delete(self, id):
        query = 'DELETE FROM items WHERE id={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

    def add_to_cart(self, id, user_id):
        query = 'INSERT INTO cart (`item_id`, `user_id`) VALUES ({}, {})'.format(id, user_id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

        return id

class Cart(object):
    def __init__(self, mysql, item_data=None):
        self.mysql = mysql
        
        self.id = 0
        self.item_id = item_data['item_id'] if not item_data == None else None
        self.user_id = item_data['user_id'] if not item_data == None else None
        self.is_paid = item_data['is_paid'] if not item_data == None else None
        self.created_at = None

    def get_user_all_unpaid_items(self, id):
        query = 'SELECT * FROM `get_user_all_unpaid_items` WHERE `user_id`={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def get_user_all_paid_items(self, id):
        query = 'SELECT * FROM `get_user_all_paid_items` WHERE `user_id`={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def get(self, id):
        query = 'SELECT * FROM cart WHERE id={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()

        return result

    def all(self):
        query = 'SELECT * FROM cart'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result
        
    def pay(self, id):
        query = 'UPDATE cart SET `is_paid`=1 WHERE `id`={}'.format(id)
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        
        self.mysql.connection.commit()

    def delete(self, id):
        query = 'DELETE FROM cart WHERE `id` = {}'.format(id)
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()
        
class TransactionHistory(object):
    def __init__(self, mysql):
        self.mysql = mysql

    def get_user_all(self, id):
        query = 'SELECT * FROM `get_user_transaction_history` WHERE `user_id`={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def get(self, id):
        query = 'SELECT * FROM cart WHERE id={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()

        return result

    def all(self):
        query = 'SELECT * FROM cart'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

