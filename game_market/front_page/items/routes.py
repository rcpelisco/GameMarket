from flask import Blueprint, render_template, redirect, url_for, g, session, request
from game_market import db
from game_market.models import Item

items = Blueprint('items', __name__)

@items.route('/view/<item>', methods=['GET'])
def view(item):
    item = Item(db).get(item)
    user = session['user'] if 'user' in session else None
    return render_template('front_page/items/view.html', 
        user=user, item=item)
 
@items.route('/add_to_cart/<item>', methods=['GET', 'POST'])
def add_to_cart(item):
    item = Item(db).add_to_cart(item, session['user']['id'])

    return redirect(url_for('items.view', item=item))