import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "email": email,
      });

      return "Successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Error: Email already in use.");
        return "Email already in use";
      } else if (e.code == 'weak-password') {
        print("Error: Weak password.");
        return "Weak password";
      } else {
        print("Error: ${e.message}");
        return e.message ?? "Unknown error";
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      return "An error occurred";
    }
  }

  Future<String> signInUser({
    required String email,
    required String password,
  })async{
String res = "Some error occured";
try{
    if(email.isEmpty || password.isEmpty){
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    res = "success";
    }
    else{
      res= "Please enter your email and password";
    }
    }catch (e) {
   return  e.toString();
    }
    return res;
  }
}
