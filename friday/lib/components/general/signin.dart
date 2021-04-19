import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/common/custom_size.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final customSize = new CustomSize();

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black45, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: customSize.getWidth(10, context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Sign in",
                    style: TextStyle(color: Colors.black54, fontSize: 28),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Enter email address"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Enter password"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Sign in"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot your password?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    signInWithFacebook().whenComplete(
                      () => Navigator.popUntil(
                        context,
                        ModalRoute.withName('/'),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.facebook),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Expanded(child: Text("Sign in with Facebook")),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(59, 89, 152, 1)),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    signInWithGoogle().whenComplete(
                      () => Navigator.popUntil(
                        context,
                        ModalRoute.withName('/'),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Expanded(child: Text("Sign in with Google")),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(219, 68, 55, 1)),
                ),
              ),
            ],
          ),
        ));
  }
}
