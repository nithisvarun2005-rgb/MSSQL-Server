const database = db.getSiblingDB("tasks");

const changeStream = database.fraud_alerts.watch([
    {
        $match: {
            operationType: "insert"
        }
    }
]);

print("Watching for new fraud alerts...");

while (changeStream.hasNext()) {
    const change = changeStream.next();

    print("New Fraud Alert Detected!");
    printjson(change.fullDocument);
}
