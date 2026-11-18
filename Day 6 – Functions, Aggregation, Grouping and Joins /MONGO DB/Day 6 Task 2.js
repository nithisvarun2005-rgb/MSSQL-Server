use('InsurancePolicyDB');

db.claimsNotes.drop();

db.claimsNotes.insertMany([
  {claimId:201, policyNumber:'HLT-10001', status:'Settled', claimDate:ISODate('2026-02-10'), settlementDate:ISODate('2026-02-20'), claimAmount:3000, damageCategory:'Medical', notes:'Hospital expense reimbursement processed.'},
  {claimId:202, policyNumber:'MTR-10002', status:'Settled', claimDate:ISODate('2026-05-12'), settlementDate:ISODate('2026-05-22'), claimAmount:2500, damageCategory:'Collision', notes:'Vehicle collision repair claim settled.'},
  {claimId:203, policyNumber:'HOM-10003', status:'Approved', claimDate:ISODate('2026-10-02'), settlementDate:null, claimAmount:5000, damageCategory:'Fire', notes:'Property fire damage approved, awaiting payment.'},
  {claimId:204, policyNumber:'LIF-10004', status:'Settled', claimDate:ISODate('2026-03-15'), settlementDate:ISODate('2026-04-04'), claimAmount:7000, damageCategory:'Medical', notes:'Medical claim settled after document review.'},
  {claimId:205, policyNumber:'HLT-10005', status:'Rejected', claimDate:ISODate('2026-08-20'), settlementDate:null, claimAmount:2000, damageCategory:'Medical', notes:'Claim rejected due to policy exclusion.'},
  {claimId:206, policyNumber:'MTR-10006', status:'Under Review', claimDate:ISODate('2026-11-05'), settlementDate:null, claimAmount:3500, damageCategory:'Collision', notes:'Surveyor report is pending.'},
  {claimId:207, policyNumber:'HOM-10007', status:'Settled', claimDate:ISODate('2026-06-18'), settlementDate:ISODate('2026-07-03'), claimAmount:6000, damageCategory:'Water Damage', notes:'Water leakage repair expenses settled.'},
  {claimId:208, policyNumber:'LIF-10009', status:'Approved', claimDate:ISODate('2026-09-10'), settlementDate:null, claimAmount:4000, damageCategory:'Medical', notes:'Approved medical claim awaiting settlement.'},
  {claimId:209, policyNumber:'MTR-10010', status:'Settled', claimDate:ISODate('2026-10-25'), settlementDate:ISODate('2026-11-04'), claimAmount:1500, damageCategory:'Collision', notes:'Minor vehicle collision claim settled.'},
  {claimId:210, policyNumber:'HOM-10011', status:'Under Review', claimDate:ISODate('2026-11-01'), settlementDate:null, claimAmount:8000, damageCategory:'Fire', notes:'Fire damage assessment is in progress.'}
]);

// PIPELINE 1: Claims per status

db.claimsNotes.aggregate([
  {
    $group: {
      _id: '$status',
      claimCount: { $sum: 1 },
      totalClaimAmount: { $sum: '$claimAmount' }
    }
  },
  {
    $sort: { claimCount: -1, _id: 1 }
  }
]);

// PIPELINE 2: Average settlement time in days

db.claimsNotes.aggregate([
  {
    $match: {
      settlementDate: { $ne: null }
    }
  },
  {
    $project: {
      settlementDays: {
        $dateDiff: {
          startDate: '$claimDate',
          endDate: '$settlementDate',
          unit: 'day'
        }
      }
    }
  },
  {
    $group: {
      _id: null,
      averageSettlementDays: { $avg: '$settlementDays' },
      settledClaimCount: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      averageSettlementDays: {
        $round: ['$averageSettlementDays', 2]
      },
      settledClaimCount: 1
    }
  }
]);

// PIPELINE 3: Top three damage categories

db.claimsNotes.aggregate([
  {
    $group: {
      _id: '$damageCategory',
      claimCount: { $sum: 1 },
      totalClaimAmount: { $sum: '$claimAmount' }
    }
  },
  {
    $sort: {
      claimCount: -1,
      totalClaimAmount: -1
    }
  },
  {
    $limit: 3
  }
]);
