use RetailMongoDB

db.orders.insertMany([
    { orderId: 101, customerName: "Arun", status: "Pending" },
    { orderId: 102, customerName: "Priya", status: "Shipped" },
    { orderId: 103, customerName: "Kavin", status: "Pending" },
    { orderId: 104, customerName: "Meena", status: "Delivered" },
    { orderId: 105, customerName: "Divya", status: "Shipped" },
    { orderId: 106, customerName: "Rahul", status: "Pending" }
])


db.createView(
    "order_status_counts",
    "orders",
    [
        {
            $group: {
                _id: "$status",
                totalOrders: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                status: "$_id",
                totalOrders: 1
            }
        }
    ]
)
