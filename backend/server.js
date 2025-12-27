require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require("axios");
const mongoose = require('mongoose');
const orderRoutes = require("./routes/order.routes.js");
const products = require("./routes/product.routes.js");
const searchRoutes = require("./routes/search.routes.js");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use("/api/orders", orderRoutes);

// --- Database Connection (Placeholder) ---
// mongoose.connect(process.env.MONGO_URI)
//   .then(() => console.log('MongoDB Connected'))
//   .catch(err => console.error('MongoDB Connection Error:', err));

app.get('/api/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Backend is running smoothly' });
});

app.use("/api/products", products);
app.use("/api/search", searchRoutes);

app.listen(5000, "0.0.0.0", () => {
  console.log("Server running on 5000");
});


