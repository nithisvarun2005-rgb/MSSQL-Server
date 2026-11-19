// Question 5: MongoDB transactions versus single-document atomic updates

// MongoDB single-document stock update
{
    _id: 101,
    productName: "Laptop",
    stockQuantity: 50,
    unitPrice: 55000
}

const { MongoClient } = require("mongodb");

async function updateStock() {
    const client = new MongoClient("mongodb://localhost:27017");

    try {
        await client.connect();

        const db = client.db("RetailDB");
        const products = db.collection("products");

        const productId = 101;
        const quantity = 2;

        const result = await products.updateOne(
            {
                _id: productId,
                stockQuantity: { $gte: quantity }
            },
            {
                $inc: { stockQuantity: -quantity }
            }
        );

        if (result.modifiedCount === 1) {
            console.log("Stock updated successfully.");
        } else {
            console.log("Product not found or insufficient stock.");
        }
    }
    catch (error) {
        console.error("Error:", error.message);
    }
    finally {
        await client.close();
    }
}

updateStock();
