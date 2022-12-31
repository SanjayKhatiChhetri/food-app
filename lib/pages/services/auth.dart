import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';

class AuthService with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? fuser;
  late StreamSubscription userAuthSub;

  AuthService() {
    userAuthSub =   FirebaseAuth.instance.authStateChanges().listen((newUser) {
      // print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      fuser = newUser;
      notifyListeners();
    }, onError: (e) {
      print('Error in auth.dart AuthService() - $e');
    });
  }


  // create user object based on firebase user
  UserClass? _userFromFirebase(User user){
    return user != null ? UserClass(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserClass?> get user{
    return _auth.authStateChanges()
    .map((user) => _userFromFirebase(user!));
  }

  //  sign in anonymous
  Future signinAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //  sign out anon
  Future signOutAnon() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}