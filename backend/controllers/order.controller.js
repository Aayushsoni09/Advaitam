const { v4: uuidv4 } = require("uuid");
const axios = require("axios");

exports.createOrder = async (req, res) => {
  try {
    const { items } = req.body; // Expects [{ id: 1, quantity: 2 }]

    if (!items || items.length === 0) {
      return res.status(400).json({ message: "Cart is empty" });
    }

    let totalAmount = 0;
    const validatedItems = [];

    // Loop through items and fetch REAL price from EscuelaJS
    for (const item of items) {
      let product;

      try {
        // 1. Fetch from EscuelaJS (Matches your server.js)
        const response = await axios.get(`https://api.escuelajs.co/api/v1/products/${item.id}`);
        product = response.data;
      } catch (err) {
        // If product ID doesn't exist in EscuelaJS
        console.error(`Product ${item.id} not found`);
        return res.status(404).json({ message: `Product ID ${item.id} not found` });
      }

      // 2. Calculate Total
      totalAmount += product.price * item.quantity;
      
      validatedItems.push({
        productId: product.id,
        title: product.title,
        price: product.price,
        quantity: item.quantity,
        image: product.images[0] // EscuelaJS returns an array of images
      });
    }

    const orderId = uuidv4();

    // 3. Frontend URL for Payment Redirect
    const frontendUrl = process.env.FRONTEND_URL || "https://advaitam.monkweb.tech";
    const paymentUrl = `${frontendUrl}/payment-success?orderId=${orderId}`;

    res.json({
      orderId,
      amount: totalAmount,
      paymentUrl,
      items: validatedItems
    });

  } catch (error) {
    console.error("Order Error:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};