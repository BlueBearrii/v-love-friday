import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:friday/apis/root.dart';
import 'package:friday/apis/trips.dart';

class HostingRoute {
  static String host = MainRoot.root;
  static String _createHost = "$host/host/createHost";
  static String fetchHostsCollection = "$host/host/fetchHosting";
  static String _fetchAllHosting = "$host/host/fetchAllHosting";
  static String fetchLikeHost = "$host/host/likeHost";
  static String fetchGotLikeHost = "$host/host/gotLikeHost";
  static String _uploadPhoto = "$host/host/uploadPhoto";
  static String _uploadPhotos = "$host/host/uploadPhotos";

  static Future<dynamic> createHost(data) async {
    //print(data);
    // Map newdata = {
    //   "uid": user.uid,
    //   "hostName": hostName,
    //   "address": {"address": address, "city": city, "province": province},
    //   "contact": {"email": email, "phone": phone},
    //   "order": data,
    //   "description": description,
    //   "conditions": conditions,
    //   "coverUrl": coverUrl,
    //   "type": selected_type
    // };

    var newData = data;

    try {
      var i = [];
      for (int _i = 0; _i < data["order"].length; _i++) {
        i.add(await MultipartFile.fromFile(
            data["order"][_i]["image_path"].toString(),
            filename: "${data["hostName"]}/order/$_i"));
      }

      var genCoverUrl = await Dio().post(
        _uploadPhoto,
        data: FormData.fromMap({
          "uid": data["uid"],
          "name": "${data["hostName"]}/cover",
          "path": "host-cover",
          "file": await MultipartFile.fromFile(data["coverUrl"].toString()),
        }),
        options: Options(contentType: "multipart/form-data"),
      );

      newData["coverUrl"] = genCoverUrl.data.toString();

      var genImagePath = await Dio().post(
        _uploadPhotos,
        data: FormData.fromMap(
            {"uid": data["uid"], "path": "host-images", "files": i}),
        options: Options(contentType: "multipart/form-data"),
      );

      for (int _i = 0; _i < data["order"].length; _i++) {
        newData["order"][_i]["image_path"] = genImagePath.data[_i].toString();
      }

      print(newData);

      var response = await Dio().post(_createHost, data: newData);

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchHost(uid, tripId, type, lifstyle, keywords) async {
    try {
      int _loadbalance = await TripRoute.loadBalanceUpdated(uid, tripId);

      var response = await Dio().post(fetchHostsCollection, data: {
        "uid": uid,
        "type": type,
        "lifstyle": lifstyle,
        "keywords": keywords,
        "balance": _loadbalance
      });

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchAllHost(type, uid, searchName) async {
    try {
      var response = await Dio().post(_fetchAllHosting,
          data: {"type": type, "uid": uid, "searchName": searchName});

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<String> liked(uid, hostid) async {
    try {
      var response = await Dio().post(fetchLikeHost, data: {
        "id": hostid,
        "uid": uid,
      });

      return response.data["message"]["status"];
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> gotLiked(uid, hostid) async {
    try {
      var response = await Dio().post(fetchGotLikeHost, data: {
        "id": hostid,
        "uid": uid,
      });

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }
}
