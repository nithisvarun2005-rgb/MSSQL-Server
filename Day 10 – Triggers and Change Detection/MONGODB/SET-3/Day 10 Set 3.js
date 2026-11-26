const database = db.getSiblingDB("tasks");

const changeStream = database.ward_alerts.watch([
    {
        $match: {
            operationType: "insert",
            "fullDocument.severity": "critical"
        }
    }
]);

print("Watching for critical ward alerts...");

while (changeStream.hasNext()) {
    const change = changeStream.next();
    const alert = change.fullDocument;

    print("CRITICAL WARD ALERT!");
    print("Ward: " + alert.ward);
    print("Alert Time: " + alert.alertTime);
    print("Message: " + alert.message);
    print("-----------------------------");
}
