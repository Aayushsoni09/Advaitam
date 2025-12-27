const express = require("express");
const router = express.Router();
const { Client } = require("@opensearch-project/opensearch");

const client = new Client({ node: process.env.OPENSEARCH_ENDPOINT });
const INDEX = process.env.INDEX_NAME || "products-index";

router.get("/", async (req, res) => {
  const q = req.query.q;

  if (!q) return res.status(400).json({ error: "Missing ?q= keyword" });

  try {
    const response = await client.search({
      index: INDEX,
      body: {
        query: {
          multi_match: {
            query: q,
            fields: ["title^4", "category^2", "subCategory", "gender"]
          }
        }
      }
    });

    const results = response.hits.hits.map(h => h._source);
    res.json(results);

  } catch (err) {
    console.error("Search error:", err);
    res.status(500).json({ error: "SEARCH_ERROR" });
  }
});

module.exports = router;
