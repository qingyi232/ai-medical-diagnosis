from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models.user import User
from app.utils.response import success, error, paginate_response

user_bp = Blueprint('user', __name__)


def admin_required():
    user_id = int(get_jwt_identity())
    user = User.query.get(user_id)
    if not user or user.role != 'admin':
        return False
    return True


@user_bp.route('', methods=['GET'])
@jwt_required()
def get_users():
    if not admin_required():
        return error('无权限访问', 403)

    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    keyword = request.args.get('keyword', '').strip()
    role = request.args.get('role', '').strip()

    query = User.query
    if keyword:
        query = query.filter(
            db.or_(
                User.username.like(f'%{keyword}%'),
                User.real_name.like(f'%{keyword}%'),
            )
        )
    if role:
        query = query.filter_by(role=role)

    query = query.order_by(User.created_at.desc())
    data = paginate_response(query, page, per_page)
    return success(data)


@user_bp.route('', methods=['POST'])
@jwt_required()
def create_user():
    if not admin_required():
        return error('无权限操作', 403)

    data = request.get_json()
    username = data.get('username', '').strip()
    password = data.get('password', '')

    if not username or not password:
        return error('用户名和密码不能为空')
    if len(password) < 6:
        return error('密码长度不能少于6位')
    if User.query.filter_by(username=username).first():
        return error('用户名已存在')

    user = User(
        username=username,
        real_name=data.get('real_name', ''),
        role=data.get('role', 'doctor'),
        department=data.get('department', ''),
        phone=data.get('phone', ''),
        email=data.get('email', ''),
    )
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return success(user.to_dict(), '用户创建成功')


@user_bp.route('/<int:user_id>', methods=['PUT'])
@jwt_required()
def update_user(user_id):
    if not admin_required():
        return error('无权限操作', 403)

    user = User.query.get(user_id)
    if not user:
        return error('用户不存在', 404)

    data = request.get_json()
    for field in ['real_name', 'role', 'department', 'phone', 'email', 'status']:
        if field in data:
            setattr(user, field, data[field])

    if data.get('password'):
        if len(data['password']) < 6:
            return error('密码长度不能少于6位')
        user.set_password(data['password'])

    db.session.commit()
    return success(user.to_dict(), '用户更新成功')


@user_bp.route('/<int:user_id>', methods=['DELETE'])
@jwt_required()
def delete_user(user_id):
    if not admin_required():
        return error('无权限操作', 403)

    current_user_id = int(get_jwt_identity())
    if user_id == current_user_id:
        return error('不能删除自己的账号')

    user = User.query.get(user_id)
    if not user:
        return error('用户不存在', 404)

    db.session.delete(user)
    db.session.commit()
    return success(message='用户删除成功')


@user_bp.route('/<int:user_id>/toggle-status', methods=['POST'])
@jwt_required()
def toggle_user_status(user_id):
    if not admin_required():
        return error('无权限操作', 403)

    user = User.query.get(user_id)
    if not user:
        return error('用户不存在', 404)

    user.status = 0 if user.status == 1 else 1
    db.session.commit()
    return success(user.to_dict(), f"用户已{'启用' if user.status == 1 else '禁用'}")
