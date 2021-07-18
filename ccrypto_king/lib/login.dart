
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login_functions {

  Login_functions({ this.email, this.password});

  bool signin = false;

  final email;
  final password;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Register_func() async{

    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }  catch (e) {
      print (e);
    }

    User? user = _firebaseAuth.currentUser;

    if(user == null )print(null);
    print(user);
    return user;


  }

  Signin_func() async{

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }  catch (e) {
      print(e);
    }

    User? user = _firebaseAuth.currentUser;
    if(user !=null) return user;


  }

  Singingoogle () async{

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;


    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    return credential;


  }

}
