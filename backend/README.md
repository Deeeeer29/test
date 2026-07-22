# 消费决策辅助系统后端

基于大模型的消费决策辅助系统后端API，帮助用户做出更理性的消费决策。

## 功能特性

- **用户画像管理**：创建和管理用户消费画像
- **商品管理**：管理用户想要购买的商品
- **问卷系统**：收集用户对商品的评估信息
- **智能分析**：基于大模型的消费决策分析
- **冷静池**：帮助用户冷静思考的等待机制
- **购买复盘**：记录和分析购买后的满意度
- **报告系统**：生成消费行为报告和洞察

## 技术栈

- **Python 3.11+**
- **FastAPI** - 高性能Web框架
- **SQLAlchemy** - ORM
- **Alembic** - 数据库迁移
- **Pydantic** - 数据验证
- **PostgreSQL** - 数据库（支持SQLite开发）
- **Docker** - 容器化部署

## 快速开始

### 1. 环境设置

```bash
# 克隆项目
git clone <repository-url>
cd backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

### 2. 配置环境变量

复制环境变量模板并配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件，设置必要的环境变量：

```env
# 数据库配置
DATABASE_URL=sqlite:///./don_t_buy_yet.db

# 大模型API配置（可选）
MODEL_API_BASE_URL=https://api.openai.com/v1
MODEL_API_KEY=your_api_key_here
MODEL_NAME=gpt-3.5-turbo

# 应用配置
DEBUG=true
ENVIRONMENT=development
```

### 3. 数据库设置

```bash
# 初始化数据库迁移
alembic init alembic

# 生成迁移脚本
alembic revision --autogenerate -m "Initial migration"

# 应用迁移
alembic upgrade head
```

### 4. 运行应用

```bash
# 开发模式（热重载）
python run.py

# 或使用uvicorn直接运行
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 5. 访问API文档

应用启动后，访问以下地址：

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **API根路径**: http://localhost:8000/

## Docker部署

### 使用Docker Compose

```bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f app

# 停止服务
docker-compose down

# 停止并删除数据卷
docker-compose down -v
```

### 单独构建Docker镜像

```bash
# 构建镜像
docker build -t dontbuyyet-backend .

# 运行容器
docker run -p 8000:8000 --env-file .env dontbuyyet-backend
```

## API端点

### 健康检查
- `GET /api/v1/health` - 检查API和数据库状态

### 用户画像
- `GET /api/v1/user-profiles` - 获取用户列表
- `POST /api/v1/user-profiles` - 创建用户
- `GET /api/v1/user-profiles/{user_id}` - 获取用户详情
- `PUT /api/v1/user-profiles/{user_id}` - 更新用户
- `DELETE /api/v1/user-profiles/{user_id}` - 删除用户

### 商品管理
- `GET /api/v1/products` - 获取商品列表
- `POST /api/v1/products` - 创建商品
- `GET /api/v1/products/{product_id}` - 获取商品详情
- `PUT /api/v1/products/{product_id}` - 更新商品
- `DELETE /api/v1/products/{product_id}` - 删除商品

### 问卷系统
- `GET /api/v1/questionnaires` - 获取问卷列表
- `POST /api/v1/questionnaires` - 创建问卷
- `GET /api/v1/questionnaires/{questionnaire_id}` - 获取问卷详情

### 智能分析
- `POST /api/v1/analysis/analyze` - 分析商品
- `GET /api/v1/analysis/{analysis_id}` - 获取分析结果
- `GET /api/v1/analysis/user/{user_id}` - 获取用户分析历史

### 冷静池
- `POST /api/v1/cooling-items` - 添加商品到冷静池
- `GET /api/v1/cooling-items/user/{user_id}` - 获取用户冷静池
- `PUT /api/v1/cooling-items/{cooling_item_id}/complete` - 完成冷静期
- `DELETE /api/v1/cooling-items/{cooling_item_id}` - 从冷静池移除

### 购买复盘
- `POST /api/v1/purchase-reviews` - 创建购买复盘
- `GET /api/v1/purchase-reviews/user/{user_id}` - 获取用户购买复盘
- `PUT /api/v1/purchase-reviews/{review_id}` - 更新购买复盘

### 报告系统
- `GET /api/v1/reports/user/{user_id}/summary` - 获取用户总结报告
- `GET /api/v1/reports/user/{user_id}/monthly` - 获取月度报告
- `GET /api/v1/reports/user/{user_id}/cooling-effectiveness` - 获取冷静池效果报告

## 开发

### 代码风格

```bash
# 格式化代码
black .

# 检查代码风格
flake8 .

# 类型检查
mypy .
```

### 测试

```bash
# 运行测试
pytest

# 运行测试并生成覆盖率报告
pytest --cov=app tests/

# 运行特定测试
pytest tests/test_user_profiles.py -v
```

### 数据库迁移

```bash
# 创建新的迁移
alembic revision --autogenerate -m "描述变更"

# 应用迁移
alembic upgrade head

# 回滚迁移
alembic downgrade -1

# 查看迁移历史
alembic history
```

## 项目结构

```
backend/
├── app/
│   ├── api/
│   │   └── endpoints/          # API路由
│   ├── core/                   # 核心模块
│   │   ├── config.py          # 配置管理
│   │   ├── exceptions.py      # 自定义异常
│   │   └── error_handler.py   # 错误处理
│   ├── db/                    # 数据库模块
│   │   ├── base.py           # 数据库基础配置
│   │   └── session.py        # 数据库会话管理
│   ├── models/               # SQLAlchemy模型
│   ├── schemas/              # Pydantic模型
│   └── services/             # 业务逻辑服务
├── alembic/                  # 数据库迁移
├── tests/                    # 测试文件
├── .env.example             # 环境变量模板
├── .env                     # 环境变量（本地）
├── requirements.txt         # Python依赖
├── Dockerfile              # Docker配置
├── docker-compose.yml      # Docker Compose配置
├── run.py                  # 应用入口点
└── README.md               # 项目说明
```

## 环境配置

### 开发环境
- 使用SQLite进行快速开发
- 启用调试模式
- 详细的日志输出

### 生产环境
- 使用PostgreSQL数据库
- 禁用调试模式
- 配置适当的CORS策略
- 设置安全密钥
- 启用HTTPS

### 测试环境
- 使用测试数据库
- 启用测试模式
- 配置测试专用API密钥

## 部署

### 传统部署

1. 安装依赖：`pip install -r requirements.txt`
2. 设置环境变量
3. 初始化数据库：`alembic upgrade head`
4. 启动应用：`python run.py`

### Docker部署

1. 构建镜像：`docker build -t dontbuyyet-backend .`
2. 运行容器：`docker run -p 8000:8000 --env-file .env dontbuyyet-backend`

### Kubernetes部署

参考 `kubernetes/` 目录下的配置文件。

## 监控和日志

- 应用日志：`logs/app.log`
- 访问日志：`logs/access.log`
- 错误日志：`logs/error.log`

## 许可证

MIT License