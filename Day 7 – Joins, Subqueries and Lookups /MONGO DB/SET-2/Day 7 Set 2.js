// Question 5 – MongoDB aggregation using

// Combine loan documents with customer information.
db.loans.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "CustomerID",
            foreignField: "CustomerID",
            as: "CustomerDetails"
        }
    },
    {
        $unwind: "$CustomerDetails"
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            LoanAmount: 1,
            CustomerID: 1,
            CustomerName: "$CustomerDetails.CustomerName",
            City: "$CustomerDetails.City"
        }
    }
]);

// Combine loan documents with repayment information.
db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            localField: "LoanID",
            foreignField: "LoanID",
            as: "RepaymentDetails"
        }
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            CustomerID: 1,
            LoanAmount: 1,
            RepaymentDetails: 1
        }
    }
]);

// Find the last repayment for each loan.
db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            let: {
                loanId: "$LoanID"
            },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $eq: ["$LoanID", "$$loanId"]
                        }
                    }
                },
                {
                    $sort: {
                        RepaymentDate: -1
                    }
                },
                {
                    $limit: 1
                }
            ],
            as: "LastRepayment"
        }
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            CustomerID: 1,
            LoanAmount: 1,
            LastRepayment: 1
        }
    }
]);


