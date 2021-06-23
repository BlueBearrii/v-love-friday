import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/auth/firebase_auth_class.dart';
import 'package:friday/screens/authentication/register.dart';
import 'package:friday/screens/index.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:friday/utils/margin_space.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.3,
                    1.0,
                  ],
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                )),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            marginSpace(100, 0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Email address",
                                prefixIcon: Icon(Icons.email),
                                enabled: true,
                              ),
                              style: TextStyle(color: Colors.grey.shade800),
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              validator: (value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);

                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                if (!emailValid) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.remove_red_eye
                                        : Icons.remove_red_eye_outlined)),
                                enabled: true,
                              ),
                              style: TextStyle(color: Colors.grey.shade800),
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                if (value.length <= 6) {
                                  return 'Password must be more 6 characters';
                                }
                                return null;
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    CustomLoading.loadingNormal(context);

                                    FirebaseAuthClass
                                            .signInWithEmailAndPassword(
                                                email, password)
                                        .then((value) {
                                      Navigator.pop(context);
                                    }).catchError((onError) {
                                      print(onError);
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Text("Login"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create new account",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "or",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () {
                                  CustomLoading.loadingNormal(context);
                                  FirebaseAuthClass.signInWithFacebook()
                                      .then((value) async {
                                    print(value);
                                    Map data = {
                                      "displayName": value.user.displayName,
                                      "email": value.user.email,
                                      "phone": value.user.phoneNumber,
                                      "user_image_path": value
                                          .additionalUserInfo
                                          .profile["picture"]["data"]["url"],
                                      "file": null
                                    };

                                    await AuthRoute.registration(
                                            data, value.user.uid)
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Index()),
                                          (route) => false);
                                    });
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(FontAwesomeIcons.facebook),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    Text(
                                      "Continue with Facebook",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () async {
                                  CustomLoading.loadingNormal(context);
                                  await FirebaseAuthClass.signInWithGoogle()
                                      .then((value) async {
                                    Map data = {
                                      "displayName": value.user.displayName,
                                      "email": value.user.email,
                                      "phone": value.user.phoneNumber,
                                      "user_image_path": value
                                          .additionalUserInfo
                                          .profile["picture"],
                                      "file": null
                                    };

                                    await AuthRoute.registration(
                                            data, value.user.uid)
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Index()),
                                          (route) => false);
                                    });
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                        'assets/google/search.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
