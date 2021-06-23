import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/auth/firebase_auth_class.dart';
import 'package:friday/screens/index.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String firstname;
  String lastname;
  String email;
  String password;
  String confirmpassword;
  String phone;

  final _formKey = GlobalKey<FormState>();

  File _image;
  String _image_path;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        _image = File(pickedFile.path);
        _image_path = pickedFile.path;
      });

      print(_image);
    } catch (e) {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
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
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: getImage,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      backgroundImage: _image == null
                                          ? null
                                          : FileImage(_image),
                                      child: Icon(
                                        _image == null
                                            ? Icons.person
                                            : Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Email address",
                                  prefixIcon: Icon(Icons.email),
                                  enabled: true,
                                  border: OutlineInputBorder(),
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
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.lock),
                                  enabled: true,
                                  border: OutlineInputBorder(),
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
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Confirm-Password",
                                  prefixIcon: Icon(Icons.lock),
                                  enabled: true,
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(color: Colors.grey.shade800),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  setState(() {
                                    confirmpassword = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  if (value != password) {
                                    print(value);
                                    return 'Confirm password not match';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Firstname",
                                  prefixIcon: Icon(Icons.person),
                                  enabled: true,
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(color: Colors.grey.shade800),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  setState(() {
                                    firstname = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Lastname",
                                  prefixIcon: Icon(Icons.person),
                                  enabled: true,
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(color: Colors.grey.shade800),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  setState(() {
                                    lastname = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Mobile number",
                                  prefixIcon: Icon(Icons.phone),
                                  enabled: true,
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(color: Colors.grey.shade800),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                                validator: (value) {
                                  bool mobile = RegExp(r"^(?:[+0]9)?[0-9]{10}$")
                                      .hasMatch(value);

                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  if (!mobile) {
                                    return 'Invalid phone number';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30, bottom: 30),
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Map data = {
                                      "displayName": "$firstname $lastname",
                                      "email": email,
                                      "password": password,
                                      "phone": phone,
                                      "user_image_path": null,
                                      "file": _image_path
                                    };

                                    print(data);

                                    if (_formKey.currentState.validate()) {
                                      CustomLoading.loadingNormal(context);
                                      FirebaseAuthClass
                                              .signUpWithEmailAndPassword(data)
                                          .then((value) {
                                        Navigator.popUntil(
                                            context, ModalRoute.withName('/'));
                                      });
                                    }
                                  },
                                  child: Text("Register"),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
          )
        ],
      ),
    );
  }
}
