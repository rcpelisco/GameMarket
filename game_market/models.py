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

    def save(self):
        hashed = bcrypt.generate_password_hash(self.password).decode('utf-8')

        query = '''INSERT INTO users (`username`, `email`, `password`, `name`)
            values ("{}", "{}", "{}", "{}")'''.format(self.username, self.email, hashed, self.name)
        
        cursor = self.mysql.connection.cursor()
        cursor.execute(query)

        self.mysql.connection.commit()

        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'password': hashed
        }

    def all(self):
        query = 'SELECT * users'

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        return result

    def login(self, cred):
        query = 'SELECT * FROM users WHERE username="{}"'.format(cred['username'])

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()
        
        if result and bcrypt.check_password_hash(result['password'], cred['password']):
            return result
            
        return False

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

    def get(self, id):
        query = 'SELECT * FROM items WHERE id={}'.format(id)

        cursor = self.mysql.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchone()

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
    