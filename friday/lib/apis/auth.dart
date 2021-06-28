import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friday/apis/root.dart';

class AuthRoute {
  static String host = MainRoot.root;
  static String _userInfo = "$host/auth/userInfo";
  static String _registration = "$host/auth/registration";
  static String _uploadProfile = "$host/auth/uploadProfile";

  static Future<dynamic> userInfo(uid) async {
    try {
      var user = await Dio().post(_userInfo, data: {"uid": uid});

      return user;
    } catch (e) {}
  }

  static Future<bool> registration(user, uid) async {
    if (user['file'] != null) {
      print("Do !");

      try {
        var _upload = await Dio().post(_uploadProfile,
            data: FormData.fromMap({
              "uid": uid,
              "file": await MultipartFile.fromFile(user["file"].toString()),
            }),
            options: Options(contentType: "multipart/form-data"));

        print(_upload);

        var response = await Dio().post(
          _registration,
          data: {
            "email": user["email"],
            "uid": uid,
            "displayName": user["displayName"],
            "phone": user["phone"],
            "user_image_path": _upload.data["message"]
          },
        );

        if (response.data["code"] == "auth/created") {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
      }
    } else {
      print(user['email']);

      try {
        var response = await Dio().post(
          _registration,
          data: {
            "email": user["email"],
            "uid": uid,
            "displayName": user["displayName"],
            "phone": '',
            "user_image_path": user["user_image_path"]
          },
        );
        print(response);
        if (response.data["code"] == "auth/created") {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
