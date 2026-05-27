# 基于患者病例生成智慧医疗方案系统

## 项目简介

本系统采用**大模型 + RAG（检索增强生成）技术**构建智慧医疗方案生成系统，通过搭建医疗专属知识库（含脱敏病例、临床指南等），利用嵌入技术将文档转化为向量存储，实现病例精准语义检索，快速定位相似病例与相关医疗规则，最终生成专业、可解释的医疗方案。

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue3 + Vite + Element Plus + ECharts |
| 后端 | Flask + Flask-SQLAlchemy + Flask-JWT |
| 数据库 | MySQL |
| 大模型 | 通义千问（Qwen-Plus） |
| RAG引擎 | FAISS + DashScope Embedding V3 |
| 向量存储 | FAISS (Facebook AI Similarity Search) |

## 核心功能

1. **患者管理** - 患者信息的增删改查
2. **病历管理** - 电子病历录入、查看、管理
3. **医疗知识库** - 临床指南、病例文档上传与管理，支持文档向量化
4. **智慧方案生成** - 基于RAG技术检索知识库 + 千问大模型生成医疗方案（核心功能）
5. **方案管理** - 方案查看、评分、医生反馈、采纳/驳回
6. **语义检索** - 基于向量相似度的知识库精准检索

## 系统架构

```
用户输入病例 → 文本嵌入向量化 → FAISS相似度检索 → 检索相关知识
                                                        ↓
                                              拼接上下文 + 病例信息
                                                        ↓
                                              通义千问大模型推理
                                                        ↓
                                              输出结构化医疗方案
```

## 快速开始

### 1. 环境准备

- Python 3.9+
- Node.js 18+
- MySQL 8.0+

### 2. 后端启动

```bash
# 进入后端目录
cd backend

# 创建虚拟环境
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 安装依赖
pip install -r requirements.txt

# 配置环境变量（复制并修改.env文件）
copy .env.example .env
# 编辑 .env 文件，填入MySQL密码和DashScope API Key

# 创建MySQL数据库
# 在MySQL中执行：CREATE DATABASE smart_medical CHARACTER SET utf8mb4;

# 初始化数据库（创建表和示例数据）
python init_db.py

# 启动后端服务
python run.py
```

### 3. 前端启动

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 4. 访问系统

- 前端地址：http://localhost:3000
- 后端API：http://localhost:5000
- 默认管理员：admin / admin123
- 默认医生：doctor / doctor123

## 项目结构

```
├── backend/                    # Flask后端
│   ├── app/
│   │   ├── __init__.py         # Flask应用工厂
│   │   ├── config.py           # 配置文件
│   │   ├── models/             # 数据库模型
│   │   │   ├── user.py         # 用户模型
│   │   │   ├── patient.py      # 患者/病历模型
│   │   │   ├── knowledge.py    # 知识库模型
│   │   │   └── plan.py         # 医疗方案模型
│   │   ├── routes/             # API路由
│   │   │   ├── auth.py         # 认证接口
│   │   │   ├── patient.py      # 患者/病历接口
│   │   │   ├── knowledge.py    # 知识库接口
│   │   │   ├── plan.py         # 方案生成接口
│   │   │   └── dashboard.py    # 仪表盘接口
│   │   ├── services/           # 业务服务层
│   │   │   ├── llm_service.py  # 千问大模型服务
│   │   │   └── rag_service.py  # RAG检索服务
│   │   └── utils/              # 工具函数
│   ├── requirements.txt
│   ├── run.py                  # 启动入口
│   └── init_db.py              # 数据库初始化
├── frontend/                   # Vue3前端
│   ├── src/
│   │   ├── api/                # API请求层
│   │   ├── layouts/            # 布局组件
│   │   ├── router/             # 路由配置
│   │   ├── stores/             # Pinia状态管理
│   │   ├── styles/             # 全局样式
│   │   └── views/              # 页面组件
│   ├── package.json
│   └── vite.config.js
└── README.md
```

## API Key 获取

本系统使用阿里云通义千问API，需要获取DashScope API Key：

1. 访问 [阿里云DashScope](https://dashscope.aliyun.com/)
2. 注册/登录后进入控制台
3. 创建API Key
4. 将API Key填入后端 `.env` 文件的 `DASHSCOPE_API_KEY` 字段

## 注意事项

- 本系统生成的医疗方案**仅供参考**，最终诊疗决策须由执业医师做出
- 系统中的病例数据均为脱敏处理后的示例数据
- 建议在使用前先上传相关临床指南到知识库并执行向量化，以提高方案生成质量
