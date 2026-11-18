use('RetailReviewsDB');


db.createCollection("reviews", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: [
                "sku",
                "customerId",
                "rating",
                "reviewText",
                "createdAt"
            ],
            properties: {
                sku: {
                    bsonType: "string"
                },
                customerId: {
                    bsonType: "string"
                },
                rating: {
                    bsonType: "int",
                    minimum: 1,
                    maximum: 5
                },
                reviewText: {
                    bsonType: "string"
                },
                createdAt: {
                    bsonType: "date"
                },
                helpfulVotes: {
                    bsonType: "int",
                    minimum: 0
                },
                tags: {
                    bsonType: "array",
                    items: {
                        bsonType: "string"
                    }
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});

db.reviews.insertMany([
    {
        sku: "SKU001",
        customerId: "C001",
        rating: NumberInt(5),
        reviewText: "Works smoothly and is comfortable to use.",
        createdAt: new Date("2026-01-05"),
        helpfulVotes: NumberInt(8),
        tags: ["quality", "value"]
    },
    {
        sku: "SKU001",
        customerId: "C002",
        rating: NumberInt(4),
        reviewText: "Good mouse, battery life is decent.",
        createdAt: new Date("2026-01-08"),
        helpfulVotes: NumberInt(3),
        tags: ["battery"]
    },
    {
        sku: "SKU002",
        customerId: "C003",
        rating: NumberInt(5),
        reviewText: "Boils water quickly.",
        createdAt: new Date("2026-01-10"),
        helpfulVotes: NumberInt(5),
        tags: ["performance"]
    },
    {
        sku: "SKU003",
        customerId: "C004",
        rating: NumberInt(3),
        reviewText: "Fabric is comfortable but size runs small.",
        createdAt: new Date("2026-01-12"),
        helpfulVotes: NumberInt(1),
        tags: ["size", "fabric"]
    },
    {
        sku: "SKU004",
        customerId: "C005",
        rating: NumberInt(4),
        reviewText: "Clear explanations and useful examples.",
        createdAt: new Date("2026-01-14"),
        helpfulVotes: NumberInt(6),
        tags: ["content"]
    },
    {
        sku: "SKU005",
        customerId: "C006",
        rating: NumberInt(5),
        reviewText: "Good grip and thickness for yoga.",
        createdAt: new Date("2026-01-16"),
        helpfulVotes: NumberInt(4),
        tags: ["fitness"]
    },
    {
        sku: "SKU006",
        customerId: "C007",
        rating: NumberInt(4),
        reviewText: "Fun set with many pieces.",
        createdAt: new Date("2026-01-18"),
        helpfulVotes: NumberInt(2),
        tags: ["children"]
    },
    {
        sku: "SKU007",
        customerId: "C008",
        rating: NumberInt(2),
        reviewText: "Assembly was difficult and chair feels stiff.",
        createdAt: new Date("2026-01-20"),
        helpfulVotes: NumberInt(0),
        tags: ["assembly"]
    },
    {
        sku: "SKU008",
        customerId: "C009",
        rating: NumberInt(5),
        reviewText: "Light texture and absorbs well.",
        createdAt: new Date("2026-01-22"),
        helpfulVotes: NumberInt(7),
        tags: ["texture"]
    },
    {
        sku: "SKU009",
        customerId: "C010",
        rating: NumberInt(4),
        reviewText: "Fresh and easy to prepare for breakfast.",
        createdAt: new Date("2026-01-24"),
        helpfulVotes: NumberInt(2),
        tags: ["food"]
    }
]);


db.reviews.find({
    sku: "SKU001"
});


db.reviews.updateOne(
    {
        sku: "SKU001",
        customerId: "C002"
    },
    {
        $set: {
            rating: NumberInt(5),
            reviewText: "Updated: excellent mouse and reliable battery."
        },
        $inc: {
            helpfulVotes: NumberInt(1)
        }
    }
);

db.reviews.deleteOne({
    sku: "SKU007",
    customerId: "C008"
});


db.createCollection("searchActivity");

db.searchActivity.insertMany([
    {
        customerId: "C001",
        query: "wireless mouse",
        filters: {
            category: "Electronics"
        },
        searchedAt: new Date()
    },
    {
        customerId: "C002",
        query: "cotton t shirt",
        filters: {
            category: "Clothing",
            size: "M"
        },
        searchedAt: new Date()
    }
]);
