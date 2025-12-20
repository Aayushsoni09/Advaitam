require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require("axios");
const mongoose = require('mongoose');

const app = express();
const API = "https://api.escuelajs.co/api/v1";
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// --- Database Connection (Placeholder) ---
// mongoose.connect(process.env.MONGO_URI)
//   .then(() => console.log('MongoDB Connected'))
//   .catch(err => console.error('MongoDB Connection Error:', err));

app.get('/api/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Backend is running smoothly' });
});

app.get("/api/products", async (req, res) => {
  const { data } = await axios.get(`${API}/products`);
  res.json(data);
});

app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});