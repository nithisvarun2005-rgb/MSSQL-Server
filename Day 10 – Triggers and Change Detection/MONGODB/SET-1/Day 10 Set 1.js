const database = db.getSiblingDB("RetailInventoryDB");

const changeStream = database.products.watch(
    [
        {
            $match: {
                operationType: "update",
                "updateDescription.updatedFields.unitPrice": {
                    $exists: true
                }
            }
        }
    ],
    {
        fullDocument: "updateLookup"
    }
);

print("Watching for product price changes...");

while (changeStream.hasNext()) {
    const change = changeStream.next();

    print("Product price changed!");
    print("Product ID: " + change.fullDocument.productId);
    print("Product Name: " + change.fullDocument.productName);
    print("New Price: " + change.updateDescription.updatedFields.unitPrice);
    print("Changed At: " + change.wallTime);
    print("-----------------------------");
}
