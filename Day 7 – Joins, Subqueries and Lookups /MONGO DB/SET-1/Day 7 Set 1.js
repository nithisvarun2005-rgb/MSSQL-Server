// 5.Three MongoDB pipelines using $lookup 

// Shipments with delivery events using $lookup
db.shipments.aggregate([
    {
        $lookup: {
            from: "delivery_events",
            localField: "ShipmentID",
            foreignField: "ShipmentID",
            as: "DeliveryDetails"
        }
    },
    {
        $project: {
            ShipmentID: 1,
            CustomerID: 1,
            ShipDate: 1,
            DeliveryDetails: 1
        }
    }
]);

// Customers with their shipments using $lookup
db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "CustomerID",
            foreignField: "CustomerID",
            as: "ShipmentDetails"
        }
    },
    {
        $project: {
            CustomerID: 1,
            CustomerName: 1,
            ShipmentDetails: 1
        }
    }
]);

// Carriers with delay statistics using $lookup
db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "CarrierID",
            foreignField: "CarrierID",
            as: "ShipmentDetails"
        }
    },
    {
        $unwind: "$ShipmentDetails"
    },
    {
        $match: {
            "ShipmentDetails.ActualDeliveryDate": {
                $ne: null
            },
            "ShipmentDetails.ExpectedDeliveryDate": {
                $ne: null
            }
        }
    },
    {
        $group: {
            _id: "$CarrierID",
            CarrierName: {
                $first: "$CarrierName"
            },
            AverageDelayDays: {
                $avg: {
                    $divide: [
                        {
                            $subtract: [
                                "$ShipmentDetails.ActualDeliveryDate",
                                "$ShipmentDetails.ExpectedDeliveryDate"
                            ]
                        },
                        86400000
                    ]
                }
            },
            TotalShipments: {
                $sum: 1
            }
        }
    },
    {
        $sort: {
            AverageDelayDays: -1
        }
    }
]);

//Explanation:
// Embedding delivery events inside a shipment is useful when each shipment has a small, bounded number of events and they are usually accessed together.
// $lookup is useful when delivery events are stored independently and need to be queried alongside shipments.



