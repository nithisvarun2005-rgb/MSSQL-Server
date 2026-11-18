// Question 5 – MongoDB aggregation pipelines using $lookup

// 1. Display returns with their customer feedback
db.returns.aggregate([
    {
        $lookup: {
            from: "return_feedback",
            localField: "ReturnID",
            foreignField: "ReturnID",
            as: "Feedback"
        }
    },
    {
        $unwind: {
            path: "$Feedback",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $project: {
            _id: 0,
            ReturnID: 1,
            ReturnDate: 1,
            ReturnReason: 1,
            ReturnStatus: 1,
            Rating: "$Feedback.Rating",
            Comments: "$Feedback.Comments"
        }
    }
]);

// 2. Display return details with customer and feedback information
db.returns.aggregate([
    {
        $lookup: {
            from: "sales",
            localField: "SaleID",
            foreignField: "SaleID",
            as: "SaleDetails"
        }
    },
    {
        $unwind: "$SaleDetails"
    },
    {
        $lookup: {
            from: "customers",
            localField: "SaleDetails.CustomerID",
            foreignField: "CustomerID",
            as: "CustomerDetails"
        }
    },
    {
        $unwind: "$CustomerDetails"
    },
    {
        $lookup: {
            from: "return_feedback",
            localField: "ReturnID",
            foreignField: "ReturnID",
            as: "Feedback"
        }
    },
    {
        $project: {
            _id: 0,
            ReturnID: 1,
            ReturnDate: 1,
            ReturnReason: 1,
            CustomerName: "$CustomerDetails.CustomerName",
            Feedback: 1
        }
    }
]);

// 3. Find returns with no feedback
db.returns.aggregate([
    {
        $lookup: {
            from: "return_feedback",
            localField: "ReturnID",
            foreignField: "ReturnID",
            as: "Feedback"
        }
    },
    {
        $match: {
            Feedback: { $eq: [] }
        }
    },
    {
        $project: {
            _id: 0,
            ReturnID: 1,
            ReturnDate: 1,
            ReturnReason: 1,
            ReturnStatus: 1
        }
    }
]);



