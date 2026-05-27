from datetime import datetime
from app import db


class MedicalPlan(db.Model):
    __tablename__ = 'medical_plans'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    record_id = db.Column(db.Integer, db.ForeignKey('medical_records.id'), nullable=True, comment='关联病历ID')
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=True, comment='患者ID')
    title = db.Column(db.String(256), nullable=False, comment='方案标题')
    input_text = db.Column(db.Text, nullable=False, comment='输入的病例信息')
    retrieved_context = db.Column(db.Text, nullable=True, comment='RAG检索到的上下文')
    generated_plan = db.Column(db.Text, nullable=False, comment='生成的医疗方案')
    diagnosis_suggestion = db.Column(db.Text, nullable=True, comment='诊断建议')
    treatment_suggestion = db.Column(db.Text, nullable=True, comment='治疗建议')
    medication_suggestion = db.Column(db.Text, nullable=True, comment='用药建议')
    examination_suggestion = db.Column(db.Text, nullable=True, comment='检查建议')
    lifestyle_suggestion = db.Column(db.Text, nullable=True, comment='生活方式建议')
    follow_up_suggestion = db.Column(db.Text, nullable=True, comment='随访建议')
    confidence_score = db.Column(db.Float, nullable=True, comment='置信度评分')
    reference_sources = db.Column(db.Text, nullable=True, comment='参考来源')
    doctor_feedback = db.Column(db.Text, nullable=True, comment='医生反馈')
    rating = db.Column(db.Integer, nullable=True, comment='评分 1-5')
    generated_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='生成人')
    status = db.Column(db.String(20), default='generated', comment='状态: generated/reviewed/approved/rejected')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')

    patient = db.relationship('Patient', backref='plans')

    def to_dict(self):
        return {
            'id': self.id,
            'record_id': self.record_id,
            'patient_id': self.patient_id,
            'title': self.title,
            'input_text': self.input_text,
            'retrieved_context': self.retrieved_context,
            'generated_plan': self.generated_plan,
            'diagnosis_suggestion': self.diagnosis_suggestion,
            'treatment_suggestion': self.treatment_suggestion,
            'medication_suggestion': self.medication_suggestion,
            'examination_suggestion': self.examination_suggestion,
            'lifestyle_suggestion': self.lifestyle_suggestion,
            'follow_up_suggestion': self.follow_up_suggestion,
            'confidence_score': self.confidence_score,
            'reference_sources': self.reference_sources,
            'doctor_feedback': self.doctor_feedback,
            'rating': self.rating,
            'status': self.status,
            'patient_name': self.patient.name if self.patient else None,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }
