require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 5000;

// --- Middleware ---
app.use(cors()); // Allows frontend to communicate with backend
app.use(express.json()); // Parses incoming JSON requests

// --- Database Connection (Placeholder) ---
// mongoose.connect(process.env.MONGO_URI)
//   .then(() => console.log('MongoDB Connected'))
//   .catch(err => console.error('MongoDB Connection Error:', err));


// --- Routes ---

// 1. Health Check Route (Good for Kubernetes Readiness Probes later)
app.get('/api/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Backend is running smoothly' });
});

// 2. Demo Product Route (Temporary until DB is set up)
app.get('/api/products', (req, res) => {
    // This is the same data as frontend, just serving from API to test connectivity later
    const demoData = [
        { id: 1, name: "API Served Backpack", price: 129.99, image: "...", category: "Accessories" },
        { id: 2, name: "API Served Headphones", price: 249.50, image: "...", category: "Electronics" },
    ];
    res.json(demoData);
});


// --- Start Server ---
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});