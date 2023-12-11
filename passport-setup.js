// const user = require('./model/admin');
const db = require("./db");
const passport = require('passport');
require('dotenv/config'); 
const GoogleStrategy = require('passport-google-oauth20').Strategy; //there are many authentication strategy. here we are using google auth



// Set up Google authentication strategy
passport.use(new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: process.env.Google_Callback_URL, 
  prompt: 'consent',
  // scope: [ 'profile' ]
  // passReqToCallback: true
},
function verify(accessToken, refreshToken, profile, cb) {
  console.log('Google User Profile:', profile); // Log the user profile information to the console
  db.query('SELECT * FROM admin WHERE email = ?', [
    'manashbarman55@gmail.com'
  ], function(err, cred) {
    console.log('Database Query Result:', cred);
    if (err) { 
      console.log(`the error 1: ${err}`)
      return cb(err); 
    }
    
    if (cred.length===0) {
      // The account at Google has not logged in to this app before.  Create a
      // new user record and associate it with the Google account.
      db.query('INSERT INTO admin (name,email,phone,password,created_at,created_by,admin_type,token) VALUES (?,?,?,?,?,?,?,?)', [
        'Manas Barman','profile@gmail.com','9435487128','pass@123','2023-11-24 09:39:19',1,'super','5a2038a5c5cc18eb8abb5abfbc4c95d8'
      ], function(err) {
        if (err) { 
          // console.log(`the error 1: ${err}`)
          return cb(err); 
        }
        // console.log("testing11")
        var user = {
          id: 20,
          name: 'profile.displayName'
        };
        return cb(null, user);
        
      //   var id = this.lastID;
      //   db.query('INSERT INTO federated_credentials (user_id, provider, subject) VALUES (?, ?, ?)', [
      //     id,
      //     'https://accounts.google.com',
      //     profile.id
      //   ], function(err) {
      //     if (err) { return cb(err); }
          
      //     var user = {
      //       id: id,
      //       name: profile.displayName
      //     };
      //     return cb(null, user);
      //   });
      });
    } else {
      console.log("testing12")
        var user = {
          id: 21,
          name: 'user present already'
        };
        return cb(null, user);
      // The account at Google has previously logged in to the app.  Get the
      // user record associated with the Google account and log the user in.
      // db.get('SELECT * FROM users WHERE id = ?', [ cred.user_id ], function(err, user) {
      //   if (err) { return cb(err); }
      //   if (!user) { return cb(null, false); }
      //   return cb(null, user);
      // });
    }
  });
}
));

// ----------------------------------------------------
// passport.use(new GoogleStrategy({ 
//     clientID: process.env.GOOGLE_CLIENT_ID,
//     clientSecret: process.env.GOOGLE_CLIENT_SECRET,
//     callbackURL: process.env.Google_Callback_URL,
//     prompt: 'consent',
//     // scope: [ 'profile' ]
//     // passReqToCallback: true
//   },
//   (accessToken, refreshToken, profile, done) => {
//     console.log('Google User Profile:', profile); // Log the user profile information to the console
//     // Store user profile information in the session
//     return done(null, { id: profile.id, displayName: profile.displayName });
//   }));

  // --------------------------------------------------


// Serialize user into the session
passport.serializeUser(function(profile,done){
  console.log("test 13")
    done(null,profile);
})

// Deserialize user from the session
passport.deserializeUser(function(profile,done){
  console.log("test 14")
    done(null,profile);
})