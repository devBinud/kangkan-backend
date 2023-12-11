const db = require("../db");



  const insertUser = (values,callback) => {
    // Insert data into the 'products' table
    const sql = 'INSERT INTO customer_details (name,contact,email,password) VALUES (?,?,?,?)';
  
    db.query(sql, values, (err, results, fields) => {
      if (err) {
        console.error('Error inserting data:', err);
        callback(err, null);
      } else {
        console.log('Data inserted successfully:', results);
        callback(null, { insertId: results.insertId });
      }
    });
  };
  
  
  const getUserById = function (userId, callback) {
    const query = 'SELECT * FROM customer_details WHERE id = ?';
    db.query(query, [userId], (err, results) => {
      if (err) {
        console.error('Error fetching data from database:', err);
        callback(err, null);
      } else {
        callback(null,results);
      }
    });
  };
  
  
  const getAllUsers = function (callback) {
    const query = 'SELECT * FROM master_products';
    db.query(query, (err, results) => {
      if (err) {
        callback(err, null);
      } else {
        callback(null, results);
      }
    });
  };


  
  // Exporting multiple functions
  module.exports = {
    insertUser,
    getUserById,
    getAllUsers,
    // updateUser
  };

  