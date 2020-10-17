import 'package:firebase_core/firebase_core.dart';
import 'package:kaladasava/models/loggedinuser.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart' as fauth;
import 'package:google_sign_in/google_sign_in.dart' as gauth;
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final gauth.GoogleSignIn _googleSignIn = gauth.GoogleSignIn();//gauth.GoogleSignIn(scopes: ['email']);//UAb
  final _facebookLogin = fauth.FacebookLogin();

  // create user obj based on firebase user
   LoggedinUser _userFromFirebaseUser(auth.User user) {
     String _provider = user != null?user.providerData[0].providerId != null?user.providerData[0].providerId:'':'';
    return user != null ? LoggedinUser(uid: user.uid, email:user.email, displayname: user.displayName, photourl: user.photoURL,provider:_provider) : null;
  } 

  // auth change user stream
  Stream<LoggedinUser> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      auth.UserCredential result = await _auth.signInAnonymously();
      auth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<LoggedinUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      //return user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    } 
  }

  // sign in with Google
  Future<LoggedinUser> signInWithGoogle() async {
  try {
    await Firebase.initializeApp();

    final gauth.GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final gauth.GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
    final auth.User user = authResult.user;
    //return user;
    return _userFromFirebaseUser(user);
  }
  catch(e) {      
    print(e.toString());
    return null;
    }
  }

  // sign in with FB
  Future<LoggedinUser>signInWithFB() async {
  try {
    await Firebase.initializeApp();
    final result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case fauth.FacebookLoginStatus.loggedIn:
        final auth.AuthCredential credential = auth.FacebookAuthProvider.credential(result.accessToken.token);
        final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
        final auth.User user = authResult.user;
        //return user;
        return _userFromFirebaseUser(user);
      break;
      case fauth.FacebookLoginStatus.cancelledByUser:
        print('FacebookLoginStatus.cancelledByUser');
        return null;
        break;
      case fauth.FacebookLoginStatus.error:
        print('FacebookLoginStatus.error');
        return null;        
        break;
      default:return null;        
        break;
    }
  }
  catch(e) {      
    print(e.toString());
    return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      // create a new document for the user with the uid
      //UAb await DatabaseService(uid: user.uid).updateUserData('0','new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      if(_googleSignIn !=null) await _googleSignIn.signOut();//UAb
      if(_facebookLogin !=null) await _facebookLogin.logOut();//UAb
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}