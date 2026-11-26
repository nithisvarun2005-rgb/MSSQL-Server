db.notification_logs.insertMany([
    {
        notificationId: 1,
        subscriberId: 101,
        message: "Your balance is low",
        isRead: false
    },
    {
        notificationId: 2,
        subscriberId: 101,
        message: "Recharge successful",
        isRead: true
    },
    {
        notificationId: 3,
        subscriberId: 101,
        message: "Your validity is expiring",
        isRead: false
    },
    {
        notificationId: 4,
        subscriberId: 102,
        message: "Your balance is low",
        isRead: false
    },
    {
        notificationId: 5,
        subscriberId: 102,
        message: "Recharge reminder",
        isRead: false
    },
    {
        notificationId: 6,
        subscriberId: 104,
        message: "Recharge successful",
        isRead: true
    }
]);



db.createView(
    "unread_notification_count",
    "notification_logs",
    [
        {
            $match: {
                isRead: false
            }
        },
        {
            $group: {
                _id: "$subscriberId",
                unreadCount: {
                    $sum: 1
                }
            }
        }
    ]
);

db.unread_notification_count.find();
