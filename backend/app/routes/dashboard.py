from flask import Blueprint
from flask_jwt_extended import jwt_required
from app import db
from app.models.user import User
from app.models.patient import Patient, MedicalRecord
from app.models.knowledge import KnowledgeDocument
from app.models.plan import MedicalPlan
from app.utils.response import success

dashboard_bp = Blueprint('dashboard', __name__)


@dashboard_bp.route('/stats', methods=['GET'])
@jwt_required()
def get_stats():
    """获取仪表盘统计数据"""
    user_count = User.query.count()
    patient_count = Patient.query.count()
    record_count = MedicalRecord.query.count()
    knowledge_count = KnowledgeDocument.query.filter_by(status=1).count()
    vectorized_count = KnowledgeDocument.query.filter_by(is_vectorized=True).count()
    plan_count = MedicalPlan.query.count()
    approved_plan_count = MedicalPlan.query.filter_by(status='approved').count()

    recent_plans = MedicalPlan.query.order_by(
        MedicalPlan.created_at.desc()
    ).limit(5).all()

    recent_records = MedicalRecord.query.order_by(
        MedicalRecord.created_at.desc()
    ).limit(5).all()

    return success({
        'user_count': user_count,
        'patient_count': patient_count,
        'record_count': record_count,
        'knowledge_count': knowledge_count,
        'vectorized_count': vectorized_count,
        'plan_count': plan_count,
        'approved_plan_count': approved_plan_count,
        'recent_plans': [p.to_dict() for p in recent_plans],
        'recent_records': [r.to_dict() for r in recent_records],
    })
