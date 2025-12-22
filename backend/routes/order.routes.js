const express = require("express");
const { createOrder } = require("../controllers/order.controller");

const router = express.Router();

router.post("/create", createOrder);
router.get("/api/health", (req, res) => {
  res.status(200).send("OK") 
}
);


module.exports = router;
