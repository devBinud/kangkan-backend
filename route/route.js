const express = require('express');
const router = express.Router();
const admCtlr = require('../controller/admin/admCtlr')
const userCtlr = require('../controller/user/userCtlr')
const passport = require('passport');
const { getProductCategoryAll,addProductCategoryPage, addProductCategory, addProduct, getProductAll } = require('../controller/admin/productCtlr');
require('../passport-setup');

// ----------------isLoggedin middleware------------------
function isLoggedin(req,res,next){
  req.user ? next() : res.render("pages/index");
}

/*----------------------------admin route--------------------------------*/
//product-category
router.get('/api/categories/get',getProductCategoryAll)
router.get('/api/categories/add', addProductCategoryPage);
router.post('/api/categories/add', addProductCategory);

//product
router.post('/api/product/add', addProduct);
router.get('/product/get',getProductAll);


// ---------------------------------------------
router.get('/admin/login', (req, res) => {
  res.render("pages/index")
}); 
// router.post('/admin/login', admCtlr.admLogin); 


//  router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'],prompt: 'select_account' })); //scope fields are predefined by google
router.get('/google',admCtlr.admGoogleAuth);
router.get('/google/callback',passport.authenticate('google', { failureRedirect: '/login' }),
admCtlr.handleGoogleCallback); //here, first run the middleware function and after that the callback will run


router.get('/dashboard',isLoggedin,(req,res)=>{
res.render('pages/dashboard') 
})

router.get('/logout', admCtlr.admLogout)

// router.get('/view-user/:id', userCtlr.getUser); //when sending parameter like: http://localhost:3000/view-user/1
router.get('/view-user', userCtlr.getUser);
router.get('/add-user',userCtlr.addUser);
// router.get('/edit-user',userCtlr.editUser

/*----------------------------admin route--------------------------------*/

/*----------------------------user route--------------------------------*/
router.get('/login', (req, res) => {
    res.render("pages/index")
}); 


//  router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'],prompt: 'select_account' })); //scope fields are predefined by google
router.get('/google',admCtlr.admGoogleAuth);
router.get('/google/callback',passport.authenticate('google', { failureRedirect: '/login' }),
  admCtlr.handleGoogleCallback); //here, first run the middleware function and after that the callback will run
  

router.get('/dashboard',isLoggedin,(req,res)=>{
  res.render('pages/dashboard') 
})

router.get('/logout', admCtlr.admLogout)

// router.get('/view-user/:id', userCtlr.getUser); //when sending parameter like: http://localhost:3000/view-user/1
router.get('/view-user', userCtlr.getUser);
router.get('/add-user',userCtlr.addUser);
// router.get('/edit-user',userCtlr.editUser)

/*----------------------------user route--------------------------------*/



// Export the router to make it accessible from other files
module.exports = router;