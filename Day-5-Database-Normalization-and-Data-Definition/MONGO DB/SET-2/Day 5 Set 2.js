use('BankBranchDB');

db.createCollection("customerActivity", { capped: true, size: 100000, max: 1000 });

db.customerActivity.insertMany([
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T09:00:00"), ipAddress: "192.168.1.1" },
    { customerId: "C002", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T09:05:00"), ipAddress: "192.168.1.2" },
    { customerId: "C001", activityType: "Transfer", description: "Transferred Rs.5000", timestamp: new Date("2026-11-17T09:10:00"), ipAddress: "192.168.1.1" },
    { customerId: "C003", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T09:15:00"), ipAddress: "192.168.1.3" },
    { customerId: "C001", activityType: "Logout", description: "Customer logged out", timestamp: new Date("2026-11-17T09:20:00"), ipAddress: "192.168.1.1" },
    { customerId: "C002", activityType: "Transfer", description: "Transferred Rs.2000", timestamp: new Date("2026-11-17T09:25:00"), ipAddress: "192.168.1.2" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T10:00:00"), ipAddress: "192.168.1.1" },
    { customerId: "C004", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T10:05:00"), ipAddress: "192.168.1.4" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T10:15:00"), ipAddress: "192.168.1.1" },
    { customerId: "C005", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T10:20:00"), ipAddress: "192.168.1.5" },
    { customerId: "C001", activityType: "Transfer", description: "Transferred Rs.3000", timestamp: new Date("2026-11-17T10:30:00"), ipAddress: "192.168.1.1" },
    { customerId: "C002", activityType: "Logout", description: "Customer logged out", timestamp: new Date("2026-11-17T10:35:00"), ipAddress: "192.168.1.2" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T11:00:00"), ipAddress: "192.168.1.1" },
    { customerId: "C003", activityType: "Logout", description: "Customer logged out", timestamp: new Date("2026-11-17T11:05:00"), ipAddress: "192.168.1.3" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T11:15:00"), ipAddress: "192.168.1.1" },
    { customerId: "C004", activityType: "Transfer", description: "Transferred Rs.1000", timestamp: new Date("2026-11-17T11:20:00"), ipAddress: "192.168.1.4" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T11:30:00"), ipAddress: "192.168.1.1" },
    { customerId: "C005", activityType: "Logout", description: "Customer logged out", timestamp: new Date("2026-11-17T11:35:00"), ipAddress: "192.168.1.5" },
    { customerId: "C001", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T12:00:00"), ipAddress: "192.168.1.1" },
    { customerId: "C002", activityType: "Login", description: "Customer logged in", timestamp: new Date("2026-11-17T12:05:00"), ipAddress: "192.168.1.2" }
]);

db.customerActivity.find();

db.customerActivity.countDocuments();

db.customerActivity.find({ customerId: "C001", activityType: "Login" }).sort({ timestamp: -1 }).limit(5);
