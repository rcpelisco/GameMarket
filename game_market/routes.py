from flask import Blueprint, render_template
from game_market import db, bcrypt
from game_market.models import User

game_market = Blueprint('game_market', __name__)

@game_market.route('/')
def index():
    return render_template('index.html')

