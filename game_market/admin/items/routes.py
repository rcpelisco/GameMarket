from flask import Blueprint, render_template, request, redirect, url_for, session, g
from game_market import db, ROOT_DIR
from game_market.models import Item
import os
import datetime
import random

items = Blueprint('admin.items', __name__)

@items.before_request
def before_request():
    g.user = None
    if 'user' in session:
        g.user = session['user']

@items.route('/')
def index():
    if g.user:
        items = Item(db).all()
        return render_template('admin/items/index.html', items=items)
    return redirect(url_for('admin.users.login'))

@items.route('/create')
def create():
    return render_template('admin/items/create.html')
    
@items.route('/save', methods=['POST'])
def save():
    
    img_path = ''
    image = None

    if('image' in request.files):
        image = request.files['image']
        img_path = image.filename
    
    relative_path = os.path.join('static', 'uploads', 'img')
    path_target = os.path.join(ROOT_DIR, relative_path)

    if img_path != '' and image != None:
        img_path = convert_filename(img_path)
        save_img_path = os.path.join(path_target, img_path)
        image.save(save_img_path)

    item_data = {
        'name': request.form['name'],
        'description': request.form['description'],
        'price': request.form['price'],
        'img_path': img_path
    } 

    item = Item(db, item_data)
    item.save()

    return redirect(url_for('admin.items.index'))

@items.route('/edit/<item>')
def edit(item):
    return render_template('admin/items/edit.html')

@items.route('/view/<item>')
def view(item):
    item = Item(db).get(item)
    return render_template('admin/items/view.html', item=item)

@items.route('/delete/<item>')
def delete(item):
    Item(db).delete(item)
    return redirect(url_for('admin.items.index'))

def convert_filename(filename):
    random_num = random.randint(0, 501)
    ext = os.path.splitext(filename)[1]
    date = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    return "%s-%s%s"%(random_num, date, ext)