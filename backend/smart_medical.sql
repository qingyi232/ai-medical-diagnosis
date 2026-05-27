-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: smart_medical
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `knowledge_chunks`
--

DROP TABLE IF EXISTS `knowledge_chunks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `knowledge_chunks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL COMMENT '文档ID',
  `chunk_index` int NOT NULL COMMENT '切片序号',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '切片内容',
  `token_count` int DEFAULT NULL COMMENT 'token数量',
  `embedding_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '向量ID',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  CONSTRAINT `knowledge_chunks_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `knowledge_documents` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_chunks`
--

LOCK TABLES `knowledge_chunks` WRITE;
/*!40000 ALTER TABLE `knowledge_chunks` DISABLE KEYS */;
INSERT INTO `knowledge_chunks` VALUES (7,1,0,'慢性心力衰竭诊断与治疗指南\n\n一、定义与分类\n心力衰竭是由于心脏结构或功能异常导致心室充盈或射血能力受损的一组复杂临床综合征。根据左室射血分数(LVEF)分为：\n- HFrEF（射血分数降低型）：LVEF≤40%\n- HFmrEF（射血分数中间型）：LVEF 41%-49%\n- HFpEF（射血分数保留型）：LVEF≥50%\n\n二、诊断标准\n1. 心衰症状：呼吸困难、乏力、液体潴留（肺淤血、体循环淤血）\n2. 心脏结构或功能异常的客观证据\n3. BNP≥35pg/mL或NT-proBNP≥125pg/mL\n\n三、NYHA心功能分级\n- I级：体力活动不受限\n- II级：体力活动轻度受限\n- III级：体力活动明显受限\n- IV级：休息时也有症状\n\n四、药物治疗\n1. ACEI/ARB/ARNI：所有HFrEF患者的基础用药\n   - 依那普利：起始2.5mg bid，目标10-20mg bid\n   - 沙库巴曲缬沙坦：起始50mg bid，目标200mg bid\n2. β受体阻滞剂：稳定的HFrEF患者\n   - 美托洛尔缓释片：起始23.75mg qd，目标190mg qd',496,NULL,'2026-02-27 17:23:35'),(8,1,1,'g bid\n   - 沙库巴曲缬沙坦：起始50mg bid，目标200mg bid\n2. β受体阻滞剂：稳定的HFrEF患者\n   - 美托洛尔缓释片：起始23.75mg qd，目标190mg qd\n   - 比索洛尔：起始1.25mg qd，目标10mg qd\n3. 醛固酮受体拮抗剂\n   - 螺内酯：20-40mg qd\n4. 利尿剂：有液体潴留症状时使用\n   - 呋塞米：20-80mg/d\n   - 托拉塞米：10-20mg/d\n5. 地高辛：LVEF≤45%且经规范治疗后仍有症状\n\n五、非药物治疗\n1. 生活方式管理：限盐(<6g/d)、限水(1.5-2L/d)、适度运动\n2. CRT（心脏再同步化治疗）\n3. ICD（植入型心律转复除颤器）\n\n六、随访管理\n- 出院后1-2周首次随访\n- 稳定期每1-3月随访一次\n- 监测指标：体重、血压、心率、BNP、电解质、肾功能',395,NULL,'2026-02-27 17:23:35'),(9,2,0,'2型糖尿病基层诊疗指南\n\n一、诊断标准\n1. 空腹血糖≥7.0mmol/L\n2. OGTT 2h血糖≥11.1mmol/L\n3. 随机血糖≥11.1mmol/L伴有典型糖尿病症状\n4. HbA1c≥6.5%\n\n二、血糖控制目标\n- 一般成人：HbA1c<7.0%\n- 老年患者或并发症多者：HbA1c<8.0%\n- 新诊断、年轻患者：HbA1c<6.5%\n\n三、治疗方案\n（一）生活方式干预\n1. 饮食：总热量控制，碳水化合物占45-60%\n2. 运动：每周≥150分钟中等强度有氧运动\n3. 控制体重：BMI目标<24kg/m²\n\n（二）药物治疗\n1. 一线用药：二甲双胍\n   - 起始500mg bid，最大剂量2000mg/d\n   - 禁忌：eGFR<30mL/min\n2. 二线用药选择：\n   - 磺脲类：格列美脲1-4mg qd\n   - DPP-4抑制剂：西格列汀100mg qd\n   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）\n   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd\n3. 胰岛素治疗：',479,NULL,'2026-02-27 17:23:37'),(10,2,1,'P-4抑制剂：西格列汀100mg qd\n   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）\n   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd\n3. 胰岛素治疗：\n   - 基础胰岛素：甘精胰岛素，起始0.2U/kg/d\n   - 预混胰岛素：门冬胰岛素30\n\n四、并发症筛查\n1. 每年检查：眼底、尿微量白蛋白、足部检查\n2. 每3-6月：HbA1c、血脂、肝肾功能\n3. 心血管风险评估\n\n五、合并症管理\n1. 高血压：目标<130/80mmHg，首选ACEI/ARB\n2. 高脂血症：LDL-C<2.6mmol/L（高危<1.8mmol/L）\n3. 抗血小板：有心血管疾病者使用阿司匹林',314,NULL,'2026-02-27 17:23:37'),(11,3,0,'高血压诊断与治疗规范\n\n一、诊断标准\n在未使用降压药的情况下，非同日3次测量血压，收缩压≥140mmHg和/或舒张压≥90mmHg。\n\n血压分级：\n- 正常：<120/80mmHg\n- 正常高值：120-139/80-89mmHg\n- 1级高血压：140-159/90-99mmHg\n- 2级高血压：160-179/100-109mmHg\n- 3级高血压：≥180/110mmHg\n\n二、治疗原则\n1. 降压目标：一般<140/90mmHg，能耐受者<130/80mmHg\n2. 合并糖尿病/肾病：<130/80mmHg\n3. 老年患者：<150/90mmHg\n\n三、常用降压药物\n1. ACEI类：依那普利、培哚普利（合并心衰、糖尿病优先）\n2. ARB类：缬沙坦、氯沙坦（不能耐受ACEI时替代）\n3. CCB类：氨氯地平、硝苯地平控释片（老年、单纯收缩期高血压优先）\n4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）\n5. 利尿剂：氢氯噻嗪、吲达帕胺\n\n四、联合用药方案\n- ACEI/ARB + CCB\n- ACEI/ARB + 利尿剂\n- CCB + 利尿剂',486,NULL,'2026-02-27 17:23:40'),(12,3,1,'4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）\n5. 利尿剂：氢氯噻嗪、吲达帕胺\n\n四、联合用药方案\n- ACEI/ARB + CCB\n- ACEI/ARB + 利尿剂\n- CCB + 利尿剂\n- 三联：ACEI/ARB + CCB + 利尿剂\n\n五、生活方式干预\n1. 限盐：<6g/d\n2. 减重：BMI<24kg/m²\n3. 戒烟限酒\n4. 适度运动：每周≥150分钟\n5. 心理平衡',198,NULL,'2026-02-27 17:23:40');
/*!40000 ALTER TABLE `knowledge_chunks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_documents`
--

DROP TABLE IF EXISTS `knowledge_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `knowledge_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文档标题',
  `doc_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文档类型: guideline/case/textbook/paper',
  `category` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疾病分类',
  `file_path` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '原始文件路径',
  `file_size` int DEFAULT NULL COMMENT '文件大小(字节)',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '文档全文内容',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '文档描述',
  `is_vectorized` tinyint(1) DEFAULT NULL COMMENT '是否已向量化',
  `chunk_count` int DEFAULT NULL COMMENT '切片数量',
  `uploaded_by` int DEFAULT NULL COMMENT '上传人',
  `status` int DEFAULT NULL COMMENT '状态: 0禁用 1启用',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `uploaded_by` (`uploaded_by`),
  CONSTRAINT `knowledge_documents_ibfk_1` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_documents`
--

LOCK TABLES `knowledge_documents` WRITE;
/*!40000 ALTER TABLE `knowledge_documents` DISABLE KEYS */;
INSERT INTO `knowledge_documents` VALUES (1,'慢性心力衰竭诊断与治疗指南（2024版）','guideline','心血管疾病',NULL,NULL,'慢性心力衰竭诊断与治疗指南\n\n一、定义与分类\n心力衰竭是由于心脏结构或功能异常导致心室充盈或射血能力受损的一组复杂临床综合征。根据左室射血分数(LVEF)分为：\n- HFrEF（射血分数降低型）：LVEF≤40%\n- HFmrEF（射血分数中间型）：LVEF 41%-49%\n- HFpEF（射血分数保留型）：LVEF≥50%\n\n二、诊断标准\n1. 心衰症状：呼吸困难、乏力、液体潴留（肺淤血、体循环淤血）\n2. 心脏结构或功能异常的客观证据\n3. BNP≥35pg/mL或NT-proBNP≥125pg/mL\n\n三、NYHA心功能分级\n- I级：体力活动不受限\n- II级：体力活动轻度受限\n- III级：体力活动明显受限\n- IV级：休息时也有症状\n\n四、药物治疗\n1. ACEI/ARB/ARNI：所有HFrEF患者的基础用药\n   - 依那普利：起始2.5mg bid，目标10-20mg bid\n   - 沙库巴曲缬沙坦：起始50mg bid，目标200mg bid\n2. β受体阻滞剂：稳定的HFrEF患者\n   - 美托洛尔缓释片：起始23.75mg qd，目标190mg qd\n   - 比索洛尔：起始1.25mg qd，目标10mg qd\n3. 醛固酮受体拮抗剂\n   - 螺内酯：20-40mg qd\n4. 利尿剂：有液体潴留症状时使用\n   - 呋塞米：20-80mg/d\n   - 托拉塞米：10-20mg/d\n5. 地高辛：LVEF≤45%且经规范治疗后仍有症状\n\n五、非药物治疗\n1. 生活方式管理：限盐(<6g/d)、限水(1.5-2L/d)、适度运动\n2. CRT（心脏再同步化治疗）\n3. ICD（植入型心律转复除颤器）\n\n六、随访管理\n- 出院后1-2周首次随访\n- 稳定期每1-3月随访一次\n- 监测指标：体重、血压、心率、BNP、电解质、肾功能','中华医学会心血管病学分会心力衰竭学组发布的最新临床指南',1,2,1,1,'2026-02-27 16:47:30','2026-02-27 17:17:08'),(2,'2型糖尿病基层诊疗指南（2024版）','guideline','内分泌疾病',NULL,NULL,'2型糖尿病基层诊疗指南\n\n一、诊断标准\n1. 空腹血糖≥7.0mmol/L\n2. OGTT 2h血糖≥11.1mmol/L\n3. 随机血糖≥11.1mmol/L伴有典型糖尿病症状\n4. HbA1c≥6.5%\n\n二、血糖控制目标\n- 一般成人：HbA1c<7.0%\n- 老年患者或并发症多者：HbA1c<8.0%\n- 新诊断、年轻患者：HbA1c<6.5%\n\n三、治疗方案\n（一）生活方式干预\n1. 饮食：总热量控制，碳水化合物占45-60%\n2. 运动：每周≥150分钟中等强度有氧运动\n3. 控制体重：BMI目标<24kg/m²\n\n（二）药物治疗\n1. 一线用药：二甲双胍\n   - 起始500mg bid，最大剂量2000mg/d\n   - 禁忌：eGFR<30mL/min\n2. 二线用药选择：\n   - 磺脲类：格列美脲1-4mg qd\n   - DPP-4抑制剂：西格列汀100mg qd\n   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）\n   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd\n3. 胰岛素治疗：\n   - 基础胰岛素：甘精胰岛素，起始0.2U/kg/d\n   - 预混胰岛素：门冬胰岛素30\n\n四、并发症筛查\n1. 每年检查：眼底、尿微量白蛋白、足部检查\n2. 每3-6月：HbA1c、血脂、肝肾功能\n3. 心血管风险评估\n\n五、合并症管理\n1. 高血压：目标<130/80mmHg，首选ACEI/ARB\n2. 高脂血症：LDL-C<2.6mmol/L（高危<1.8mmol/L）\n3. 抗血小板：有心血管疾病者使用阿司匹林','国家卫健委基层医疗指导中心发布的糖尿病诊疗规范',1,2,1,1,'2026-02-27 16:47:30','2026-02-27 17:17:10'),(3,'高血压诊断与治疗规范','guideline','心血管疾病',NULL,NULL,'高血压诊断与治疗规范\n\n一、诊断标准\n在未使用降压药的情况下，非同日3次测量血压，收缩压≥140mmHg和/或舒张压≥90mmHg。\n\n血压分级：\n- 正常：<120/80mmHg\n- 正常高值：120-139/80-89mmHg\n- 1级高血压：140-159/90-99mmHg\n- 2级高血压：160-179/100-109mmHg\n- 3级高血压：≥180/110mmHg\n\n二、治疗原则\n1. 降压目标：一般<140/90mmHg，能耐受者<130/80mmHg\n2. 合并糖尿病/肾病：<130/80mmHg\n3. 老年患者：<150/90mmHg\n\n三、常用降压药物\n1. ACEI类：依那普利、培哚普利（合并心衰、糖尿病优先）\n2. ARB类：缬沙坦、氯沙坦（不能耐受ACEI时替代）\n3. CCB类：氨氯地平、硝苯地平控释片（老年、单纯收缩期高血压优先）\n4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）\n5. 利尿剂：氢氯噻嗪、吲达帕胺\n\n四、联合用药方案\n- ACEI/ARB + CCB\n- ACEI/ARB + 利尿剂\n- CCB + 利尿剂\n- 三联：ACEI/ARB + CCB + 利尿剂\n\n五、生活方式干预\n1. 限盐：<6g/d\n2. 减重：BMI<24kg/m²\n3. 戒烟限酒\n4. 适度运动：每周≥150分钟\n5. 心理平衡','高血压临床诊疗规范化指南',1,2,1,1,'2026-02-27 16:47:30','2026-02-27 17:17:13');
/*!40000 ALTER TABLE `knowledge_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_plans`
--

DROP TABLE IF EXISTS `medical_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `record_id` int DEFAULT NULL COMMENT '关联病历ID',
  `patient_id` int DEFAULT NULL COMMENT '患者ID',
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '方案标题',
  `input_text` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '输入的病例信息',
  `retrieved_context` text COLLATE utf8mb4_unicode_ci COMMENT 'RAG检索到的上下文',
  `generated_plan` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '生成的医疗方案',
  `diagnosis_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '诊断建议',
  `treatment_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '治疗建议',
  `medication_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '用药建议',
  `examination_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '检查建议',
  `lifestyle_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '生活方式建议',
  `follow_up_suggestion` text COLLATE utf8mb4_unicode_ci COMMENT '随访建议',
  `confidence_score` float DEFAULT NULL COMMENT '置信度评分',
  `reference_sources` text COLLATE utf8mb4_unicode_ci COMMENT '参考来源',
  `doctor_feedback` text COLLATE utf8mb4_unicode_ci COMMENT '医生反馈',
  `rating` int DEFAULT NULL COMMENT '评分 1-5',
  `generated_by` int DEFAULT NULL COMMENT '生成人',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态: generated/reviewed/approved/rejected',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`),
  KEY `patient_id` (`patient_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `medical_plans_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `medical_records` (`id`),
  CONSTRAINT `medical_plans_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `medical_plans_ibfk_3` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_plans`
--

LOCK TABLES `medical_plans` WRITE;
/*!40000 ALTER TABLE `medical_plans` DISABLE KEYS */;
INSERT INTO `medical_plans` VALUES (1,2,2,'李秀芬医疗方案','主诉：口干、多饮、多尿2月余\n现病史：患者2月前出现口干、多饮，每日饮水量约3000mL，尿量增多，夜尿3-4次，伴乏力、体重下降约3kg，无视物模糊、手足麻木。\n既往史：甲状腺结节术后2年，术后口服优甲乐50μg qd。否认高血压、冠心病史。\n体格检查：T 36.4℃，P 76次/分，R 18次/分，BP 125/80mmHg。BMI 26.5kg/m²。甲状腺术后瘢痕，无肿大。心肺检查无异常。双下肢无水肿，足背动脉搏动可。\n实验室检查：空腹血糖 11.2mmol/L↑，餐后2h血糖 18.5mmol/L↑，HbA1c 9.8%↑，空腹C肽 1.8ng/mL，GAD抗体(-)，IA-2抗体(-)。血脂：TC 6.2mmol/L↑，TG 2.8mmol/L↑，LDL-C 4.1mmol/L↑。肝肾功能正常。TSH 3.2mIU/L(正常)。尿常规：尿糖(+++)，尿蛋白(-)。\n影像学检查：腹部超声：脂肪肝。颈部超声：甲状腺术后改变，未见明显复发。眼底检查：未见明显糖尿病视网膜病变。\n诊断：1. 2型糖尿病（新发）\n2. 高脂血症\n3. 脂肪肝\n4. 甲状腺术后','【参考1】(来源: 2型糖尿病基层诊疗指南（2024版）, 相关度: 0.60)\n2型糖尿病基层诊疗指南\n\n一、诊断标准\n1. 空腹血糖≥7.0mmol/L\n2. OGTT 2h血糖≥11.1mmol/L\n3. 随机血糖≥11.1mmol/L伴有典型糖尿病症状\n4. HbA1c≥6.5%\n\n二、血糖控制目标\n- 一般成人：HbA1c<7.0%\n- 老年患者或并发症多者：HbA1c<8.0%\n- 新诊断、年轻患者：HbA1c<6.5%\n\n三、治疗方案\n（一）生活方式干预\n1. 饮食：总热量控制，碳水化合物占45-60%\n2. 运动：每周≥150分钟中等强度有氧运动\n3. 控制体重：BMI目标<24kg/m²\n\n（二）药物治疗\n1. 一线用药：二甲双胍\n   - 起始500mg bid，最大剂量2000mg/d\n   - 禁忌：eGFR<30mL/min\n2. 二线用药选择：\n   - 磺脲类：格列美脲1-4mg qd\n   - DPP-4抑制剂：西格列汀100mg qd\n   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）\n   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd\n3. 胰岛素治疗：\n\n【参考2】(来源: 高血压诊断与治疗规范, 相关度: 0.54)\n4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）\n5. 利尿剂：氢氯噻嗪、吲达帕胺\n\n四、联合用药方案\n- ACEI/ARB + CCB\n- ACEI/ARB + 利尿剂\n- CCB + 利尿剂\n- 三联：ACEI/ARB + CCB + 利尿剂\n\n五、生活方式干预\n1. 限盐：<6g/d\n2. 减重：BMI<24kg/m²\n3. 戒烟限酒\n4. 适度运动：每周≥150分钟\n5. 心理平衡\n\n【参考3】(来源: 2型糖尿病基层诊疗指南（2024版）, 相关度: 0.54)\nP-4抑制剂：西格列汀100mg qd\n   - SGLT2抑制剂：达格列净10mg qd（合并心血管疾病优先）\n   - GLP-1受体激动剂：利拉鲁肽0.6-1.8mg qd\n3. 胰岛素治疗：\n   - 基础胰岛素：甘精胰岛素，起始0.2U/kg/d\n   - 预混胰岛素：门冬胰岛素30\n\n四、并发症筛查\n1. 每年检查：眼底、尿微量白蛋白、足部检查\n2. 每3-6月：HbA1c、血脂、肝肾功能\n3. 心血管风险评估\n\n五、合并症管理\n1. 高血压：目标<130/80mmHg，首选ACEI/ARB\n2. 高脂血症：LDL-C<2.6mmol/L（高危<1.8mmol/L）\n3. 抗血小板：有心血管疾病者使用阿司匹林\n\n【参考4】(来源: 高血压诊断与治疗规范, 相关度: 0.51)\n高血压诊断与治疗规范\n\n一、诊断标准\n在未使用降压药的情况下，非同日3次测量血压，收缩压≥140mmHg和/或舒张压≥90mmHg。\n\n血压分级：\n- 正常：<120/80mmHg\n- 正常高值：120-139/80-89mmHg\n- 1级高血压：140-159/90-99mmHg\n- 2级高血压：160-179/100-109mmHg\n- 3级高血压：≥180/110mmHg\n\n二、治疗原则\n1. 降压目标：一般<140/90mmHg，能耐受者<130/80mmHg\n2. 合并糖尿病/肾病：<130/80mmHg\n3. 老年患者：<150/90mmHg\n\n三、常用降压药物\n1. ACEI类：依那普利、培哚普利（合并心衰、糖尿病优先）\n2. ARB类：缬沙坦、氯沙坦（不能耐受ACEI时替代）\n3. CCB类：氨氯地平、硝苯地平控释片（老年、单纯收缩期高血压优先）\n4. β受体阻滞剂：美托洛尔（合并冠心病、心衰优先）\n5. 利尿剂：氢氯噻嗪、吲达帕胺\n\n四、联合用药方案\n- ACEI/ARB + CCB\n- ACEI/ARB + 利尿剂\n- CCB + 利尿剂\n\n【参考5】(来源: 慢性心力衰竭诊断与治疗指南（2024版）, 相关度: 0.51)\ng bid\n   - 沙库巴曲缬沙坦：起始50mg bid，目标200mg bid\n2. β受体阻滞剂：稳定的HFrEF患者\n   - 美托洛尔缓释片：起始23.75mg qd，目标190mg qd\n   - 比索洛尔：起始1.25mg qd，目标10mg qd\n3. 醛固酮受体拮抗剂\n   - 螺内酯：20-40mg qd\n4. 利尿剂：有液体潴留症状时使用\n   - 呋塞米：20-80mg/d\n   - 托拉塞米：10-20mg/d\n5. 地高辛：LVEF≤45%且经规范治疗后仍有症状\n\n五、非药物治疗\n1. 生活方式管理：限盐(<6g/d)、限水(1.5-2L/d)、适度运动\n2. CRT（心脏再同步化治疗）\n3. ICD（植入型心律转复除颤器）\n\n六、随访管理\n- 出院后1-2周首次随访\n- 稳定期每1-3月随访一次\n- 监测指标：体重、血压、心率、BNP、电解质、肾功能','### 一、病情分析  \n患者为中青年（结合BMI及病史推断，未提供年龄但符合典型2型糖尿病发病特征），以典型“三多一少”（多饮、多尿、口干、体重下降）起病，病程短（2月余），无急性并发症表现（如酮症、意识障碍）。实验室检查显示：  \n- **显著高血糖**：空腹血糖11.2 mmol/L、餐后2h血糖18.5 mmol/L、HbA1c 9.8%，远超诊断阈值（HbA1c ≥6.5%或空腹≥7.0 mmol/L），且提示近3个月平均血糖水平约13.5 mmol/L（HbA1c每升高1%，估算平均血糖升高约1.6 mmol/L），存在明显糖代谢紊乱；  \n- **胰岛功能保留**：空腹C肽1.8 ng/mL（正常参考值约0.7–4.0 ng/mL），提示β细胞尚有较好分泌能力，支持2型糖尿病而非1型（GAD/IA-2抗体阴性进一步排除自身免疫性糖尿病）；  \n- **多重代谢异常共存**：高脂血症（TC、TG、LDL-C均升高）、脂肪肝（超声证实）、超重（BMI 26.5 kg/m²，接近超重上限），构成典型的“代谢综合征”表型；  \n- **血压正常高值下限（125/80 mmHg）**，虽未达高血压诊断标准（≥140/90 mmHg），但作为糖尿病患者，已属心血管高危人群，需按强化目标（<130/80 mmHg）管理；  \n- 甲状腺功能稳定（TSH正常，优甲乐替代充分），甲状腺术后状态不影响当前代谢管理主线。  \n\n综上，该患者为**新诊断、中度高血糖、胰岛功能尚存、合并多重代谢异常的2型糖尿病患者**，处于疾病早期干预黄金窗口期，具备通过强化生活方式联合一线药物快速改善血糖、逆转脂肪肝、降低远期心肾风险的潜力。\n\n---\n\n### 二、诊断建议  \n✅ 明确诊断：  \n1. **2型糖尿病（新发，高血糖症，HbA1c 9.8%）** —— 符合指南诊断标准（空腹≥7.0 mmol/L + HbA1c≥6.5%）；  \n2. **混合型高脂血症（高胆固醇血症+高甘油三酯血症）** —— TC↑、TG↑、LDL-C↑，符合《中国成人血脂异常防治指南》诊断；  \n3. **非酒精性脂肪性肝病（NAFLD，超声诊断）** —— 与肥胖、胰岛素抵抗密切相关；  \n4. **甲状腺切除术后状态，甲状腺功能正常（接受优甲乐替代治疗）**。  \n\n⚠️ 排除诊断：  \n- 1型糖尿病（GAD/IA-2抗体阴性、C肽不低、无青少年起病、无酮症倾向）；  \n- 继发性糖尿病（无库欣、肢端肥大、长期激素使用史）；  \n- 高血压（当前BP 125/80 mmHg，属“正常高值”，需动态监测，暂不诊断）。  \n\n---\n\n### 三、治疗方案  \n采用**“阶梯式强化干预”策略**，分三期推进：  \n\n| 阶段 | 目标 | 核心措施 |\n|------|------|-----------|\n| **第1阶段（0–4周）：快速血糖达标 + 代谢启动** | HbA1c ↓至<8.0%，空腹血糖≤7.5 mmol/L，消除高糖毒性 | • 二甲双胍起始+生活方式处方（结构化教育）<br>• 启动他汀调脂（LDL-C目标<2.6 mmol/L）<br>• 每日家庭血糖监测（空腹+晚餐后） |\n| **第2阶段（4–12周）：深度代谢改善** | HbA1c ≤7.0%，空腹≤6.5 mmol/L，TG↓<2.3 mmol/L，体重↓3–5% | • 二甲双胍加量至最大耐受剂量<br>• 若4周后HbA1c >7.5%，加用SGLT2抑制剂（达格列净）——兼顾降糖、减重、护肾、改善脂肪肝<br>• 强化饮食运动执行监督 |\n| **第3阶段（12周后）：长期稳态维持与并发症预防** | HbA1c持续<7.0%，LDL-C<2.6 mmol/L，ALT/AST改善，无微血管进展 | • 固化用药方案<br>• 启动年度并发症筛查（眼底、UACR、足部神经）<br>• 心血管风险再评估（10年ASCVD风险计算） |\n\n> 注：暂不启用胰岛素（C肽充足、无DKA/严重症状、无禁忌），避免低血糖及体重增加风险。\n\n---\n\n### 四、用药建议  \n\n| 药物类别 | 具体药物 | 剂量与用法 | 疗程 | 注意事项 |\n|----------|-----------|-------------|--------|------------|\n| **一线降糖药** | 二甲双胍缓释片 | **起始：500 mg qd（晚餐时）→ 1周后加至500 mg bid（早+晚）→ 2周后加至1000 mg bid（最大耐受）** | 长期维持 | • 餐中/餐后服，减少胃肠道反应<br>• 监测eGFR（当前正常，无需调整）<br>• 禁用于eGFR<30；慎用于eGFR 30–45<br>• 告知维生素B12缺乏风险（长期使用者建议每年检测） |\n| **调脂药** | 阿托伐他汀钙片 | **20 mg qd（睡前）** | 长期 | • LDL-C目标<2.6 mmol/L（高危人群）<br>• 首次用药4–6周复查肝酶（ALT/AST）、CK<br>• 避免与红霉素、环孢素联用 |\n| **二线增效（如需）** | 达格列净片 | **10 mg qd（晨服）** | 长期（若12周HbA1c未达标或存在脂肪肝/超重） | • 优先选择依据：合并肥胖、脂肪肝、心血管风险↑<br>• 注意：多尿可能加重，嘱每日饮水1500–1700 mL，防泌尿生殖道感染<br>• 禁用于eGFR<45；用药前查eGFR、尿常规（排除活动性尿路感染） |\n| **甲状腺替代** | 优甲乐 | **50 μg qd（晨空腹）** | 维持 | • 保持服药时间固定，与二甲双胍间隔≥4小时（减少吸收干扰）<br>• 每6–12个月复查TSH |\n\n> ✅ **暂不推荐**：磺脲类（低血糖风险高）、DPP-4抑制剂（降糖效力弱于SGLT2i/GLP-1RA，性价比低）、胰岛素（过度治疗）。\n\n---\n\n### 五、进一步检查建议  \n\n| 检查项目 | 推荐时间 | 目的 |\n|----------|-----------|------|\n| **尿微量白蛋白/肌酐比值（UACR）** | 首诊即查 | 筛查早期糖尿病肾病（当前尿常规阴性≠无微量白蛋白尿） |\n| **肝功能（ALT/AST/GGT）、FIB-4指数（含PLT、AST、ALT、年龄）** | 0周、12周 | 评估脂肪肝炎症/纤维化程度；监测他汀安全性 |\n| **颈动脉超声 + 10年ASCVD风险评估（ACC/AHA计算器）** | 4周内 | 明确亚临床动脉粥样硬化负荷，指导强化降脂/抗血小板决策（当前无CVD，暂不启动阿司匹林） |\n| **睡眠呼吸监测（如打鼾/日间嗜睡）** | 如有相关症状 | 脂肪肝+肥胖者OSAHS高发，可加重胰岛素抵抗 |\n| **骨密度（如女性>65岁或男性>70岁）** | 暂不必要（年轻患者） | 达格列净长期使用需关注骨折风险，但本例无指征 |\n\n---\n\n### 六、生活方式指导  \n\n#### ✅ 饮食干预（个体化医学营养治疗）  \n- **总热量控制**：按25–30 kcal/kg理想体重计算 → 约1500–1600 kcal/d（BMI 26.5，目标减重5%，理想体重≈58–60 kg）；  \n- **碳水化合物**：占总热量45–50%，优选低GI食物（燕麦、糙米、荞麦、豆类、非淀粉类蔬菜），严格限制精制糖、含糖饮料、果汁；  \n- **优质蛋白**：15–20%，优选鱼、蛋、豆制品、去皮禽肉，限制红肉及加工肉；  \n- **脂肪**：25–30%，以单不饱和脂肪（橄榄油、牛油果、坚果）为主，严格限制反式脂肪及饱和脂肪（动物油、棕榈油、糕点）；  \n- **限盐**：<5 g/d（合并脂肪肝及未来高血压风险，较指南更严格）；  \n- **膳食纤维**：≥25 g/d（蔬菜500 g/d + 全谷物+菌菇）；  \n- **戒酒**：酒精加重脂肪肝及TG升高，必须戒断。  \n\n#### ✅ 运动处方（运动即良药）  \n- **频率**：每周≥5天；  \n- **类型**：中等强度有氧（快走、慢跑、骑行、游泳）+ 抗阻训练（弹力带、自重深蹲/俯卧撑）；  \n- **时长**：有氧≥30 min/次（累计≥150 min/周），抗阻2次/周（每次8–10个动作，2组×12–15次）；  \n- **关键提醒**：运动前后监测血糖（尤其启用二甲双胍初期），避免空腹晨练（防低血糖）；餐后1小时开始运动降糖效果最佳。  \n\n#### ✅ 行为与心理支持  \n- 戒烟（如有）；  \n- 睡眠保障：7–8小时/天，睡眠不足加剧胰岛素抵抗；  \n- 压力管理：正念呼吸、规律作息，避免应激性高血糖；  \n- 推荐使用“糖尿病自我管理教育与支持（DSMES）”课程（线上/社区），提升疾病认知与行为依从性。\n\n---\n\n### 七、随访计划  \n\n| 时间节点 | 复诊内容 | 监测指标 |\n|----------|-----------|------------|\n| **2周后（电话随访）** | 用药耐受性、低血糖/胃肠道反应、饮食运动执行困难点 | 血糖日记（空腹+餐后2h×3天） |\n| **4周后（门诊）** | 全面评估、调药（如需）、启动教育 | • HbA1c、FPG、PBG<br>• ALT/AST、TC/TG/LDL-C<br>• UACR、eGFR<br>• 体重、腰围、血压 |\n| **12周后（门诊）** | 疗效评估、并发症初筛、长期方案固化 | • HbA1c（目标≤7.0%）<br>• 肝功能、血脂、UACR<br>• 眼底照相（首次）<br>• 足部感觉检查（128 Hz音叉+10 g尼龙丝） |\n| **此后** | 每3个月1次门诊随访，每年1次全面并发症筛查 | 同上 + ECG、BNP（如出现气促）、颈动脉超声（每2年） |\n\n> 📌 提示：若出现以下任一情况，立即就诊：  \n> - 血糖持续>16.7 mmol/L伴恶心/呕吐/腹痛（警惕DKA）；  \n> - 尿频尿急尿痛/外阴瘙痒（警惕SGLT2i相关生殖道感染）；  \n> - 下肢水肿、夜间阵发性呼吸困难（心衰预警）；  \n> - 视物模糊进行性加重。\n\n---\n\n### 八、决策依据说明  \n\n本方案严格遵循最新循证指南：  \n- **糖尿病诊断与分型**：依据《2型糖尿病基层诊疗指南（2024版）》【参考1,3】，结合HbA1c≥6.5% + 空腹血糖≥7.0 mmol/L + 自',NULL,NULL,NULL,NULL,NULL,NULL,0.599811,'2型糖尿病基层诊疗指南（2024版）(相关度: 0.60)\n高血压诊断与治疗规范(相关度: 0.54)\n2型糖尿病基层诊疗指南（2024版）(相关度: 0.54)\n高血压诊断与治疗规范(相关度: 0.51)\n慢性心力衰竭诊断与治疗指南（2024版）(相关度: 0.51)',NULL,NULL,1,'generated','2026-02-27 17:28:32','2026-02-27 17:28:32');
/*!40000 ALTER TABLE `medical_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_records`
--

DROP TABLE IF EXISTS `medical_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL COMMENT '患者ID',
  `record_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '病历编号',
  `visit_date` date DEFAULT NULL COMMENT '就诊日期',
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '就诊科室',
  `chief_complaint` text COLLATE utf8mb4_unicode_ci COMMENT '主诉',
  `present_illness` text COLLATE utf8mb4_unicode_ci COMMENT '现病史',
  `past_history` text COLLATE utf8mb4_unicode_ci COMMENT '既往史',
  `physical_exam` text COLLATE utf8mb4_unicode_ci COMMENT '体格检查',
  `lab_results` text COLLATE utf8mb4_unicode_ci COMMENT '实验室检查结果',
  `imaging_results` text COLLATE utf8mb4_unicode_ci COMMENT '影像学检查结果',
  `diagnosis` text COLLATE utf8mb4_unicode_ci COMMENT '诊断',
  `diagnosis_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '诊断类型: 初诊/复诊/确诊',
  `treatment` text COLLATE utf8mb4_unicode_ci COMMENT '治疗方案',
  `prescription` text COLLATE utf8mb4_unicode_ci COMMENT '处方用药',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `doctor_id` int DEFAULT NULL COMMENT '主治医生',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态: active/archived',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `record_no` (`record_no`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `medical_records_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_records`
--

LOCK TABLES `medical_records` WRITE;
/*!40000 ALTER TABLE `medical_records` DISABLE KEYS */;
INSERT INTO `medical_records` VALUES (1,1,'R20250101001','2025-01-15','心内科','反复胸闷、气短1月余，加重3天','患者1月前无明显诱因出现胸闷、气短，活动后加重，休息后可缓解。3天前症状加重，伴有夜间阵发性呼吸困难，端坐呼吸可缓解，无胸痛、咯血。','高血压病史10年，血压最高180/110mmHg，长期服用氨氯地平5mg qd；2型糖尿病5年，服用二甲双胍500mg bid。','T 36.5℃，P 88次/分，R 22次/分，BP 155/95mmHg。颈静脉怒张，双肺底可闻及湿啰音，心界向左下扩大，心率88次/分，律齐，各瓣膜区未闻及杂音。双下肢轻度凹陷性水肿。','BNP 850pg/mL↑，肌钙蛋白I 0.02ng/mL(正常)，血糖 8.5mmol/L↑，HbA1c 7.2%，肌酐 98μmol/L，电解质正常。血常规：WBC 7.8×10⁹/L，Hb 128g/L。','心电图：窦性心律，左室肥厚伴劳损。胸片：心影增大，肺淤血。心脏超声：左室舒张末径58mm，LVEF 42%，室壁运动减弱。','1. 慢性心力衰竭急性加重（NYHA III级）\n2. 高血压性心脏病\n3. 2型糖尿病','确诊','1. 利尿：呋塞米20mg iv bid\n2. 扩血管：硝酸甘油微泵\n3. 强心：地高辛0.125mg qd\n4. ACEI：依那普利5mg bid\n5. β受体阻滞剂：美托洛尔缓释片23.75mg qd\n6. 降糖：继续二甲双胍','呋塞米注射液 20mg bid 静脉注射\n硝酸甘油注射液 微量泵入\n地高辛片 0.125mg qd 口服\n依那普利片 5mg bid 口服\n美托洛尔缓释片 23.75mg qd 口服\n二甲双胍片 500mg bid 口服',NULL,2,'active','2026-02-27 16:47:30','2026-02-27 16:47:30'),(2,2,'R20250102001','2025-01-20','内分泌科','口干、多饮、多尿2月余','患者2月前出现口干、多饮，每日饮水量约3000mL，尿量增多，夜尿3-4次，伴乏力、体重下降约3kg，无视物模糊、手足麻木。','甲状腺结节术后2年，术后口服优甲乐50μg qd。否认高血压、冠心病史。','T 36.4℃，P 76次/分，R 18次/分，BP 125/80mmHg。BMI 26.5kg/m²。甲状腺术后瘢痕，无肿大。心肺检查无异常。双下肢无水肿，足背动脉搏动可。','空腹血糖 11.2mmol/L↑，餐后2h血糖 18.5mmol/L↑，HbA1c 9.8%↑，空腹C肽 1.8ng/mL，GAD抗体(-)，IA-2抗体(-)。血脂：TC 6.2mmol/L↑，TG 2.8mmol/L↑，LDL-C 4.1mmol/L↑。肝肾功能正常。TSH 3.2mIU/L(正常)。尿常规：尿糖(+++)，尿蛋白(-)。','腹部超声：脂肪肝。颈部超声：甲状腺术后改变，未见明显复发。眼底检查：未见明显糖尿病视网膜病变。','1. 2型糖尿病（新发）\n2. 高脂血症\n3. 脂肪肝\n4. 甲状腺术后','初诊',NULL,NULL,NULL,2,'active','2026-02-27 16:47:30','2026-02-27 16:47:30');
/*!40000 ALTER TABLE `medical_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者编号',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者姓名',
  `gender` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '性别',
  `age` int DEFAULT NULL COMMENT '年龄',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `id_card` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号(脱敏)',
  `blood_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '血型',
  `allergy_history` text COLLATE utf8mb4_unicode_ci COMMENT '过敏史',
  `medical_history` text COLLATE utf8mb4_unicode_ci COMMENT '既往病史',
  `family_history` text COLLATE utf8mb4_unicode_ci COMMENT '家族病史',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `patient_no` (`patient_no`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'P20250001','王建国','男',58,'138****5678',NULL,'A型','青霉素过敏','高血压病史10年，2型糖尿病病史5年','父亲有冠心病史',1,'2026-02-27 16:47:30','2026-02-27 16:47:30'),(2,'P20250002','李秀芬','女',45,'139****1234',NULL,'O型','无','甲状腺结节术后2年','母亲有糖尿病史',1,'2026-02-27 16:47:30','2026-02-27 16:47:30'),(3,'P20250003','陈志强','男',67,'137****9876',NULL,'B型','磺胺类药物过敏','冠心病、支架置入术后3年，慢性阻塞性肺疾病','无特殊',1,'2026-02-27 16:47:30','2026-02-27 16:47:30');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password_hash` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码哈希',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '真实姓名',
  `role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色: admin/doctor',
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '科室',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `status` int DEFAULT NULL COMMENT '状态: 0禁用 1启用',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','scrypt:32768:8:1$vpu9dRFSb6cXTFeK$98e4395cd9bda5ab19117b08446e1409a162371d95f030f91c0cc8252a15d705185857bbc49946f8536c116362b644c5096563b2351269ba00e6d0b8d2a2e5a3','系统管理员','admin','信息科',NULL,NULL,NULL,1,'2026-02-27 16:47:29','2026-02-27 16:47:29'),(2,'doctor','scrypt:32768:8:1$NcosXJqJxkRbKMNv$963f341584091adf061d8518f6859ebe973c8ddfa2cebba68519568354e7289f839ae5bceee2e0acdfe8bfb023879cc766ab32723ffa21b7888d672d352c788d','张医生','doctor','内科',NULL,NULL,NULL,1,'2026-02-27 16:47:30','2026-02-27 16:47:30');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'smart_medical'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-27 17:37:16
