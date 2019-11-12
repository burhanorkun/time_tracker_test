import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class User {
  User(
      {@required this.uid,
      @required this.photoUrl,
      @required this.displayName});

  final String uid;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<User> signInAnonymously();

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      photoUrl: user.photoUrl,
      displayName: user.displayName,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;
    return _userFromFirebase(user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    //GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithFacebook() async {
    // TODO: implement signInWithFacebook
    /*
    final facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      FirebaseUser user = await _firebaseAuth.signInWithFacebook(
        accessToken: result.accessToken.token,
      );
      return _userFromFirebase(user);
    } else {
      throw StateError('Missing Facebook access token');
    }
     */
    return null;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    //final facebookLogin = FacebookLogin();
    //await facebookLogin.logOut();
    return await _firebaseAuth.signOut();
  }
}
