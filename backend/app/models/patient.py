from datetime import datetime
from app import db


class Patient(db.Model):
    __tablename__ = 'patients'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    patient_no = db.Column(db.String(50), unique=True, nullable=False, comment='患者编号')
    name = db.Column(db.String(50), nullable=False, comment='患者姓名')
    gender = db.Column(db.String(10), nullable=True, comment='性别')
    age = db.Column(db.Integer, nullable=True, comment='年龄')
    phone = db.Column(db.String(20), nullable=True, comment='联系电话')
    id_card = db.Column(db.String(18), nullable=True, comment='身份证号(脱敏)')
    blood_type = db.Column(db.String(10), nullable=True, comment='血型')
    allergy_history = db.Column(db.Text, nullable=True, comment='过敏史')
    medical_history = db.Column(db.Text, nullable=True, comment='既往病史')
    family_history = db.Column(db.Text, nullable=True, comment='家族病史')
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='创建人')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')

    records = db.relationship('MedicalRecord', backref='patient', lazy='dynamic')

    def to_dict(self):
        return {
            'id': self.id,
            'patient_no': self.patient_no,
            'name': self.name,
            'gender': self.gender,
            'age': self.age,
            'phone': self.phone,
            'id_card': self.id_card,
            'blood_type': self.blood_type,
            'allergy_history': self.allergy_history,
            'medical_history': self.medical_history,
            'family_history': self.family_history,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }


class MedicalRecord(db.Model):
    __tablename__ = 'medical_records'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False, comment='患者ID')
    record_no = db.Column(db.String(50), unique=True, nullable=False, comment='病历编号')
    visit_date = db.Column(db.Date, nullable=True, comment='就诊日期')
    department = db.Column(db.String(100), nullable=True, comment='就诊科室')
    chief_complaint = db.Column(db.Text, nullable=True, comment='主诉')
    present_illness = db.Column(db.Text, nullable=True, comment='现病史')
    past_history = db.Column(db.Text, nullable=True, comment='既往史')
    physical_exam = db.Column(db.Text, nullable=True, comment='体格检查')
    lab_results = db.Column(db.Text, nullable=True, comment='实验室检查结果')
    imaging_results = db.Column(db.Text, nullable=True, comment='影像学检查结果')
    diagnosis = db.Column(db.Text, nullable=True, comment='诊断')
    diagnosis_type = db.Column(db.String(50), nullable=True, comment='诊断类型: 初诊/复诊/确诊')
    treatment = db.Column(db.Text, nullable=True, comment='治疗方案')
    prescription = db.Column(db.Text, nullable=True, comment='处方用药')
    notes = db.Column(db.Text, nullable=True, comment='备注')
    doctor_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='主治医生')
    status = db.Column(db.String(20), default='active', comment='状态: active/archived')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')

    def to_dict(self):
        return {
            'id': self.id,
            'patient_id': self.patient_id,
            'record_no': self.record_no,
            'visit_date': self.visit_date.strftime('%Y-%m-%d') if self.visit_date else None,
            'department': self.department,
            'chief_complaint': self.chief_complaint,
            'present_illness': self.present_illness,
            'past_history': self.past_history,
            'physical_exam': self.physical_exam,
            'lab_results': self.lab_results,
            'imaging_results': self.imaging_results,
            'diagnosis': self.diagnosis,
            'diagnosis_type': self.diagnosis_type,
            'treatment': self.treatment,
            'prescription': self.prescription,
            'notes': self.notes,
            'doctor_id': self.doctor_id,
            'status': self.status,
            'patient_name': self.patient.name if self.patient else None,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S') if self.created_at else None,
        }

    def to_text(self):
        """将病历转为文本用于RAG检索"""
        parts = []
        if self.chief_complaint:
            parts.append(f"主诉：{self.chief_complaint}")
        if self.present_illness:
            parts.append(f"现病史：{self.present_illness}")
        if self.past_history:
            parts.append(f"既往史：{self.past_history}")
        if self.physical_exam:
            parts.append(f"体格检查：{self.physical_exam}")
        if self.lab_results:
            parts.append(f"实验室检查：{self.lab_results}")
        if self.imaging_results:
            parts.append(f"影像学检查：{self.imaging_results}")
        if self.diagnosis:
            parts.append(f"诊断：{self.diagnosis}")
        if self.treatment:
            parts.append(f"治疗方案：{self.treatment}")
        if self.prescription:
            parts.append(f"处方用药：{self.prescription}")
        return '\n'.join(parts)
