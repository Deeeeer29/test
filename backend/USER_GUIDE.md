# Don't Buy Yet Backend - 用户使用指南

## 快速开始

### 1. 环境准备
```
# 确保Python 3.8+已安装
python --version

# 进入项目目录
cd backend
```

### 2. 一键安装（推荐）
```
# 运行安装脚本
python install_deps.py
```

### 3. 手动安装
```
# 安装核心依赖
pip install fastapi uvicorn sqlalchemy pydantic pydantic-settings python-dotenv

# 或使用requirements文件
pip install -r requirements_simple.txt
```

### 4. 环境配置
```
# 复制环境配置文件
copy .env.example .env

# 编辑环境变量（可选）
# 使用文本编辑器打开.env文件，根据需要修改配置
```

### 5. 数据库初始化
```
# 初始化SQLite数据库
python -c "from app.db.init_db import init_db; init_db()"
```

### 6. 启动应用
```
# 方法1：使用启动脚本
python start_app.py

# 方法2：直接运行
python run.py

# 方法3：使用uvicorn
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### 7. 访问应用
- **API文档**: http://localhost:8000/docs
- **ReDoc文档**: http://localhost:8000/redoc
- **健康检查**: http://localhost:8000/api/v1/health

## 功能模块

### 1. 用户管理 (User Profiles)
**功能**: 管理用户基本信息和个人偏好
- 创建用户档案
- 更新用户信息
- 查询用户列表
- 删除用户账户

**API端点**:
```
GET    /api/v1/users/           # 获取用户列表
POST   /api/v1/users/           # 创建新用户
GET    /api/v1/users/{user_id}  # 获取用户详情
PUT    /api/v1/users/{user_id}  # 更新用户信息
DELETE /api/v1/users/{user_id}  # 删除用户
```

### 2. 已有物品管理 (Owned Items)
**功能**: 跟踪用户已拥有的物品
- 记录已购物品信息
- 管理物品状态
- 统计拥有物品

**API端点**:
```
GET    /api/v1/owned-items/           # 获取物品列表
POST   /api/v1/owned-items/           # 添加新物品
GET    /api/v1/owned-items/{item_id}  # 获取物品详情
PUT    /api/v1/owned-items/{item_id}  # 更新物品信息
DELETE /api/v1/owned-items/{item_id}  # 删除物品
```

### 3. 产品管理 (Products)
**功能**: 管理待购产品信息
- 添加新产品
- 更新产品信息
- 查询产品列表
- 删除产品记录

**API端点**:
```
GET    /api/v1/products/           # 获取产品列表
POST   /api/v1/products/           # 添加新产品
GET    /api/v1/products/{product_id}  # 获取产品详情
PUT    /api/v1/products/{product_id}  # 更新产品信息
DELETE /api/v1/products/{product_id}  # 删除产品
```

### 4. 问卷系统 (Questionnaires)
**功能**: 购买决策评估问卷
- 创建评估问卷
- 提交问卷回答
- 分析问卷结果
- 生成购买建议

**API端点**:
```
GET    /api/v1/questionnaires/           # 获取问卷列表
POST   /api/v1/questionnaires/           # 创建新问卷
GET    /api/v1/questionnaires/{q_id}     # 获取问卷详情
PUT    /api/v1/questionnaires/{q_id}     # 更新问卷
DELETE /api/v1/questionnaires/{q_id}     # 删除问卷
```

### 5. 分析引擎 (Analysis)
**功能**: 购买决策分析
- 自动评分计算
- 原因分析生成
- 购买建议生成
- 历史记录分析

**API端点**:
```
GET    /api/v1/analysis/           # 获取分析列表
POST   /api/v1/analysis/           # 创建新分析
GET    /api/v1/analysis/{analysis_id}  # 获取分析详情
PUT    /api/v1/analysis/{analysis_id}  # 更新分析
DELETE /api/v1/analysis/{analysis_id}  # 删除分析
```

### 6. 冷静期系统 (Cooling Items)
**功能**: 物品冷静期跟踪
- 添加冷静期物品
- 跟踪剩余时间
- 发送提醒通知
- 管理冷静状态

**API端点**:
```
GET    /api/v1/cooling-items/           # 获取冷静物品列表
POST   /api/v1/cooling-items/           # 添加冷静物品
GET    /api/v1/cooling-items/{item_id}  # 获取物品详情
PUT    /api/v1/cooling-items/{item_id}  # 更新物品状态
DELETE /api/v1/cooling-items/{item_id}  # 删除物品
```

### 7. 购买复盘 (Purchase Reviews)
**功能**: 购买后评价系统
- 记录购买体验
- 评价决策质量
- 总结经验教训
- 改进未来决策

**API端点**:
```
GET    /api/v1/purchase-reviews/           # 获取复盘列表
POST   /api/v1/purchase-reviews/           # 创建新复盘
GET    /api/v1/purchase-reviews/{review_id}  # 获取复盘详情
PUT    /api/v1/purchase-reviews/{review_id}  # 更新复盘
DELETE /api/v1/purchase-reviews/{review_id}  # 删除复盘
```

### 8. 报告系统 (Reports)
**功能**: 数据分析和报告
- 生成统计报告
- 导出数据
- 可视化分析
- 趋势预测

**API端点**:
```
GET    /api/v1/reports/  # 生成标准报告
POST   /api/v1/reports/  # 创建自定义报告
```

## 配置说明

### 环境变量配置 (.env文件)

```
# 数据库配置
DATABASE_URL=sqlite:///./dontbuyyet.db
# PostgreSQL示例: postgresql://user:password@localhost/dontbuyyet

# 应用配置
APP_NAME=Don't Buy Yet
APP_VERSION=1.0.0
DEBUG=True  # 开发环境设为True，生产环境设为False

# CORS配置（允许的前端域名）
CORS_ORIGINS=["http://localhost:3000", "http://127.0.0.1:3000"]

# API配置
API_V1_STR=/api/v1

# LLM配置（可选）
LLM_API_KEY=your_api_key_here
LLM_BASE_URL=http://localhost:11434
LLM_MODEL=llama3.2
LLM_ENABLED=False  # 设为True启用AI功能

# 评分权重配置
SCORING_WEIGHTS={"price": 0.3, "need": 0.4, "urgency": 0.3}
```

## Docker部署

### 使用Docker Compose（推荐）
```
# 一键启动所有服务
docker-compose up --build

# 后台运行
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 停止并清理
docker-compose down -v
```

### 手动Docker部署
```
# 构建镜像
docker build -t dontbuyyet-backend .

# 运行容器
docker run -p 8000:8000 dontbuyyet-backend

# 带环境变量运行
docker run -p 8000:8000 ^
  -e DATABASE_URL=postgresql://user:pass@host/db ^
  -e DEBUG=False ^
  dontbuyyet-backend

# 挂载配置文件
docker run -p 8000:8000 ^
  -v %cd%/.env:/app/.env ^
  dontbuyyet-backend
```

## 测试与验证

### 运行测试
```
# 运行所有测试
pytest tests/

# 运行特定测试文件
pytest tests/test_health.py

# 带详细输出
pytest tests/ -v

# 运行测试并显示覆盖率
pytest tests/ --cov=app
```

### 验证API
```
# 使用curl测试健康检查
curl http://localhost:8000/api/v1/health

# 测试用户列表
curl http://localhost:8000/api/v1/users/

# 创建测试用户
curl -X POST http://localhost:8000/api/v1/users/ ^
  -H "Content-Type: application/json" ^
  -d "{\"name\": \"测试用户\", \"email\": \"test@example.com\"}"
```

## 故障排除

### 常见问题

#### 1. 依赖安装失败
**症状**: `pip install` 失败或超时
**解决方案**:
```
# 使用国内镜像源
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements_simple.txt

# 分步安装
python install_deps.py

# 或手动安装核心包
pip install fastapi uvicorn sqlalchemy pydantic
```

#### 2. 数据库初始化失败
**症状**: `init_db()` 报错
**解决方案**:
```
# 确保在项目根目录
cd backend

# 检查Python路径
python -c "import sys; print(sys.path)"

# 手动初始化
python -c "
import sys
sys.path.insert(0, '.')
from app.db.init_db import init_db
init_db()
print('Database initialized')
"
```

#### 3. 应用启动失败
**症状**: `ModuleNotFoundError` 或导入错误
**解决方案**:
```
# 确保在backend目录
cd backend

# 设置Python路径
set PYTHONPATH=%cd%

# 或使用绝对路径
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## 开始使用

现在你已经准备好使用Don't Buy Yet后端应用了！按照以下步骤开始：

1. **安装依赖**: `python install_deps.py`
2. **配置环境**: 编辑`.env`文件
3. **初始化数据库**: `python -c "from app.db.init_db import init_db; init_db()"`
4. **启动应用**: `python start_app.py`
5. **访问文档**: http://localhost:8000/docs
6. **开始开发**: 使用API端点构建前端应用

## 支持与帮助

### 获取帮助
1. **查看文档**: http://localhost:8000/docs
2. **检查日志**: 应用运行日志
3. **测试API**: 使用curl或Postman
4. **查看源码**: 代码注释和文档

### 报告问题
1. 描述问题现象
2. 提供错误信息
3. 说明复现步骤
4. 提供环境信息

---

**Happy Coding! 🎉**