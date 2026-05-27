import dashscope
from dashscope import Generation
from flask import current_app


MEDICAL_SYSTEM_PROMPT = """你是一位资深的医疗AI助手，拥有丰富的临床医学知识。你的职责是基于患者病例信息和参考资料，生成专业、严谨的智慧医疗方案。

请遵循以下原则：
1. 所有建议必须基于循证医学证据
2. 方案需包含：诊断分析、治疗建议、用药方案、检查建议、生活方式指导、随访计划
3. 对不确定的情况需明确标注，建议进一步检查
4. 用药建议需注明剂量、频次、疗程及注意事项
5. 需考虑患者个体差异（年龄、性别、过敏史、既往病史等）
6. 方案应具有可解释性，说明决策依据

重要提示：本系统生成的方案仅供医生参考，最终诊疗决策须由执业医师做出。"""


def call_qwen(prompt, context="", temperature=0.3, max_tokens=3000):
    """调用通义千问API生成医疗方案"""
    dashscope.api_key = current_app.config.get('DASHSCOPE_API_KEY')

    messages = [
        {'role': 'system', 'content': MEDICAL_SYSTEM_PROMPT},
    ]

    if context:
        messages.append({
            'role': 'user',
            'content': f"以下是相关的医学参考资料：\n\n{context}"
        })
        messages.append({
            'role': 'assistant',
            'content': '我已了解这些参考资料，请提供需要分析的患者病例信息。'
        })

    messages.append({
        'role': 'user',
        'content': prompt
    })

    try:
        response = Generation.call(
            model='qwen-plus',
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
            result_format='message',
        )

        if response.status_code == 200:
            return {
                'success': True,
                'content': response.output.choices[0].message.content,
                'usage': {
                    'input_tokens': response.usage.input_tokens,
                    'output_tokens': response.usage.output_tokens,
                }
            }
        else:
            return {
                'success': False,
                'error': f"API调用失败: {response.code} - {response.message}"
            }
    except Exception as e:
        return {
            'success': False,
            'error': f"调用千问API异常: {str(e)}"
        }


def generate_medical_plan(case_info, retrieved_docs=""):
    """基于病例信息和RAG检索结果生成医疗方案"""
    prompt = f"""请基于以下患者病例信息，生成完整的智慧医疗方案。

## 患者病例信息
{case_info}

请按以下结构输出医疗方案：

### 一、病情分析
（对患者病情进行综合分析）

### 二、诊断建议
（基于症状和检查结果的诊断意见）

### 三、治疗方案
（详细的治疗计划，包括治疗方式、阶段安排）

### 四、用药建议
（具体药物、剂量、用法、疗程、注意事项）

### 五、进一步检查建议
（需要补充的检查项目及目的）

### 六、生活方式指导
（饮食、运动、作息等方面的建议）

### 七、随访计划
（复诊时间安排、监测指标）

### 八、决策依据说明
（方案制定的医学依据和参考来源）

### 九、风险提示
（可能的风险、不良反应及应对措施）"""

    return call_qwen(prompt, context=retrieved_docs)


def analyze_symptoms(symptoms_text):
    """症状分析"""
    prompt = f"""请对以下症状描述进行专业分析：

{symptoms_text}

请给出：
1. 可能的疾病诊断（按可能性排序）
2. 建议的检查项目
3. 初步处理建议"""

    return call_qwen(prompt)
