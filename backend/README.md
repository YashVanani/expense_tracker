# Expense Tracker Backend API

A RESTful API backend for an Expense Tracker mobile application built with Node.js, and MongoDB.

## Features

- User authentication (Register/Login) with JWT
- CRUD operations for expenses
- Expense summary and category breakdown
- MongoDB database integration

## Tech Stack

- **Node.js** - Runtime environment
- **MongoDB** - Database
- **Mongoose** - MongoDB ODM
- **JWT** - Authentication
- **bcryptjs** - Password hashing

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/expense_tracker
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d
```

**Note:** Make sure to change `JWT_SECRET` to a strong, random string in production.

### 3. Start MongoDB

Make sure MongoDB is running on your system. If you don't have MongoDB installed:

- **macOS**: `brew install mongodb-community`
- **Windows**: Download from [MongoDB website](https://www.mongodb.com/try/download/community)
- **Linux**: `sudo apt-get install mongodb`

Or use MongoDB Atlas (cloud) and update `MONGODB_URI` accordingly.

### 4. Run the Server

```bash
# Development mode (with nodemon)
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:3000` (or the PORT specified in .env)

## Project Structure

```
expense_tracker_backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/
│   ├── authController.js    # Authentication logic
│   └── expenseController.js # Expense CRUD logic
├── middleware/
│   └── auth.js              # JWT authentication middleware
├── models/
│   ├── User.js              # User model
│   └── Expense.js           # Expense model
├── routes/
│   ├── authRoutes.js        # Authentication routes
│   └── expenseRoutes.js     # Expense routes
├── .env                     # Environment variables (create this)
├── .gitignore
├── index.js                 # Main server file
└── package.json
```

