const express = require("express");
const router = express.Router();
const client = require("../db");
const { ScanCommand } = require("@aws-sdk/client-dynamodb");

router.get("/", async (req, res) => {
  try {
    const data = await client.send(
      new ScanCommand({ TableName: "Products" })
    );

    console.log("get products called...")

    const items = data.Items.map(i => ({
      productId: i.productId.S,
      title: i.title.S,
      category: i.category.S,
      imageUrl: i.imageUrl.S
    }));

    res.json(items);
  } catch (err) {
    console.error("Dynamo Error:", err);
    res.status(500).json({ error: "DB_ERROR" });
  }
});

module.exports = router;