#!/bin/bash

# Set project directory names
BACKEND_DIR="web-app-backend"
FRONTEND_DIR="web-app-frontend"

# Create Backend (Node.js + Express)
echo "Setting up backend with Node.js and Express..."

# Step 1: Create backend directory and initialize Node.js project
mkdir $BACKEND_DIR
cd $BACKEND_DIR
npm init -y

# Step 2: Install necessary dependencies for backend
npm install express mongoose cors dotenv

# Step 3: Install nodemon for development (optional)
npm install --save-dev nodemon

# Step 4: Create server.js (backend entry point)
cat <<EOL > server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Database connection (Optional)
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Basic route
app.get('/', (req, res) => {
    res.send('Hello from the backend');
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
});
EOL

# Step 5: Create a .env file
cat <<EOL > .env
MONGO_URI=mongodb://localhost:27017/your_database_name
PORT=5000
EOL

# Step 6: Add development script to package.json
sed -i '/"scripts": {/a "dev": "nodemon server.js",' package.json

echo "Backend setup complete."

# Return to root directory
cd ..

# Create Frontend (React)
echo "Setting up frontend with React..."

# Step 1: Use create-react-app to create a frontend
npx create-react-app $FRONTEND_DIR

# Step 2: Move into frontend directory
cd $FRONTEND_DIR

# Step 3: Install Axios for making HTTP requests
npm install axios

# Step 4: Create a simple component that connects to the backend
mkdir -p src/components
cat <<EOL > src/components/Welcome.js
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function Welcome() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    axios.get('http://localhost:5000/')
      .then(response => {
        setMessage(response.data);
      })
      .catch(error => {
        console.error('There was an error fetching the data!', error);
      });
  }, []);

  return (
    <div>
      <h1>{message}</h1>
    </div>
  );
}

export default Welcome;
EOL

# Step 5: Modify App.js to include the new component
cat <<EOL > src/App.js
import React from 'react';
import './App.css';
import Welcome from './components/Welcome';

function App() {
  return (
    <div className="App">
      <Welcome />
    </div>
  );
}

export default App;
EOL

echo "Frontend setup complete."

# Step 6: Return to root directory and provide final instructions
cd ..

# Final Message
echo "Web application setup complete."
echo "To run the backend:"
echo "1. Navigate to $BACKEND_DIR and run: npm run dev"
echo ""
echo "To run the frontend:"
echo "2. Navigate to $FRONTEND_DIR and run: npm start"
echo ""
echo "Make sure both backend and frontend are running, and visit the frontend at http://localhost:3000."
