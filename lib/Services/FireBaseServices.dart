import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FireBaseServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isSignedIn = false;

  //getters
  User? get user => _user;
  bool get isSignedIn => _isSignedIn;

  // Constructor to listen for auth state changes
  FireBaseServices() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Notify UI when auth state changes
    });
  }

  //Sign In
  Future<bool> signIn(String email, String pass) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$email",
        password: "$pass",
      );
      if (_auth.currentUser != null) {
        _isSignedIn = true;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print("Failed with error: $e");
    }
    return false;
  }

  // Sign up with Email and Password
  Future<void> signUpWithEmail(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      // Optional: Create a user document in Firestore after sign up
      await _firestore.collection('users').doc(_user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('Error signing up: $e');
      throw e; // Handle error appropriately in your UI
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners(); // Notify listeners when the user is signed out
    } catch (e) {
      print('Error signing out: $e');
      throw e; // Handle error appropriately in your UI
    }
  }

  // Save data to Firestore (example function to save user info)
  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
    notifyListeners(); // Notify listeners after saving data
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categorie').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

}
