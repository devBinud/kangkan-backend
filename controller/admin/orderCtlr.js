const orderModel = require('../../model/order');

/*
customer_wishlist: id	product_id	customer_id	created_at	
customer_cart: 	id	customer_id	product_id	quantity	created_at	
customer_order: id	order_code	customer_id	product_id	quantity	customer_address_id	payment_type	discount	coupon_id	created_at	
customer_order_payment: id	customer_id	order_id	payment_status	transaction_id	method	price_amount	created_at	
customer_order_delivery: id	customer_id	order_id	delivery_date	customer_address_id	
customer_order_return: 	id	order_id	payment_id	delivery_id	refund_amount	created_at	return_exchange
	
*/

/*-----------------------------------------------
                order
------------------------------------------------*/

  const getOrderAll = (req, res) => {
    const sql = 'CALL GetUser(?)';
    db.query(sql, (err, result) => {
      if (err) throw err;
      res.json(result[0][0]);
    });
  };

  const getOrderById = (req, res) => {
    const productId = req.params.id;
    const sql = 'CALL GetUser(?)';
    db.query(sql, [productId], (err, result) => {
      if (err) throw err;
      res.json(result[0][0]);
    });
  };
/*-----------------------------------------------
                !order
------------------------------------------------*/


  module.exports = {
    getOrderAll,
    getOrderById ,                                                                                                                                                                                                                   
};