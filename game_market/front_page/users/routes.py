from flask import Blueprint, render_template, redirect, url_for, g, session, request
from game_market import db
from game_market.models import User
users = Blueprint('users', __name__)

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
        if user['is_admin']:
            return redirect(url_for('admin.index'))
        return redirect(url_for('front_page.index'))
    return render_template('front_page/login.html')
 
@users.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user_data = {
            'name': request.form['name'],
            'email': request.form['email'],
            'username': request.form['username'],
            'password': request.form['password'],
            'is_admin': 0,
        }

        user = User(db, user_data)
        user.save()
        return redirect(url_for('users.login'))

    return render_template('front_page/register.html')
 
@users.route('/transaction_history', methods=['GET'])
def transaction_history():
    history = User(db).get_history(session['user']['id'])
    print(history)
    return render_template('front_page/register.html',
        transaction_history=transaction_history,
        user=session['user'])
