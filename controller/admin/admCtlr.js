const userModel = require('../../model/admin');
const passport = require('passport');
require('../../passport-setup');
require('dotenv/config'); 

 
/*------------------------------------------------------
                  general login
------------------------------------------------------- */

/*------------------------------------------------------
                  !general login
------------------------------------------------------- */
/*------------------------------------------------------
                google authentication
------------------------------------------------------- */
// (1)Initiate Google authentication
 const admGoogleAuth = passport.authenticate('google', { scope: ['profile', 'email'],prompt: 'select_account' })
//or, const admGoogleAuth = (req,res,next)=>{
//   const prompt = req.query.prompt ? req.query.prompt : 'login';
//   passport.authenticate('google', { scope: ['profile', 'email'], prompt })(req, res, next);
// }


const handleGoogleCallback = (req, res)=> {
    res.redirect('/dashboard');
  }

/*------------------------------------------------------
                !google authentication
------------------------------------------------------- */

/*------------------------------------------------------
                    otp login
------------------------------------------------------- */

/*------------------------------------------------------
                    !otp login
------------------------------------------------------- */

//--------------update profile----------------


//-----------------dashboard---------------------


//------------------stock low notification--------------


//----------------logout----------------------
const admLogout= (req, res) => {
  req.logout((err) => {
    if (err) {
      return res.send('Error during logout'); // Handle error during logout
    }

    // Check if there is any data in the session
    if (req.session && req.session.passport && req.session.passport.user) {
      // Session data exists
      console.log('Session data:', req.session.passport.user);
    } else {
      // Session data does not exist
      console.log('Session data is empty');
    }

    req.session.destroy(); // Optionally destroy the entire session
    res.redirect('/login'); // Redirect to the login page after successful logout
  });
};



module.exports = {
    admGoogleAuth,
    handleGoogleCallback,
    admLogout
  };