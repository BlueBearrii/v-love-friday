import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestAuth extends StatefulWidget {
  @override
  _TestAuthState createState() => _TestAuthState();
}

class _TestAuthState extends State<TestAuth> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken.token);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    signIn() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: signInWithGoogle, child: Text("Google sign-in")),
            ElevatedButton(
                onPressed: signInWithFacebook, child: Text("Facebook sign-in")),
          ],
        ),
      );
    }

    signOut() {
      return Center(
        child: ElevatedButton(
            onPressed: FirebaseAuth.instance.signOut, child: Text("Sign-out")),
      );
    }

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return signIn();
              } else {
                return signOut();
              }
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
