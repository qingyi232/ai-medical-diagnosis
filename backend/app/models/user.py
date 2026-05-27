from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from app import db


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(80), unique=True, nullable=False, comment='用户名')
    password_hash = db.Column(db.String(256), nullable=False, comment='密码哈希')
    real_name = db.Column(db.String(50), nullable=True, comment='真实姓名')
    role = db.Column(db.String(20), default='doctor', comment='角色: admin/doctor')
    department = db.Column(db.String(100), nullable=True, comment='科室')
    phone = db.Column(db.String(20), nullable=True, comment='联系电话')
    email = db.Column(db.String(120), nullable=True, comment='邮箱')
    avatar = db.Column(db.String(256), nullable=True, comment='头像URL')
    status = db.Column(db.Integer, default=1, comment='状态: 0禁用 1启用')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'real_name': self.real_name,
            'role': self.role,
            'department': self.department,
            'phone': self.phone,
            'email': self.email,
            'avatar': self.avatar,
            'status': self.status,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }
