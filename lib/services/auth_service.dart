import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Registration failed: $e");
      return null;
    }
  }

  // Login
Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      print("User authenticated: ${userCredential.user?.uid}"); // Debugging message
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Authentication Error: ${e.message}"); // Debugging message
      return null;
    }
  }
  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}