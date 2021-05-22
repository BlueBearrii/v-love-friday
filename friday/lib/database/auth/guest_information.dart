import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static Future<bool> guestRegister(
      String firstname, String lastname, String phonenumber) async {
    await FirebaseAuth.instance.signInAnonymously().then((value) async {
      var data = {
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "uid": value.user.uid,
        "userType": "Anonymous"
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(value.user.uid)
          .set(data)
          .then((value) {
        return true;
      }).catchError((onError) {
        print(onError);
        return false;
      });

      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });

    return true;
  }
}
