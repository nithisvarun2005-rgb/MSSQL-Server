use('TelecomBillingDB');

db.usageEvents.drop();

db.usageEvents.insertMany([
  {eventId:1,subscriberId:1,eventTime:ISODate('2026-11-17T08:05:00Z'),sessionLengthMinutes:12,dataUsedMB:120,cellTower:'TOWER-A'},
  {eventId:2,subscriberId:2,eventTime:ISODate('2026-11-17T08:20:00Z'),sessionLengthMinutes:18,dataUsedMB:250,cellTower:'TOWER-A'},
  {eventId:3,subscriberId:3,eventTime:ISODate('2026-11-17T09:10:00Z'),sessionLengthMinutes:25,dataUsedMB:500,cellTower:'TOWER-B'},
  {eventId:4,subscriberId:4,eventTime:ISODate('2026-11-17T09:35:00Z'),sessionLengthMinutes:10,dataUsedMB:80,cellTower:'TOWER-C'},
  {eventId:5,subscriberId:5,eventTime:ISODate('2026-11-17T10:15:00Z'),sessionLengthMinutes:30,dataUsedMB:700,cellTower:'TOWER-B'},
  {eventId:6,subscriberId:6,eventTime:ISODate('2026-11-17T10:40:00Z'),sessionLengthMinutes:8,dataUsedMB:60,cellTower:'TOWER-A'},
  {eventId:7,subscriberId:7,eventTime:ISODate('2026-11-17T11:05:00Z'),sessionLengthMinutes:22,dataUsedMB:300,cellTower:'TOWER-C'},
  {eventId:8,subscriberId:8,eventTime:ISODate('2026-11-17T11:25:00Z'),sessionLengthMinutes:16,dataUsedMB:180,cellTower:'TOWER-A'},
  {eventId:9,subscriberId:9,eventTime:ISODate('2026-11-17T12:00:00Z'),sessionLengthMinutes:35,dataUsedMB:900,cellTower:'TOWER-B'},
  {eventId:10,subscriberId:10,eventTime:ISODate('2026-11-17T12:45:00Z'),sessionLengthMinutes:14,dataUsedMB:110,cellTower:'TOWER-C'},
  {eventId:11,subscriberId:1,eventTime:ISODate('2026-11-17T13:05:00Z'),sessionLengthMinutes:20,dataUsedMB:220,cellTower:'TOWER-A'},
  {eventId:12,subscriberId:3,eventTime:ISODate('2026-11-17T13:30:00Z'),sessionLengthMinutes:28,dataUsedMB:650,cellTower:'TOWER-B'}
]);

// PIPELINE 1: HOURLY USAGE

db.usageEvents.aggregate([
  {
    $group: {
      _id: {
        $dateToString: {
          format: '%Y-%m-%d %H:00',
          date: '$eventTime'
        }
      },
      totalDataUsedMB: {
        $sum: '$dataUsedMB'
      },
      eventCount: {
        $sum: 1
      }
    }
  },
  {
    $sort: {
      _id: 1
    }
  }
]);

// PIPELINE 2: AVERAGE SESSION LENGTH

db.usageEvents.aggregate([
  {
    $group: {
      _id: null,
      averageSessionMinutes: {
        $avg: '$sessionLengthMinutes'
      },
      totalSessions: {
        $sum: 1
      }
    }
  },
  {
    $project: {
      _id: 0,
      averageSessionMinutes: {
        $round: ['$averageSessionMinutes', 2]
      },
      totalSessions: 1
    }
  }
]);

// PIPELINE 3: BUSIEST CELL TOWER

db.usageEvents.aggregate([
  {
    $group: {
      _id: '$cellTower',
      eventCount: {
        $sum: 1
      },
      totalDataUsedMB: {
        $sum: '$dataUsedMB'
      }
    }
  },
  {
    $sort: {
      eventCount: -1,
      totalDataUsedMB: -1
    }
  },
  {
    $limit: 1
  }
]);
