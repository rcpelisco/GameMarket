from flask import Blueprint, render_template, redirect, url_for
from game_market import db, bcrypt

admin = Blueprint('admin', __name__)

@admin.route('/')
def index():
    return redirect(url_for('admin.items.index'))
