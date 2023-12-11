
const userModel = require('../../model/user');



  //http://localhost:3000/add-user?name=arun&contact=9874686557&email=abc@gmail.com&password=qwertyuiop
  const addUser = (req,res) => {
    let {	name,contact,email,password } = req.query;
    // const { name, description, brand_id, category_id } = req.body;  
    console.log(name,contact,email,password);

    const values = [name,contact,email,password];

    userModel.insertUser(values, (err, results) => {
      if (err) {
        console.error('Error inserting data:', err);
        res.status(500).json({ error: 'Error inserting data' });
      } else {
        console.log('Data inserted successfully:', results);
        res.json({ message: 'Data inserted successfully', insertId: results.insertId });
      }
    }); 
  
  };
 

  const login = (req,res)=>{
    // let { user}
  }


  
  const getUser = (req,res) => {
    // const userId = req.params.id;  //when sending parameter like: http://localhost:3000/view-user/1
    const userId = req.query.id;

    if (!userId) {
      return res.status(400).json({ error: 'Missing user ID in query parameters' });
    }

    //'callback' parameter from the model function is defined here. means the whole 'callback function defination' is sending as an argument
    userModel.getUserById(userId, (err, userData) => {
      if (err) {
        // Handle the error, send an error response, etc.
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        console.log('User data:', userData);
        // res.send(userData);
        res.json({ user: userData });
      }
    });
  };

  const getUserAll = (req,res) => {
    // Function 2 logic
  };
  
  const editUser = (req,res) => {
    const userId = req.query.id;
  };
  
  // Exporting multiple functions
  module.exports = {
    addUser,
    getUser,
    // getUserAll,
    editUser
  };