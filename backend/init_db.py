"""数据库初始化脚本 - 创建表结构和默认数据"""
from app import create_app, db
from app.models.user import User
from app.models.patient import Patient, MedicalRecord
from app.models.knowledge import KnowledgeDocument
from app.models.plan import MedicalPlan
from datetime import datetime, date


def init_database():
    app = create_app()
    with app.app_context():
        db.create_all()
        print("数据表创建成功")

        # 创建默认管理员
        if not User.query.filter_by(username='admin').first():
            admin = User(
                username='admin',
                real_name='系统管理员',
                role='admin',
                department='信息科',
            )
            admin.set_password('admin123')
            db.session.add(admin)
            print("默认管理员创建成功 (admin / admin123)")

        # 创建默认医生账号
        if not User.query.filter_by(username='doctor').first():
            doctor = User(
                username='doctor',
                real_name='张医生',
                role='doctor',
                department='内科',
            )
            doctor.set_password('doctor123')
            db.session.add(doctor)
            print("默认医生账号创建成功 (doctor / doctor123)")

        db.session.commit()

        # 添加示例患者数据
        if Patient.query.count() == 0:
            sample_patients = [
                Patient(
                    patient_no='P20250001',
                    name='王建国',
                    gender='男',
                    age=58,
                    phone='138****5678',
                    blood_type='A型',
                    allergy_history='青霉素过敏',
                    medical_history='高血压病史10年，2型糖尿病病史5年',
                    family_history='父亲有冠心病史',
                    created_by=1,
                ),
                Patient(
                    patient_no='P20250002',
                    name='李秀芬',
                    gender='女',
                    age=45,
                    phone='139****1234',
                    blood_type='O型',
                    allergy_history='无',
                    medical_history='甲状腺结节术后2年',
                    family_history='母亲有糖尿病史',
                    created_by=1,
                ),
                Patient(
                    patient_no='P20250003',
                    name='陈志强',
                    gender='男',
                    age=67,
                    phone='137****9876',
                    blood_type='B型',
                    allergy_history='磺胺类药物过敏',
                    medical_history='冠心病、支架置入术后3年，慢性阻塞性肺疾病',
                    family_history='无特殊',
                    created_by=1,
                ),
            ]
            for p in sample_patients:
                db.session.add(p)
            db.session.commit()
            print(f"添加 {len(sample_patients)} 条示例患者数据")

            # 添加示例病历
            sample_records = [
                MedicalRecord(
                    patient_id=1,
                    record_no='R20250101001',
                    visit_date=date(2025, 1, 15),
                    department='心内科',
                    chief_complaint='反复胸闷、气短1月余，加重3天',
                    present_illness='患者1月前无明显诱因出现胸闷、气短，活动后加重，休息后可缓解。3天前症状加重，伴有夜间阵发性呼吸困难，端坐呼吸可缓解，无胸痛、咯血。',
                    past_history='高血压病史10年，血压最高180/110mmHg，长期服用氨氯地平5mg qd；2型糖尿病5年，服用二甲双胍500mg bid。',
                    physical_exam='T 36.5℃，P 88次/分，R 22次/分，BP 155/95mmHg。颈静脉怒张，双肺底可闻及湿啰音，心界向左下扩大，心率88次/分，律齐，各瓣膜区未闻及杂音。双下肢轻度凹陷性水肿。',
                    lab_results='BNP 850pg/mL↑，肌钙蛋白I 0.02ng/mL(正常)，血糖 8.5mmol/L↑，HbA1c 7.2%，肌酐 98μmol/L，电解质正常。血常规：WBC 7.8×10⁹/L，Hb 128g/L。',
                    imaging_results='心电图：窦性心律，左室肥厚伴劳损。胸片：心影增大，肺淤血。心脏超声：左室舒张末径58mm，LVEF 42%，室壁运动减弱。',
                    diagnosis='1. 慢性心力衰竭急性加重（NYHA III级）\n2. 高血压性心脏病\n3. 2型糖尿病',
                    diagnosis_type='确诊',
                    treatment='1. 利尿：呋塞米20mg iv bid\n2. 扩血管：硝酸甘油微泵\n3. 强心：地高辛0.125mg qd\n4. ACEI：依那普利5mg bid\n5. β受体阻滞剂：美托洛尔缓释片23.75mg qd\n6. 降糖：继续二甲双胍',
                    prescription='呋塞米注射液 20mg bid 静脉注射\n硝酸甘油注射液 微量泵入\n地高辛片 0.125mg qd 口服\n依那普利片 5mg bid 口服\n美托洛尔缓释片 23.75mg qd 口服\n二甲双胍片 500mg bid 口服',
                    doctor_id=2,
                ),
                MedicalRecord(
                    patient_id=2,
                    record_no='R20250102001',
                    visit_date=date(2025, 1, 20),
                    department='内分泌科',
                    chief_complaint='口干、多饮、多尿2月余',
                    present_illness='患者2月前出现口干、多饮，每日饮水量约3000mL，尿量增多，夜尿3-4次，伴乏力、体重下降约3kg，无视物模糊、手足麻木。',
                    past_history='甲状腺结节术后2年，术后口服优甲乐50μg qd。否认高血压、冠心病史。',
                    physical_exam='T 36.4℃，P 76次/分，R 18次/分，BP 125/80mmHg。BMI 26.5kg/m²。甲状腺术后瘢痕，无肿大。心肺检查无异常。双下肢无水肿，足背动脉搏动可。',
                    lab_results='空腹血糖 11.2mmol/L↑，餐后2h血糖 18.5mmol/L↑，HbA1c 9.8%↑，空腹C肽 1.8ng/mL，GAD抗体(-)，IA-2抗体(-)。血脂：TC 6.2mmol/L↑，TG 2.8mmol/L↑，LDL-C 4.1mmol/L↑。肝肾功能正常。TSH 3.2mIU/L(正常)。尿常规：尿糖(+++)，尿蛋白(-)。',
                    imaging_results='腹部超声：脂肪肝。颈部超声：甲状腺术后改变，未见明显复发。眼底检查：未见明显糖尿病视网膜病变。',
                    diagnosis='1. 2型糖尿病（新发）\n2. 高脂血症\n3. 脂肪肝\n4. 甲状腺术后',
                    diagnosis_type='初诊',
                    doctor_id=2,
                ),
            ]
            for r in sample_records:
                db.session.add(r)
            db.session.commit()
            print(f"添加 {len(sample_records)} 条示例病历数据")

        # 添加示例知识库文档
        if KnowledgeDocument.query.count() == 0:
            sample_docs = [
                KnowledgeDocument(
                    title='慢性心力衰竭诊断与治疗指南（2024版）',
                    doc_type='guideline',
                    category='心血管疾病',
                    content="""慢性心力衰竭诊断与治疗指南

一、定义与分类
心力衰竭是由于心脏结构或功能异常导致心室充盈或射血能力受损的一组复杂临床综合征。根据左室射血分数(LVEF)分为：
- HFrEF（射血分数降低型）：LVEF≤40%
- HFmrEF（射血分数中间型）：LVEF 41%-49%
- HFpEF（射血分数保留型）：LVEF≥50%

二、诊断标准
1. 心衰症状：呼吸困难、乏力、液体潴留（肺淤血、体循环淤血）
2. 心脏结构或功能异常的客观证据
3. BNP≥35pg/mL或NT-proBNP≥125pg/mL

三、NYHA心功能分级
- I级：体力活动不受限
- II级：体力活动轻度受限
- III级：体力活动明显受限
- IV级：休息时也有症状

四、药物治疗
1. ACEI/ARB/ARNI：所有HFrEF患者的基础用药
   - 依那普利：起始2.5mg bid，目标10-20mg bid
   - 沙库巴曲缬沙坦：起始50mg bid，目标200mg bid
2. β受体阻滞剂：稳定的HFrEF患者
   - 美托洛尔缓释片：起始23.75mg qd，目标190mg qd
   - 比索洛尔：起始1.25mg qd，目标10mg qd
3. 醛固酮受体拮抗剂
   - 螺内酯：20-40mg qd
4. 利尿剂：有液体潴留症状时使用
   - 呋塞米：20-80mg/d
   - 托拉塞米：10-20mg/d
5. 地高辛：LVEF≤45%且经规范治疗后仍有症状

五、非药物治疗
1. 生活方式管理：限盐(<6g/d)、限水(1.5-2L/d)、适度运动
2. CRT（心脏再同步化治疗）
3. ICD（植入型心律转复除颤器）

六、随访管理
- 出院后1-2周首次随访
- 稳定期每1-3月随访一次
- 监测指标：体重、血压、心率、BNP、电解质、肾功能""",
                    description='中华医学会心血管病学分会心力衰竭学组发布的最新临床指南',
                    uploaded_by=1,
                ),
                KnowledgeDocument(
                    title='2型糖尿病基层诊疗指南（2024版）',
                    doc_type='guideline',
                    category='内分泌疾病',
                    content="""2型糖尿病基层诊疗指南

一、诊断标准
1. 空腹血糖≥7.0mmol/L
2. OGTT 2h血糖≥11.1mmol/L
3. 随机血糖≥11.1mmol/L伴有典型糖尿病症状
4. HbA1c≥6.5%

二、血糖控制目标
- 一般成人：HbA1c<7.0%
- 老年患者或并发症多者：HbA1c<8.0%
- 新诊断、年轻患者：HbA1c<6.5%

三、治疗方案
（一）生活方式干预
1. 饮食：总热量控制，碳水化合物占45-60%
2. 运动：每周≥150分钟中等强度有氧运动
3. 控制体重：BMI目标<24kg/m²

（二）药物治疗
1. 一线用药：二甲双胍
   - 起始500mg bid，最大剂量2000mg/d
   - 禁忌：eGFR<30mL/min
2. 二线用药选择：
   - 磺脲类：格列美脲1-4mg qd
   - DPP-4抑制剂：西格列汀100mg qd
   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）
   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd
3. 胰岛素治疗：
   - 基础胰岛素：甘精胰岛素，起始0.2U/kg/d
   - 预混胰岛素：门冬胰岛素30

四、并发症筛查
1. 每年检查：眼底、尿微量白蛋白、足部检查
2. 每3-6月：HbA1c、血脂、肝肾功能
3. 心血管风险评估

五、合并症管理
1. 高血压：目标<130/80mmHg，首选ACEI/ARB
2. 高脂血症：LDL-C<2.6mmol/L（高危<1.8mmol/L）
3. 抗血小板：有心血管疾病者使用阿司匹林""",
                    description='国家卫健委基层医疗指导中心发布的糖尿病诊疗规范',
                    uploaded_by=1,
                ),
                KnowledgeDocument(
                    title='高血压诊断与治疗规范',
                    doc_type='guideline',
                    category='心血管疾病',
                    content="""高血压诊断与治疗规范

一、诊断标准
在未使用降压药的情况下，非同日3次测量血压，收缩压≥140mmHg和/或舒张压≥90mmHg。

血压分级：
- 正常：<120/80mmHg
- 正常高值：120-139/80-89mmHg
- 1级高血压：140-159/90-99mmHg
- 2级高血压：160-179/100-109mmHg
- 3级高血压：≥180/110mmHg

二、治疗原则
1. 降压目标：一般<140/90mmHg，能耐受者<130/80mmHg
2. 合并糖尿病/肾病：<130/80mmHg
3. 老年患者：<150/90mmHg

三、常用降压药物
1. ACEI类：依那普利、培哚普利（合并心衰、糖尿病优先）
2. ARB类：缬沙坦、氯沙坦（不能耐受ACEI时替代）
3. CCB类：氨氯地平、硝苯地平控释片（老年、单纯收缩期高血压优先）
4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）
5. 利尿剂：氢氯噻嗪、吲达帕胺

四、联合用药方案
- ACEI/ARB + CCB
- ACEI/ARB + 利尿剂
- CCB + 利尿剂
- 三联：ACEI/ARB + CCB + 利尿剂

五、生活方式干预
1. 限盐：<6g/d
2. 减重：BMI<24kg/m²
3. 戒烟限酒
4. 适度运动：每周≥150分钟
5. 心理平衡""",
                    description='高血压临床诊疗规范化指南',
                    uploaded_by=1,
                ),
            ]
            for doc in sample_docs:
                db.session.add(doc)
            db.session.commit()
            print(f"添加 {len(sample_docs)} 条示例知识库文档")

        print("\n数据库初始化完成！")


if __name__ == '__main__':
    init_database()
