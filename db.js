// db.js
const mysql = require('mysql');

const connection = mysql.createConnection({
  host: 'localhost',      
  user: 'root',   
  password: '', 
  database: 'kangkan'  
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

// Close the database connection when the application exits
// process.on('exit', () => {
//   db.end();
//   console.log('Database connection closed.');
// });

module.exports = connection;
