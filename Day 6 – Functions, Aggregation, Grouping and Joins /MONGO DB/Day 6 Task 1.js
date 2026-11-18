use('RetailSalesDB');

db.salesOrders.drop();

db.salesOrders.insertMany([
{orderId:1,orderDate:ISODate('2026-01-05T00:00:00Z'),customer:{customerId:1,city:'Coimbatore'},items:[{productId:1,productName:'Wireless Mouse',category:'Electronics',quantity:2,unitPrice:800},{productId:4,productName:'Water Bottle',category:'Accessories',quantity:1,unitPrice:350}]},
{orderId:2,orderDate:ISODate('2026-01-18T00:00:00Z'),customer:{customerId:1,city:'Coimbatore'},items:[{productId:2,productName:'Mechanical Keyboard',category:'Electronics',quantity:1,unitPrice:2500}]},
{orderId:3,orderDate:ISODate('2026-02-10T00:00:00Z'),customer:{customerId:1,city:'Coimbatore'},items:[{productId:1,productName:'Wireless Mouse',category:'Electronics',quantity:1,unitPrice:800},{productId:5,productName:'Laptop Stand',category:'Accessories',quantity:1,unitPrice:1200}]},
{orderId:4,orderDate:ISODate('2026-02-22T00:00:00Z'),customer:{customerId:1,city:'Coimbatore'},items:[{productId:3,productName:'Cotton T-Shirt',category:'Clothing',quantity:2,unitPrice:600}]},
{orderId:5,orderDate:ISODate('2026-01-12T00:00:00Z'),customer:{customerId:2,city:'Chennai'},items:[{productId:2,productName:'Mechanical Keyboard',category:'Electronics',quantity:1,unitPrice:2500},{productId:4,productName:'Water Bottle',category:'Accessories',quantity:2,unitPrice:350}]},
{orderId:6,orderDate:ISODate('2026-02-14T00:00:00Z'),customer:{customerId:2,city:'Chennai'},items:[{productId:3,productName:'Cotton T-Shirt',category:'Clothing',quantity:3,unitPrice:600}]},
{orderId:7,orderDate:ISODate('2026-02-05T00:00:00Z'),customer:{customerId:3,city:'Bengaluru'},items:[{productId:5,productName:'Laptop Stand',category:'Accessories',quantity:2,unitPrice:1200}]},
{orderId:8,orderDate:ISODate('2026-03-02T00:00:00Z'),customer:{customerId:4,city:'Coimbatore'},items:[{productId:1,productName:'Wireless Mouse',category:'Electronics',quantity:1,unitPrice:800},{productId:3,productName:'Cotton T-Shirt',category:'Clothing',quantity:1,unitPrice:600}]},
{orderId:9,orderDate:ISODate('2026-03-10T00:00:00Z'),customer:{customerId:5,city:'Chennai'},items:[{productId:4,productName:'Water Bottle',category:'Accessories',quantity:3,unitPrice:350}]},
{orderId:10,orderDate:ISODate('2026-03-15T00:00:00Z'),customer:{customerId:5,city:'Chennai'},items:[{productId:2,productName:'Mechanical Keyboard',category:'Electronics',quantity:1,unitPrice:2500},{productId:5,productName:'Laptop Stand',category:'Accessories',quantity:1,unitPrice:1200}]}
]);

// REPORT 1: Month-wise sales
db.salesOrders.aggregate([
{$unwind:'$items'},
{$group:{_id:{$dateToString:{format:'%Y-%m',date:'$orderDate'}},monthlySales:{$sum:{$multiply:['$items.quantity','$items.unitPrice']}}}},
{$sort:{_id:1}}
]);

// REPORT 2: Top five products by revenue
db.salesOrders.aggregate([
{$unwind:'$items'},
{$group:{_id:{productId:'$items.productId',productName:'$items.productName'},revenue:{$sum:{$multiply:['$items.quantity','$items.unitPrice']}}}},
{$sort:{revenue:-1}},
{$limit:5}
]);

// REPORT 3: Average basket value by city
db.salesOrders.aggregate([
{$unwind:'$items'},
{$group:{_id:{orderId:'$orderId',city:'$customer.city'},basketValue:{$sum:{$multiply:['$items.quantity','$items.unitPrice']}}}},
{$group:{_id:'$_id.city',averageBasketValue:{$avg:'$basketValue'}}},
{$sort:{_id:1}}
]);
