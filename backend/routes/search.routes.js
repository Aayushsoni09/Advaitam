import { Router } from "express";
import { Client } from "@opensearch-project/opensearch";
import { defaultProvider } from "@aws-sdk/credential-provider-node";
import createAwsConnection from "@opensearch-project/opensearch/aws";

const router = Router();

const awsConfig = {
  region: process.env.AWS_REGION,
  credentials: defaultProvider(), // <-- this pulls from EC2 IAM metadata
};

const { Connection, Transport } = createAwsConnection(awsConfig);

const client = new Client({
  ...Connection,
  ...Transport,
  node: process.env.OPENSEARCH_ENDPOINT, // VPC endpoint
});

router.get("/api/search", async (req, res) => {
  const q = req.query.q;
  if (!q) return res.status(400).json({ error: "Missing query" });

  try {
    const result = await client.search({
      index: process.env.INDEX_NAME || "products",
      body: {
        query: {
          multi_match: {
            query: q,
            fields: ["title", "category", "subCategory", "gender"]
          }
        }
      }
    });

    res.json(result.hits.hits.map(hit => hit._source));
  } catch (err) {
    console.error("SEARCH ERROR:", err);
    res.status(500).json({ error: "SEARCH_ERROR", detail: err.message });
  }
});

export default router;
