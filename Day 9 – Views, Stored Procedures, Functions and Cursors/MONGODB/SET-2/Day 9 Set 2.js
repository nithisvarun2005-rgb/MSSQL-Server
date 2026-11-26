use RetailMongoDB

db.customer_communications.insertMany([
    {
        communicationId: 1,
        customerName: "Arun",
        message: "My claim is still pending",
        type: "Complaint",
        status: "Unresolved"
    },
    {
        communicationId: 2,
        customerName: "Priya",
        message: "Policy renewal completed",
        type: "Enquiry",
        status: "Resolved"
    },
    {
        communicationId: 3,
        customerName: "Kavin",
        message: "Premium amount is incorrect",
        type: "Complaint",
        status: "Unresolved"
    },
    {
        communicationId: 4,
        customerName: "Meena",
        message: "Thank you for the support",
        type: "Feedback",
        status: "Resolved"
    }
])



db.createView(
    "unresolved_complaints",
    "customer_communications",
    [
        {
            $match: {
                type: "Complaint",
                status: "Unresolved"
            }
        }
    ]
)
