const { v4: uuidv4 } = require("uuid");

exports.createOrder = (req, res) => {
  const { items } = req.body;

  if (!items || items.length === 0) {
    return res.status(400).json({ message: "Cart is empty" });
  }

  const totalAmount = items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  const orderId = uuidv4();

  const paymentUrl = `http://localhost:5173/payment-success?orderId=${orderId}`;

  res.json({
    orderId,
    amount: totalAmount,
    paymentUrl,
  });
};
