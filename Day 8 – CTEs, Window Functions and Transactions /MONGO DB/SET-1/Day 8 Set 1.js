// Question 5: MongoDB Transaction

// Part C: MongoDB Multi-Document Transaction
const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017/?replicaSet=rs0";

async function transferFunds() {

    const client = new MongoClient(uri);

    await client.connect();

    const db = client.db("BankDB");

    const accounts = db.collection("accounts");

    const transactions = db.collection("transactions");

    const session = client.startSession();

    try {

        await session.withTransaction(async () => {

            const sender = await accounts.findOne(
                { _id: 101 },
                { session }
            );

            const receiver = await accounts.findOne(
                { _id: 102 },
                { session }
            );

            if (!sender || !receiver) {
                throw new Error("Account not found");
            }

            if (sender.status !== "ACTIVE" ||
                receiver.status !== "ACTIVE") {
                throw new Error("Account is not active");
            }

            if (sender.balance < 500) {
                throw new Error("Insufficient balance");
            }

            await accounts.updateOne(
                { _id: 101, status: "ACTIVE", balance: { $gte: 500 } },
                { $inc: { balance: -500 } },
                { session }
            );

            await accounts.updateOne(
                { _id: 102, status: "ACTIVE" },
                { $inc: { balance: 500 } },
                { session }
            );

            await transactions.insertMany([
                {
                    accountId: 101,
                    type: "DEBIT",
                    amount: 500
                },
                {
                    accountId: 102,
                    type: "CREDIT",
                    amount: 500
                }
            ], { session });

        });

        console.log("Transfer successful");

    } catch (error) {

        console.log("Transaction failed:", error.message);

    } finally {

        await session.endSession();

        await client.close();
    }
}

transferFunds();

