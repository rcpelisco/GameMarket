from flask import Blueprint, render_template, request, redirect, url_for, session, g
from game_market import db
from game_market.models import User

users = Blueprint('admin.users', __name__)

@users.before_request
def before_request():
    g.user = None
    if 'user' in session:
        g.user = session['user']

@users.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        credentials = {
            'username': request.form['username'],
            'password': request.form['password']
        }

        user = User(db).login(credentials)

        if user:
            session['user'] = user
            g.user = user

    if g.user:
        return redirect(url_for('admin.items.index'))
    return render_template('admin/login.html')

@users.route('/register')
def register():
    if request.method == 'POST':
        credentials = {
            'username': request.form['username'],
            'password': request.form['password']
        }

        user = User(db).login(credentials)

        if user:
            session['user'] = user
            g.user = user

    if g.user:
        users = Item(db).all() 
        return render_template('admin/users/index.html', users=users)

    return render_template('admin/register.html')
    
@users.route('/logout')
def logout():
    session.pop('user')
    return redirect(url_for('front_page.index'))
    