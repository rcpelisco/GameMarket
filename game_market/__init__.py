from flask import Flask, render_template, url_for
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
import os

app = Flask(__name__)

app.config['SECRET_KEY'] = '6c88248707fc142f0253bd0b33b84bd7'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'game_market'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

db = MySQL(app)
bcrypt = Bcrypt(app)

from game_market.admin.routes import admin
from game_market.admin.users.routes import users as admin_users
from game_market.admin.items.routes import items as admin_items
from game_market.front_page.routes import front_page

app.register_blueprint(admin, url_prefix='/admin')
app.register_blueprint(admin_users, url_prefix='/admin/users')
app.register_blueprint(admin_items, url_prefix='/admin/items')
app.register_blueprint(front_page, url_prefix='/')
