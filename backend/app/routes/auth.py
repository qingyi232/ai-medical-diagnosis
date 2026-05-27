from flask import Blueprint, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app import db
from app.models.user import User
from app.utils.response import success, error

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username', '').strip()
    password = data.get('password', '')

    if not username or not password:
        return error('用户名和密码不能为空')

    user = User.query.filter_by(username=username).first()
    if not user or not user.check_password(password):
        return error('用户名或密码错误')

    if user.status != 1:
        return error('账号已被禁用')

    access_token = create_access_token(identity=str(user.id))
    return success({
        'token': access_token,
        'user': user.to_dict()
    }, '登录成功')


@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username', '').strip()
    password = data.get('password', '')
    real_name = data.get('real_name', '').strip()
    department = data.get('department', '').strip()

    if not username or not password:
        return error('用户名和密码不能为空')

    if len(password) < 6:
        return error('密码长度不能少于6位')

    if User.query.filter_by(username=username).first():
        return error('用户名已存在')

    user = User(
        username=username,
        real_name=real_name,
        department=department,
        role='doctor',
    )
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return success(user.to_dict(), '注册成功')


@auth_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    user_id = int(get_jwt_identity())
    user = User.query.get(user_id)
    if not user:
        return error('用户不存在', 404)
    return success(user.to_dict())


@auth_bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    user_id = int(get_jwt_identity())
    user = User.query.get(user_id)
    if not user:
        return error('用户不存在', 404)

    data = request.get_json()
    if 'real_name' in data:
        user.real_name = data['real_name']
    if 'department' in data:
        user.department = data['department']
    if 'phone' in data:
        user.phone = data['phone']
    if 'email' in data:
        user.email = data['email']

    db.session.commit()
    return success(user.to_dict(), '更新成功')


@auth_bp.route('/change-password', methods=['POST'])
@jwt_required()
def change_password():
    user_id = int(get_jwt_identity())
    user = User.query.get(user_id)
    data = request.get_json()

    old_password = data.get('old_password', '')
    new_password = data.get('new_password', '')

    if not user.check_password(old_password):
        return error('原密码错误')

    if len(new_password) < 6:
        return error('新密码长度不能少于6位')

    user.set_password(new_password)
    db.session.commit()
    return success(message='密码修改成功')
