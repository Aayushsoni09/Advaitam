// Lambda: dynamodb-to-opensearch-sync.js

import { Client } from "@opensearch-project/opensearch";

const endpoint = process.env.OPENSEARCH_ENDPOINT;
const indexName = process.env.INDEX_NAME || "products";

// Connect to OpenSearch
const client = new Client({ node: endpoint });

export const handler = async (event) => {
  console.log("STREAM EVENT RECEIVED:");
  console.log(JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    // We only handle INSERT or MODIFY
    if (record.eventName !== "INSERT" && record.eventName !== "MODIFY") {
      console.log(`Skipping ${record.eventName}`);
      continue;
    }

    if (!record.dynamodb.NewImage) {
      console.log("Record missing NewImage, skipping");
      continue;
    }

    const newItem = record.dynamodb.NewImage;

    // Convert DynamoDB Record → Normal JSON
    const doc = {
      productId: newItem.productId.S,
      title: newItem.title.S,
      category: newItem.category.S,
      subCategory: newItem.subCategory.S,
      productType: newItem.productType.S,
      gender: newItem.gender.S,
      colour: newItem.colour.S,
      usage: newItem.usage.S,
      imageUrl: newItem.imageUrl.S
    };

    try {
      console.log("Indexing product:", doc.productId);

      await client.index({
        index: indexName,
        id: doc.productId, // ensure uniqueness
        body: doc
      });

      console.log(`Indexed successfully → ${doc.productId}`);
    } catch (err) {
      console.error(" OpenSearch Write Error:", err);
    }
  }

  return { status: "stream_processed" };
};
