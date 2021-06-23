import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:friday/apis/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthClass {
  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    // Trigger the sign-in flow
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value);
    }).catchError((onError) {
      print(onError);
    });

    return userCredential;
  }

  static Future<UserCredential> signUpWithEmailAndPassword(data) async {
    // Trigger the sign-in flow
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: data["email"], password: data["password"])
        .then((value) async {
      await AuthRoute.registration(data, value.user.uid);
    }).catchError((onError) {
      print(onError);
    });

    return userCredential;
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token

    if (result.status == LoginStatus.success) {
      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  static Future<void> signOut() async {
    // Trigger the sign-in flow
    return FirebaseAuth.instance.signOut();
  }
}
