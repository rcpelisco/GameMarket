from flask import Blueprint, render_template, redirect, url_for, session
from game_market import db
from game_market.models import Item

front_page = Blueprint('front_page', __name__)

@front_page.route('/')
def index():
    items = Item(db).all_active()
    user = session['user'] if 'user' in session else None
    return render_template('front_page/index.html', items=items, user=user)
