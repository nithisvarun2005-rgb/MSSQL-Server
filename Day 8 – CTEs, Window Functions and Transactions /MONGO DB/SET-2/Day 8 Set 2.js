// Question 5: MongoDB Multi-Document Transaction

// seats
{
    "_id": 1,
    "flightId": 201,
    "seatNumber": "2A",
    "status": "AVAILABLE"
}

// bookings
{
    "_id": 1001,
    "flightId": 201,
    "seatId": 1,
    "passengerId": 1,
    "fare": 5500,
    "bookingDate": "2026-11-19"
}


const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017/?replicaSet=rs0";

async function bookSeat() {

    const client = new MongoClient(uri);

    await client.connect();

    const db = client.db("AirlineDB");

    const seats = db.collection("seats");

    const bookings = db.collection("bookings");

    const session = client.startSession();

    try {

        await session.withTransaction(async () => {

            const seat = await seats.findOne(
                {
                    flightId: 201,
                    seatNumber: "2A",
                    status: "AVAILABLE"
                },
                { session }
            );

            if (!seat) {
                throw new Error("Seat is not available");
            }

            // Update seat status
            const result = await seats.updateOne(
                {
                    _id: seat._id,
                    status: "AVAILABLE"
                },
                {
                    $set: { status: "BOOKED" }
                },
                { session }
            );

            if (result.modifiedCount !== 1) {
                throw new Error("Seat booking failed");
            }

            // Insert booking document
            await bookings.insertOne(
                {
                    flightId: 201,
                    seatId: seat._id,
                    passengerId: 1,
                    fare: 5500,
                    bookingDate: new Date()
                },
                { session }
            );

        });

        console.log("Seat booked successfully");

    } catch (error) {

        console.log("Booking failed:", error.message);

    } finally {

        await session.endSession();

        await client.close();
    }
}

bookSeat();
