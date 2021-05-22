import 'package:flutter/material.dart';
import 'package:friday/database/auth/guest_information.dart';
import 'package:friday/utils/loading/call_loading.dart';
import 'package:friday/utils/loading/loading.dart';
import 'package:friday/utils/popup/popup.dart';

class GuestInformation extends StatefulWidget {
  @override
  _GuestInformationState createState() => _GuestInformationState();
}

class _GuestInformationState extends State<GuestInformation> {
  String firstName;
  String lastName;
  String phoneNumber;

  final _formKey = GlobalKey<FormState>();
  static const pattern = r'^[0]{1}[6-9]{1}[0-9]{8}$';
  RegExp regExp = RegExp(pattern);

  Future createInformation() async {
    var result = _formKey.currentState.validate();
    print(
        "firstname : $firstName, lastname : $lastName, phonenumber : $phoneNumber");

    if (result) {
      CallLoading.onLoading(context);
      await Authentication.guestRegister(firstName, lastName, phoneNumber)
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (Route<dynamic> route) => false);
        print(value);
      }).catchError((onError) {
        Navigator.pop(context);
        PopUp(
          message: "Something went wrong please try again",
        );
        print(onError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Information",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 128, 128, 1),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                            ),
                            Text(
                              "Please enter your information",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(77, 77, 77, 1),
                              ),
                            ),
                            Text(
                              "for register guest account and unlock",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(77, 77, 77, 1),
                              ),
                            ),
                            Text(
                              "new experience for your trip planing",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(77, 77, 77, 1),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        hintText: 'John',
                        labelText: 'Firstname',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          firstName = value;
                        });
                      },
                      validator: (String value) {
                        print(regExp.hasMatch(value));
                        if (value == "") return "Must not be empty";
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        hintText: 'Doe',
                        labelText: 'Lastname',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          lastName = value;
                        });
                      },
                      validator: (String value) {
                        print(value);
                        if (value == "") return "Must not be empty";
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 1),
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        hintText: '(+66)99-999-9999',
                        labelText: 'Phone number',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      validator: (String value) {
                        print(value);
                        print("Validate : ${regExp.hasMatch(value)}");
                        if (value == "") return "Must not be empty";
                        if (!regExp.hasMatch(value.toString())) {
                          return "Invalid phone number";
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 90,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(0, 128, 128, 1)),
                              ),
                              onPressed: () {
                                createInformation();
                              },
                              child: Text("Next")),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        SizedBox(
                          height: 40,
                          width: 90,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(77, 77, 77, 1)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancle")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
