# Expense Tracker Backend API

A RESTful API backend for an Expense Tracker mobile application built with Node.js, Express, and MongoDB.

## Features

- User authentication (Register/Login) with JWT
- CRUD operations for expenses
- Expense summary and category breakdown
- Secure password hashing with bcrypt
- MongoDB database integration

## Tech Stack

- **Node.js** - Runtime environment
- **Express** - Web framework
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

## API Endpoints

### Authentication Routes

#### Register User
- **POST** `/api/auth/register`
- **Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response:**
  ```json
  {
    "success": true,
    "message": "User registered successfully",
    "token": "jwt_token_here",
    "user": {
      "id": "user_id",
      "email": "user@example.com"
    }
  }
  ```

#### Login User
- **POST** `/api/auth/login`
- **Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response:**
  ```json
  {
    "success": true,
    "message": "Login successful",
    "token": "jwt_token_here",
    "user": {
      "id": "user_id",
      "email": "user@example.com"
    }
  }
  ```

### Expense Routes (Protected - Requires JWT Token)

**Note:** All expense routes require authentication. Include the JWT token in the request header:
```
Authorization: Bearer <your_jwt_token>
```

#### Get All Expenses
- **GET** `/api/expenses`
- **Headers:** `Authorization: Bearer <token>`
- **Response:**
  ```json
  {
    "success": true,
    "count": 5,
    "totalAmount": 1250.50,
    "expenses": [
      {
        "_id": "expense_id",
        "title": "Groceries",
        "amount": 150.50,
        "category": "Food",
        "date": "2024-01-15T00:00:00.000Z",
        "user": "user_id",
        "createdAt": "2024-01-15T10:00:00.000Z",
        "updatedAt": "2024-01-15T10:00:00.000Z"
      }
    ]
  }
  ```

#### Get Single Expense
- **GET** `/api/expenses/:id`
- **Headers:** `Authorization: Bearer <token>`

#### Create Expense
- **POST** `/api/expenses`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "title": "Groceries",
    "amount": 150.50,
    "category": "Food",
    "date": "2024-01-15" // Optional, defaults to current date
  }
  ```

#### Update Expense
- **PUT** `/api/expenses/:id`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "title": "Updated Title",
    "amount": 200.00,
    "category": "Shopping",
    "date": "2024-01-16"
  }
  ```
  (All fields are optional - only include fields you want to update)

#### Delete Expense
- **DELETE** `/api/expenses/:id`
- **Headers:** `Authorization: Bearer <token>`

#### Get Expense Summary
- **GET** `/api/expenses/summary`
- **Headers:** `Authorization: Bearer <token>`
- **Response:**
  ```json
  {
    "success": true,
    "summary": {
      "totalExpenses": 5,
      "totalAmount": 1250.50,
      "categoryBreakdown": {
        "Food": 450.50,
        "Transport": 300.00,
        "Shopping": 500.00
      }
    }
  }
  ```

### Health Check
- **GET** `/api/health`
- **Response:**
  ```json
  {
    "success": true,
    "message": "Server is running"
  }
  ```

## Error Responses

All error responses follow this format:
```json
{
  "success": false,
  "message": "Error message here"
}
```

Common HTTP status codes:
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (invalid/missing token)
- `404` - Not Found
- `500` - Internal Server Error

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

## Connecting Flutter App

To connect your Flutter app to this backend:

1. **Base URL**: `http://localhost:3000` (for development)
   - For Android emulator: `http://10.0.2.2:3000`
   - For iOS simulator: `http://localhost:3000`
   - For physical device: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

2. **HTTP Package**: Use `http` or `dio` package in Flutter for API calls

3. **Token Storage**: Store JWT token using `shared_preferences` package

4. **Example API Call**:
   ```dart
   // Login example
   final response = await http.post(
     Uri.parse('http://10.0.2.2:3000/api/auth/login'),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       'email': 'user@example.com',
       'password': 'password123',
     }),
   );
   
   final data = jsonDecode(response.body);
   final token = data['token'];
   // Store token in shared_preferences
   ```

## Testing with Postman/Thunder Client

1. Register a new user at `POST /api/auth/register`
2. Copy the `token` from the response
3. Use this token in the Authorization header for all expense endpoints:
   - Header: `Authorization`
   - Value: `Bearer <your_token>`

## License

ISC

