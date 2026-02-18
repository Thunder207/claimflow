# Government Employee Expense Tracker

[![Production Ready](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)](https://github.com/your-org/expense-tracker)
[![Quality Score](https://img.shields.io/badge/QA%20Score-100%25-brightgreen)](./docs/quality-report.md)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green)](https://nodejs.org/)
[![License](https://img.shields.io/badge/License-Government-blue)](./LICENSE)

A comprehensive expense management system designed specifically for government employees, featuring NJC per diem compliance, comprehensive audit trails, and enterprise-grade security.

## 🚀 Features

### Core Functionality
- **📝 Expense Submission** - Individual and trip-based expense workflows
- **🏛️ NJC Compliance** - Official government per diem rates (2026)
- **🧳 Trip Management** - Concur-style trip expense grouping
- **📷 Receipt Capture** - Mobile-optimized photo capture and upload
- **📊 Real-time Dashboard** - Expense tracking and approval status

### Security & Compliance
- **🔐 Role-based Access Control** - Employee, Supervisor, Administrator roles
- **📋 Comprehensive Audit Trail** - SOX compliance ready
- **🛡️ Session Management** - Secure authentication with automatic timeout
- **🔍 Data Validation** - Strict per diem and receipt validation

### Enterprise Features
- **⚡ Mobile Progressive Web App** - Works offline, installable
- **🎯 Automated Workflows** - Draft management and batch submission
- **📈 Analytics Dashboard** - Spending insights and compliance reporting
- **🔄 Export Capabilities** - CSV, Excel, PDF reports for auditors

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [API Documentation](#api-documentation)
- [Development](#development)
- [Security](#security)
- [Compliance](#compliance)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Modern web browser with JavaScript enabled

### 1-Minute Setup
```bash
# Clone the repository
git clone https://github.com/your-org/expense-tracker.git
cd expense-tracker

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Start the application
npm start
```

Navigate to `http://localhost:3000` and login with demo credentials:
- **Employee**: `david.wilson@company.com` / `david123`
- **Supervisor**: `sarah.johnson@company.com` / `sarah123`  
- **Administrator**: `john.smith@company.com` / `manager123`

## 📦 Installation

### Development Installation
```bash
# Clone the repository
git clone https://github.com/your-org/expense-tracker.git
cd expense-tracker

# Install all dependencies (including dev dependencies)
npm install

# Set up environment variables
cp .env.example .env
# Edit .env file with your configuration

# Initialize the database
npm run db:init

# Start in development mode with hot reload
npm run dev
```

### Production Installation
```bash
# Clone the repository
git clone https://github.com/your-org/expense-tracker.git
cd expense-tracker

# Install production dependencies only
npm ci --only=production

# Set up production environment
cp .env.example .env
# Configure production settings in .env

# Build production assets (if applicable)
npm run build

# Start the production server
npm start
```

## ⚙️ Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure the following critical settings:

#### Required Settings
```env
# Security (CRITICAL - Change in production)
SESSION_SECRET=your-super-secure-random-session-secret
PASSWORD_SALT=your-secure-password-salt

# Application
NODE_ENV=production
PORT=3000
BASE_URL=https://your-domain.com

# Database
DATABASE_PATH=./database/expenses.db
# For PostgreSQL: DATABASE_URL=postgresql://user:pass@host:port/db
```

#### Optional Settings
```env
# Email Notifications
EMAIL_PROVIDER=smtp
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email@domain.com

# File Storage
FILE_STORAGE=local
MAX_FILE_SIZE=10485760

# Compliance
DEPARTMENT_NAME="Your Government Department"
FISCAL_YEAR=2026
STRICT_COMPLIANCE=true
```

### Database Configuration

#### SQLite (Default - Development)
```bash
# Database is automatically created on first run
# Location: ./database/expenses.db
```

#### PostgreSQL (Production Recommended)
```bash
# Set DATABASE_URL in .env
DATABASE_URL=postgresql://username:password@host:port/database_name

# Run migrations
npm run db:migrate
```

#### Database Schema
```sql
-- Core Tables
employees         -- User accounts and profiles
expenses          -- Expense records  
trips            -- Business trip information
njc_rates        -- Government per diem rates
audit_log        -- Comprehensive audit trail
login_history    -- Authentication tracking
```

## 🚀 Deployment

### Railway (Recommended)
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login and create project  
railway login
railway init

# 3. Set environment variables
railway variables set SESSION_SECRET=$(openssl rand -hex 32)
railway variables set PASSWORD_SALT=$(openssl rand -hex 16)
railway variables set NODE_ENV=production

# 4. Deploy
railway up
```

### Docker Deployment
```bash
# Build the image
docker build -t expense-tracker .

# Run with environment file
docker run -d \
  --name expense-tracker \
  -p 3000:3000 \
  --env-file .env \
  -v ./uploads:/app/uploads \
  -v ./database:/app/database \
  expense-tracker
```

### Docker Compose
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/expenses
    volumes:
      - ./uploads:/app/uploads
    depends_on:
      - db
      
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=expenses
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Heroku Deployment
```bash
# Install Heroku CLI and login
heroku login

# Create application
heroku create your-expense-tracker

# Set environment variables
heroku config:set SESSION_SECRET=$(openssl rand -hex 32)
heroku config:set PASSWORD_SALT=$(openssl rand -hex 16)
heroku config:set NODE_ENV=production

# Deploy
git push heroku main
```

### Manual Server Deployment
```bash
# On your server (Ubuntu/CentOS)
# 1. Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. Create application user
sudo useradd -m -s /bin/bash expenseapp

# 3. Deploy application
sudo -u expenseapp git clone https://github.com/your-org/expense-tracker.git /home/expenseapp/app
cd /home/expenseapp/app
sudo -u expenseapp npm ci --only=production

# 4. Configure environment
sudo -u expenseapp cp .env.example .env
sudo -u expenseapp nano .env

# 5. Set up systemd service
sudo cp docs/systemd/expense-tracker.service /etc/systemd/system/
sudo systemctl enable expense-tracker
sudo systemctl start expense-tracker

# 6. Configure nginx proxy
sudo cp docs/nginx/expense-tracker.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/expense-tracker.conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx
```

## 🔌 API Documentation

### Authentication
```bash
# Login
POST /api/auth/login
{
  "email": "user@company.com",
  "password": "password123"
}

# Response
{
  "success": true,
  "sessionId": "session-token-here",
  "user": {
    "id": 1,
    "name": "John Doe",
    "role": "employee"
  }
}
```

### Expense Management
```bash
# Create Expense
POST /api/expenses
Headers: Authorization: Bearer <session-token>
{
  "expense_type": "lunch",
  "amount": 29.75,
  "date": "2026-02-17",
  "location": "Ottawa, ON",
  "vendor": "Restaurant Name",
  "description": "Client meeting lunch"
}

# Get User Expenses
GET /api/expenses/my
Headers: Authorization: Bearer <session-token>

# Approve Expense (Supervisor/Admin only)
POST /api/expenses/:id/approve
Headers: Authorization: Bearer <session-token>
{
  "comment": "Approved - valid business expense",
  "approver": "Supervisor Name"
}
```

### Trip Management  
```bash
# Create Trip
POST /api/trips
Headers: Authorization: Bearer <session-token>
{
  "name": "Ottawa Conference 2026",
  "destination": "Ottawa, ON",
  "start_date": "2026-03-15",
  "end_date": "2026-03-17",
  "purpose": "Annual IT Conference"
}

# Submit Trip for Approval
POST /api/trips/:id/submit
Headers: Authorization: Bearer <session-token>
```

## 🛠️ Development

### Development Setup
```bash
# Install development dependencies
npm install

# Run development server with hot reload
npm run dev

# Run tests
npm test

# Run QA checks
npm run qa

# Lint code
npm run lint

# Format code
npm run format
```

### Project Structure
```
expense-app/
├── app.js                 # Main Express application
├── server.js             # HTTP server setup
├── package.json          # Dependencies and scripts
├── Dockerfile            # Container configuration
├── railway.json          # Railway deployment config
├── .env.example          # Environment template
├── README.md             # This file
│
├── database/             # SQLite database storage
├── uploads/             # File upload storage
├── logs/               # Application and audit logs
├── exports/            # Generated reports
│
├── public/             # Static assets
│   ├── index.html      # Login page  
│   ├── admin.html      # Admin dashboard
│   └── employee-dashboard.html  # Main app interface
│
├── utils/              # Utility modules
│   ├── audit-system.js    # Audit trail implementation
│   ├── concur-enhancements.js  # Enterprise features
│   └── njc-rates-service.js    # Government rates service
│
├── tests/              # Test suites
│   ├── qa-agent.js        # Quality assurance testing
│   ├── test-*.js          # Feature-specific tests
│   └── fixtures/          # Test data
│
└── docs/               # Documentation
    ├── api.md             # API documentation
    ├── deployment.md      # Deployment guides
    └── compliance.md      # Government compliance notes
```

### Available Scripts
```bash
npm start          # Start production server
npm run dev        # Start development server with nodemon
npm test           # Run test suite
npm run qa         # Run quality assurance checks
npm run audit      # Run security audit
npm run lint       # Lint JavaScript code
npm run format     # Format code with Prettier
npm run db:init    # Initialize database
npm run db:migrate # Run database migrations
npm run db:seed    # Seed database with demo data
npm run docs       # Generate API documentation
```

### Testing
```bash
# Run all tests
npm test

# Run specific test suites
npm run test:auth          # Authentication tests
npm run test:expenses      # Expense management tests
npm run test:api          # API endpoint tests
npm run test:ui           # User interface tests

# Run QA agent (comprehensive system testing)
npm run qa

# Generate test coverage report
npm run coverage
```

## 🔒 Security

### Authentication & Authorization
- **Session-based authentication** with secure HTTP-only cookies
- **Role-based access control** (RBAC) with three levels: Employee, Supervisor, Administrator
- **Password hashing** with SHA-256 and configurable salt
- **Session timeout** with configurable duration
- **Account lockout** after failed login attempts

### Data Protection
- **Input validation** and sanitization on all user inputs
- **SQL injection prevention** through parameterized queries
- **File upload validation** with type and size restrictions
- **XSS protection** through proper output encoding
- **CSRF protection** with token validation

### Audit & Monitoring
- **Comprehensive audit trail** for all user actions
- **Login/logout tracking** with IP address and user agent
- **Failed authentication logging** with rate limiting
- **High-risk action alerts** for security monitoring
- **Data change tracking** with before/after values

### Production Security Checklist
- [ ] Change default `SESSION_SECRET` and `PASSWORD_SALT`
- [ ] Enable HTTPS with valid SSL certificate
- [ ] Configure firewall to restrict database access
- [ ] Set up regular database backups
- [ ] Enable audit logging and monitoring
- [ ] Review and configure rate limiting
- [ ] Set up security headers (helmet.js)
- [ ] Regular security updates and patches

## 📊 Compliance

### Government Standards
- **NJC Compliance** - Official 2026 per diem rates
- **Audit Trail** - SOX and government auditing standards
- **Data Retention** - Configurable retention policies
- **Access Controls** - Role-based security model
- **Documentation** - Comprehensive change tracking

### Per Diem Rates (2026 NJC)
- Breakfast: $23.45
- Lunch: $29.75
- Dinner: $47.05
- Incidentals: $32.08
- Vehicle: $0.68/km

### Audit Features
- **Action Logging** - Every create, update, delete tracked
- **User Activity** - Login/logout with session duration
- **Data Changes** - Field-level change tracking
- **Report Generation** - CSV export for auditors
- **Risk Assessment** - Automated risk level classification

### Data Export
```bash
# Generate audit report
GET /api/admin/audit/export?startDate=2026-01-01&endDate=2026-12-31

# Export user expenses
GET /api/expenses/export?userId=123&format=csv

# Generate compliance report
GET /api/admin/compliance/report?fiscalYear=2026
```

## 🚨 Troubleshooting

### Common Issues

#### Application Won't Start
```bash
# Check Node.js version
node --version  # Should be 18+

# Check environment variables
cat .env | grep -E "(SESSION_SECRET|NODE_ENV|PORT)"

# Check database permissions
ls -la database/
chmod 755 database/
```

#### Login Issues
```bash
# Reset admin password
npm run admin:reset-password

# Check session configuration
# Verify SESSION_SECRET is set and not default value

# Clear browser cache and cookies
```

#### File Upload Problems
```bash
# Check upload directory permissions
ls -la uploads/
chmod 755 uploads/

# Check file size limits
# Verify MAX_FILE_SIZE in .env

# Check disk space
df -h
```

#### Database Issues
```bash
# SQLite: Check database file
ls -la database/expenses.db
sqlite3 database/expenses.db ".schema"

# PostgreSQL: Test connection
npx pg-connection-string parse $DATABASE_URL
```

### Performance Issues
```bash
# Enable compression
ENABLE_GZIP=true

# Check memory usage
node --max-old-space-size=4096 app.js

# Monitor with PM2
npm install -g pm2
pm2 start app.js --name expense-tracker
pm2 monit
```

### Logs & Debugging
```bash
# Application logs
tail -f logs/app.log

# Audit logs
tail -f logs/audit.log

# Enable debug mode (development only)
DEBUG=true npm run dev
```

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](./CONTRIBUTING.md) first.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Run the test suite (`npm test`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code Standards
- Follow existing code style and conventions
- Add comprehensive comments for complex business logic
- Include tests for new features
- Update documentation for API changes
- Run QA checks before submitting (`npm run qa`)

## 📄 License

This project is licensed under the Government License - see the [LICENSE](./LICENSE) file for details.

## 🆘 Support

- **Documentation**: [docs.yourcompany.gov/expense-tracker](https://docs.yourcompany.gov/expense-tracker)
- **Issues**: [GitHub Issues](https://github.com/your-org/expense-tracker/issues)  
- **Email**: expense-tracker-support@yourcompany.gov
- **Phone**: 1-800-EXPENSE (1-800-397-3673)

## 🙏 Acknowledgments

- **National Joint Council (NJC)** for official per diem rates
- **Government of Canada** for travel policy guidelines
- **Open source community** for the foundational tools and libraries
- **Security researchers** for responsible disclosure practices

---

**Built with ❤️ for Government Employees**

*This system is designed to streamline expense reporting while maintaining the highest standards of security, compliance, and auditability required for government operations.*