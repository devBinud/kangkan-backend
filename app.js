const express = require('express');
const bodyParser =require('body-parser')  // required to parse data coming from post request
const db = require('./db'); // Import the MySQL connection module
const session = require('express-session');
const route = require('./route/route')
const multer = require('multer');

const app = express();

require('dotenv/config'); 

const passport = require('passport');
require('./passport-setup');

// Set up session middleware
app.use(session({
  secret: process.env.GOOGLE_CLIENT_SECRET, 
  resave: true,
  saveUninitialized: true,
  rolling: true,
  cookie: {
    secure: false,
    // maxAge: (5 * 1000)
  },
}));

// app.use(cookieParser());

// Initialize passport
app.use(passport.initialize());
app.use(passport.session());


//-----------middleware- body-parser--------------
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


// Use the module routes by mounting it to a specific path
app.use('/', route);  //mounting route should be after session initialization

const api = process.env.API_URL;



app.set("view engine","ejs") // setting templating engine

// // ----------------isLoggedin middleware------------------
//   function isLoggedin(req,res,next){
//     req.user ? next() : res.sendStatus(401);
//   }
// -----------------ejs-route  google auth----------------

// app.get('/login', (req, res) => {
//     res.render("pages/index")
// }); 

// (1)Initiate Google authentication
//  app.get('/google', passport.authenticate('google', { scope: ['profile', 'email'],prompt: 'select_account' })); //scope fields are predefined by google
// app.get('/google', (req, res, next) => {
//   const prompt = req.query.prompt ? req.query.prompt : 'login';
//   passport.authenticate('google', { scope: ['profile', 'email'], prompt })(req, res, next);
// });


// (2) http://localhost:3000/google/callback is calling here
// app.get('/google/callback', 
//   passport.authenticate('google', { failureRedirect: '/login' }),
//   function(req, res) {
//     // Successful authentication, redirect home.
//     res.redirect('/dashboard');
//   });

// app.get('/dashboard',isLoggedin, (req,res)=>{
//   res.render('pages/dashboard')
// })


// Logout route
// app.get('/logout', (req, res) => {
//   req.logout((err) => {
//     if (err) {
//       return res.send('Error during logout'); // Handle error during logout
//     }

//     // Check if there is any data in the session
//     if (req.session && req.session.passport && req.session.passport.user) {
//       // Session data exists
//       console.log('Session data:', req.session.passport.user);
//     } else {
//       // Session data does not exist
//       console.log('Session data is empty');
//     }

//     req.session.destroy(); // Optionally destroy the entire session
//     res.redirect('/login'); // Redirect to the login page after successful logout
//   });
// });






// -----------------ejs-route  google auth----------------



app.post(`${api}/product`, (req, res)=>{
    const newProduct = req.body;
    console.log(newProduct);
    res.send(newProduct);
})

//-----------------------------API- mysql------------------------------
//get
// app.get(`${api}/get-product`, (req, res) => {
//     db.query('SELECT * FROM master_products', (error, results, fields) => {
//       if (error) throw error;
//       res.json(results);
//     });
//   });

//   // Example POST request to insert data
//  app.post(`${api}/add-product`, (req, res) => {
//     // let name = req.query.name;
//     const { name, description, brand_id, category_id } = req.body;  //send data as body from postman

//     // console.log(req.body);
  
//     // Insert data into the 'products' table
//     const sql = 'INSERT INTO master_products (name, description, brand_id, category_id) VALUES (?,?,?,?)';
//     const values = [name, description, brand_id, category_id];
  
//     db.query(sql, values, (error, results, fields) => {
//       if (error) {
//         console.error('Error inserting data:', error);
//         res.status(500).send('Error inserting data');
//         return;
//       }
  
//       console.log('Data inserted successfully:', results);
//       res.json({ message: 'Data inserted successfully', insertId: results.insertId });
//     });
//   });

//----------------------------- mysql------------------------------


// Create server
app.listen(process.env.PORT || 3000, () => {
  console.log(`server is running at http://localhost:${process.env.PORT}`);
});

