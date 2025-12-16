# Expense Tracker Application

A full-stack expense tracking application with a Flutter mobile frontend and Node.js backend using MongoDB.

## Project Structure

expense_tracker/
├── backend/          # Node.js API server
└── fronted/          # Flutter mobile application

## Quick Start Guide

### Step 1: Backend Setup

1. Navigate to the backend directory:
   cd backend
   

2. Install dependencies:
   npm install

3. Create a `.env` file in the `backend/` directory:
   
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/expense_tracker
   JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
   JWT_EXPIRE=7d
   

4. Start the backend server:
   
   npm run dev

5. Verify the backend is running:
   - The server should start on `http://localhost:3000`
   - Test the health endpoint: `http://localhost:3000/api/health`
   - You should see: `{"success":true,"message":"Server is running"}`

### Step 2: Frontend Setup

1. Navigate to the frontend directory:
   cd fronted

2. Install Flutter dependencies:
   flutter pub get

3. **Configure Backend URL** (IMPORTANT):
   
   Open `lib/services/api_service.dart` and update the `baseUrl` constant based on your environment:

   ```dart
   // Base URL - Update this with your URL
   // Examples:
   // - Local development: 'http://localhost:3000/api'
   // - Android emulator: 'http://10.0.2.2:3000/api'
   // - iOS simulator: 'http://localhost:3000/api'
   // - Physical device: 'http://YOUR_COMPUTER_IP:3000/api'
   static const String baseUrl = 'http://10.0.2.2:3000/api';
   ```

   **Choose the correct URL based on your setup:**

   - **Android Emulator**: `http://10.0.2.2:3000/api` (default)
   - **iOS Simulator**: `http://localhost:3000/api`
   - **Physical Device**: `http://YOUR_COMPUTER_IP:3000/api`
     - Find your computer's IP address:
       - **macOS/Linux**: `ifconfig` or `ipconfig getifaddr en0`
       - **Windows**: `ipconfig` (look for IPv4 Address)
     - Example: `http://192.168.1.100:3000/api`

4. Run the Flutter app:
   
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run -d ios

   # For a specific device
   flutter devices  # List available devices
   flutter run -d <device_id>

## 📱 Backend URL Configuration Guide

The Flutter app needs to know where your backend server is running. The URL depends on how you're running the app:

### Important Notes for Physical Devices

1. **Both devices must be on the same network** (same Wi-Fi)
2. **Firewall**: Make sure your firewall allows connections on port 3000
3. **Backend must be accessible**: The backend server should bind to `0.0.0.0` (all interfaces) or your local IP, not just `localhost`

   If you need to change the backend binding, modify `backend/index.js`:
   ```javascript
   app.listen(PORT, '0.0.0.0', () => {
     console.log(`🚀 Server is running on port ${PORT}`);
   });
   ```

## 📋 API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user

### Expenses (Protected - Requires JWT Token)
- `GET /api/expenses` - Get all expenses
- `GET /api/expenses/:id` - Get single expense
- `POST /api/expenses` - Create expense
- `PUT /api/expenses/:id` - Update expense
- `DELETE /api/expenses/:id` - Delete expense
- `GET /api/expenses/summary` - Get expense summary

### Health Check
- `GET /api/health` - Server health check
