from flask import Blueprint, render_template, redirect, url_for, g, session, request
from game_market import db
from game_market.models import Item, Cart

items = Blueprint('items', __name__)

@items.before_request
def before_request():
    g.user = None
    if 'user' in session:
        g.user = session['user']

@items.route('/view/<item>', methods=['GET'])
def view(item):
    item = Item(db).get(item)
    user = session['user'] if 'user' in session else None
    return render_template('front_page/items/view.html', 
        user=user, item=item)

@items.route('/pay/<item>', methods=['GET'])
def pay(item):
    Cart(db).pay(item)
    return redirect(url_for('users.account'))

@items.route('/delete/<item>', methods=['GET'])
def delete(item):
    Cart(db).delete(item)
    return redirect(url_for('users.account'))
 
@items.route('/add_to_cart/<item>', methods=['GET', 'POST'])
def add_to_cart(item):
    item = Item(db).add_to_cart(item, session['user']['id'])
    return redirect(url_for('users.account'))