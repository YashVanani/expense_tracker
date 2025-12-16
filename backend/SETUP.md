# Quick Setup Guide

## ✅ MongoDB Connection Setup

Your MongoDB is already running! The `.env` file has been created with:
- **MongoDB URI**: `mongodb://127.0.0.1:27017/expense_tracker`
- **JWT Secret**: A secure random key has been generated
- **Port**: 3000

## 🔑 About JWT Tokens

**Important**: The `JWT_SECRET` in your `.env` file is NOT a JWT token. It's a secret key used to **sign** JWT tokens.

### How JWT Tokens Work:

1. **JWT_SECRET** (in .env): This is a secret key that signs/verifies tokens. ✅ Already set up!

2. **JWT Token** (for API calls): This is generated when users register or login. You get it from the API response.

### Getting a JWT Token:

1. **Register a new user**:
   ```bash
   POST http://localhost:3000/api/auth/register
   Body: {
     "email": "test@example.com",
     "password": "password123"
   }
   ```
   Response will include a `token` field - that's your JWT token!

2. **Or Login**:
   ```bash
   POST http://localhost:3000/api/auth/login
   Body: {
     "email": "test@example.com",
     "password": "password123"
   }
   ```
   Response will include a `token` field - that's your JWT token!

3. **Use the token** in subsequent API calls:
   ```
   Header: Authorization: Bearer <your_token_here>
   ```

## 🚀 Starting the Server

1. **Install dependencies** (if not done):
   ```bash
   npm install
   ```

2. **Start the server**:
   ```bash
   npm run dev    # Development mode (auto-reload)
   # or
   npm start      # Production mode
   ```

3. **Test the connection**:
   ```bash
   curl http://localhost:3000/api/health
   ```

## 📝 Testing with cURL

### Register a User:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Login:
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Create Expense (replace YOUR_TOKEN with actual token):
```bash
curl -X POST http://localhost:3000/api/expenses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title":"Groceries","amount":150.50,"category":"Food"}'
```

## 🔄 Single Configuration (Dev & Production)

The current setup works for both development and production:
- Uses environment variables from `.env` file
- MongoDB connection string can be changed in `.env` for production
- JWT secret is already secure and can be reused
- No code changes needed between environments

For production, just update the `.env` file with:
- Production MongoDB URI (e.g., MongoDB Atlas)
- Stronger JWT_SECRET (optional, current one is already secure)
- Set `NODE_ENV=production`

