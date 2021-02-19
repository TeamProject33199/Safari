
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/models/users.dart';


class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  String errorMessage;
  String message;
  UserCredential fbUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = FacebookLogin();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        _user = user;
      }
      notifyListeners();
    });
  }

  User get user => _user;

  // ignore: missing_return
  Future<UserCredential> login(String username, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorMessage = "Your email is invalid";
        print('Invalid email');
      }
      if (e.code == 'user-not-found') {
        errorMessage = "User not found";
        print('Hi, User not found');
      } else if (e.code == 'wrong-password') {
        errorMessage = "Your password is not correct";
      }
      notifyListeners();
    } catch (e) {
      print(e.code);
    }
  }

  // ignore: missing_return
  Future<UserCredential> signUp(String username, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorMessage = "Your email is invalid";
        print('Invalid email');
      }
    } catch (e) {
      print(e.code);
    }
  }

  // ignore: missing_return
  Future<UserCredential> signInWithGoogle() async {
    try {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      notifyListeners();
        return await _auth.signInWithCredential(credential);

    } catch (e) {
      errorMessage=e.toString();
    }
  }

 saveGoogleUser()async{
   final GoogleSignInAccount currentGoogleUser =  _googleSignIn.currentUser;

   await DataBase().addTraveler(Travelers(
     id:  _user.uid,
     username: currentGoogleUser.email,
     password: null,
     fullName:currentGoogleUser.displayName,
     address:null,
     phone: null,
     gender: null,
     image: currentGoogleUser.photoUrl,
     createdAt: DateTime.now(),
   ));
 }


  Future loginWithFacebook(FacebookLoginResult result) async {
   try{
     final FacebookAccessToken accessToken = result.accessToken;
     AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
     fbUser= await _auth.signInWithCredential(credential);
     notifyListeners();
     return fbUser;

   }catch(e){
     errorMessage=e.toString();
   }
  }



  Future handleFacebookLogin() async {
    FacebookLoginResult _result = await _fbLogin.logIn(["email"]);

    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        try {

          return await loginWithFacebook(_result);

        } catch (e) {
          print(e.message);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("user cancel login");
        break;
      case FacebookLoginStatus.error:
        print("${_result.errorMessage}");
        break;
    }
    notifyListeners();
  }


  saveFaceBookUser()async{
    await DataBase().addTraveler(Travelers(
      id: fbUser.user.uid,
      username: fbUser.user.email,
      password: null,
      fullName: fbUser.user.displayName,
      address: null,
      phone: fbUser.user.phoneNumber,
      gender: null,
      image: fbUser.user.photoURL,
      createdAt: DateTime.now(),
    ));
  }

  currentUser() {
    User user = _auth.currentUser;
    return user != null ? user.uid : null;
  }



  Future<void> logout() async {
    try{
      await _auth.signOut();
      await _fbLogin.logOut();
      await _googleSignIn.signOut();

    }catch (e){
      print("${e.toString()}");
    }
  }
}
