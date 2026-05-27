import uuid
from datetime import datetime
from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models.patient import Patient, MedicalRecord
from app.utils.response import success, error, paginate_response

patient_bp = Blueprint('patient', __name__)


@patient_bp.route('', methods=['GET'])
@jwt_required()
def get_patients():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    keyword = request.args.get('keyword', '').strip()

    query = Patient.query
    if keyword:
        query = query.filter(
            db.or_(
                Patient.name.like(f'%{keyword}%'),
                Patient.patient_no.like(f'%{keyword}%'),
            )
        )
    query = query.order_by(Patient.created_at.desc())
    data = paginate_response(query, page, per_page)
    return success(data)


@patient_bp.route('/<int:patient_id>', methods=['GET'])
@jwt_required()
def get_patient(patient_id):
    patient = Patient.query.get(patient_id)
    if not patient:
        return error('患者不存在', 404)
    return success(patient.to_dict())


@patient_bp.route('', methods=['POST'])
@jwt_required()
def create_patient():
    user_id = int(get_jwt_identity())
    data = request.get_json()

    if not data.get('name'):
        return error('患者姓名不能为空')

    patient_no = data.get('patient_no') or f"P{datetime.now().strftime('%Y%m%d')}{uuid.uuid4().hex[:6].upper()}"

    if Patient.query.filter_by(patient_no=patient_no).first():
        return error('患者编号已存在')

    patient = Patient(
        patient_no=patient_no,
        name=data['name'],
        gender=data.get('gender'),
        age=data.get('age'),
        phone=data.get('phone'),
        id_card=data.get('id_card'),
        blood_type=data.get('blood_type'),
        allergy_history=data.get('allergy_history'),
        medical_history=data.get('medical_history'),
        family_history=data.get('family_history'),
        created_by=user_id,
    )
    db.session.add(patient)
    db.session.commit()
    return success(patient.to_dict(), '患者创建成功')


@patient_bp.route('/<int:patient_id>', methods=['PUT'])
@jwt_required()
def update_patient(patient_id):
    patient = Patient.query.get(patient_id)
    if not patient:
        return error('患者不存在', 404)

    data = request.get_json()
    for field in ['name', 'gender', 'age', 'phone', 'id_card', 'blood_type',
                  'allergy_history', 'medical_history', 'family_history']:
        if field in data:
            setattr(patient, field, data[field])

    db.session.commit()
    return success(patient.to_dict(), '更新成功')


@patient_bp.route('/<int:patient_id>', methods=['DELETE'])
@jwt_required()
def delete_patient(patient_id):
    patient = Patient.query.get(patient_id)
    if not patient:
        return error('患者不存在', 404)
    db.session.delete(patient)
    db.session.commit()
    return success(message='删除成功')


# ---- 病历管理 ----

@patient_bp.route('/<int:patient_id>/records', methods=['GET'])
@jwt_required()
def get_records(patient_id):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    query = MedicalRecord.query.filter_by(patient_id=patient_id).order_by(MedicalRecord.created_at.desc())
    data = paginate_response(query, page, per_page)
    return success(data)


@patient_bp.route('/records', methods=['GET'])
@jwt_required()
def get_all_records():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    keyword = request.args.get('keyword', '').strip()

    query = MedicalRecord.query
    if keyword:
        query = query.filter(
            db.or_(
                MedicalRecord.diagnosis.like(f'%{keyword}%'),
                MedicalRecord.chief_complaint.like(f'%{keyword}%'),
                MedicalRecord.record_no.like(f'%{keyword}%'),
            )
        )
    query = query.order_by(MedicalRecord.created_at.desc())
    data = paginate_response(query, page, per_page)
    return success(data)


@patient_bp.route('/records/<int:record_id>', methods=['GET'])
@jwt_required()
def get_record(record_id):
    record = MedicalRecord.query.get(record_id)
    if not record:
        return error('病历不存在', 404)
    return success(record.to_dict())


@patient_bp.route('/<int:patient_id>/records', methods=['POST'])
@jwt_required()
def create_record(patient_id):
    user_id = int(get_jwt_identity())
    patient = Patient.query.get(patient_id)
    if not patient:
        return error('患者不存在', 404)

    data = request.get_json()
    record_no = data.get('record_no') or f"R{datetime.now().strftime('%Y%m%d%H%M%S')}{uuid.uuid4().hex[:4].upper()}"

    record = MedicalRecord(
        patient_id=patient_id,
        record_no=record_no,
        visit_date=datetime.strptime(data['visit_date'], '%Y-%m-%d').date() if data.get('visit_date') else datetime.now().date(),
        department=data.get('department'),
        chief_complaint=data.get('chief_complaint'),
        present_illness=data.get('present_illness'),
        past_history=data.get('past_history'),
        physical_exam=data.get('physical_exam'),
        lab_results=data.get('lab_results'),
        imaging_results=data.get('imaging_results'),
        diagnosis=data.get('diagnosis'),
        diagnosis_type=data.get('diagnosis_type'),
        treatment=data.get('treatment'),
        prescription=data.get('prescription'),
        notes=data.get('notes'),
        doctor_id=user_id,
    )
    db.session.add(record)
    db.session.commit()
    return success(record.to_dict(), '病历创建成功')


@patient_bp.route('/records/<int:record_id>', methods=['PUT'])
@jwt_required()
def update_record(record_id):
    record = MedicalRecord.query.get(record_id)
    if not record:
        return error('病历不存在', 404)

    data = request.get_json()
    for field in ['department', 'chief_complaint', 'present_illness', 'past_history',
                  'physical_exam', 'lab_results', 'imaging_results', 'diagnosis',
                  'diagnosis_type', 'treatment', 'prescription', 'notes']:
        if field in data:
            setattr(record, field, data[field])

    if 'visit_date' in data and data['visit_date']:
        record.visit_date = datetime.strptime(data['visit_date'], '%Y-%m-%d').date()

    db.session.commit()
    return success(record.to_dict(), '病历更新成功')


@patient_bp.route('/records/<int:record_id>', methods=['DELETE'])
@jwt_required()
def delete_record(record_id):
    record = MedicalRecord.query.get(record_id)
    if not record:
        return error('病历不存在', 404)
    db.session.delete(record)
    db.session.commit()
    return success(message='病历删除成功')
