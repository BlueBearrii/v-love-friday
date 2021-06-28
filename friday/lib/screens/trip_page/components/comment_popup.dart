import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/utils/margin_space.dart';
import 'package:image_picker/image_picker.dart';

class CommentPopUp extends StatefulWidget {
  final Map data;
  const CommentPopUp({Key key, this.data}) : super(key: key);

  @override
  _CommentPopUpState createState() => _CommentPopUpState();
}

class _CommentPopUpState extends State<CommentPopUp> {
  User user = FirebaseAuth.instance.currentUser;
  String comments;

  var _user;
  bool loading = false;

  File _image;
  String _image_path;
  final picker = ImagePicker();

  Future<Map> fetchUserInfo() async {
    var data;
    await AuthRoute.userInfo(user.uid).then((value) {
      if (value != null) {
        print(value.data["message"]);
        data = value.data["message"];
      }
    });
    return data;
  }

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black12.withOpacity(0.6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: FutureBuilder(
            future: fetchUserInfo(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  Card(
                      child: Container(
                    height: 600,
                    child: Column(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _image == null
                                ? GestureDetector(
                                    onTap: getImage,
                                    child: Container(
                                      color: Colors.grey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [Text("Upload photo here")],
                                      ),
                                    ),
                                  )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: snapshot.data["user_image_path"] != null
                                    ? Image.network(
                                        snapshot.data["user_image_path"])
                                    : Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                              ),
                              marginSpace(0, 5),
                              Text(snapshot.data["displayName"])
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  onChanged: (value) {
                                    comments = value;
                                    print(comments);
                                  },
                                  textInputAction: TextInputAction.done,
                                  maxLines: 10,
                                  maxLength: 360,
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Write some your experience",
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      loading = !loading;
                                    });
                                    TripRoute.creatingPost(
                                      user.uid,
                                      widget.data["tripId"],
                                      snapshot.data["displayName"],
                                      comments,
                                      _image_path,
                                      snapshot.data["user_image_path"],
                                    ).then((value) {
                                      if (value == "post/created") {
                                        Navigator.pop(context, true);
                                      }

                                      setState(() {
                                        loading = !loading;
                                      });
                                    });
                                  },
                                  child: loading
                                      ? Text("Loaind ...")
                                      : Text(
                                          "Comment",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                            ))
                      ],
                    ),
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
