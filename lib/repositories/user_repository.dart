import 'dart:async';
import 'package:anjo_guarda/model/responsavel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  Firestore _firestore = Firestore.instance;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
Future<void> signUp({String email, String password, UsuarioModel userModel}) async {
    
    var userAuth = await _firebaseAuth.createUserWithEmailAndPassword
                    (email: email,password: password);
    if (userAuth != null)
    {
      userModel.id = userAuth.user.uid;
      _firestore
        .collection("user")
        .document(userModel.id)
        .setData(userModel.toJson());
    }
    await _firebaseAuth.signInWithEmailAndPassword(email: email,password: password,);    
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

Future<String> getUserId() async {
    return (await  _firebaseAuth.currentUser()).uid;
  }

   Stream<UsuarioModel> getUser(String userID){
    
     return _firestore.collection("user")
                      .document(userID)
                      .snapshots()
                      .map((snap) => UsuarioModel.fromMap(snap.documentID, snap.data));
  }

   Future<void> update(UsuarioModel userModel) async {
    try
    {
      return _firestore
        .collection("user").document(userModel.id)
          .setData(userModel.toJson(),merge: true);
    }catch(error)
    {
      print(error);
    }
  }
}
