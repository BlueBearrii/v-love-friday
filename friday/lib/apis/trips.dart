import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:friday/apis/root.dart';

class TripRoute {
  static String host = MainRoot.root;
  static String fetchTripsCollection = "$host/trip/fetchTrips";
  static String fetchTripSinglePage = "$host/trip/fetchTrip";
  static String fetchTripBook = "$host/trip/fetchBooked";
  static String createTripPath = "$host/trip/createTripRoom";
  static String bookingNow = "$host/trip/bookNow";
  static String loadBalance = "$host/trip/loadBalance";
  static String fetchComments = "$host/trip/fetchingComments";
  static String fetchTripPublic = "$host/trip/fetchTripPublic";
  static String createPost = "$host/trip/post";
  static String _updateCover = "$host/trip/updateCover";

  static Future<List> fetchTrips(uid) async {
    print(uid);
    try {
      var response = await Dio().post(fetchTripsCollection, data: {"uid": uid});

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchTripBooking(uid, tripId) async {
    try {
      var response =
          await Dio().post(fetchTripBook, data: {"uid": uid, "tripId": tripId});

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<String> createTrip(trip) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(trip["uid"]).set(
          {"wallet": FieldValue.increment(trip["budget"] * (-1))},
          SetOptions(merge: true));

      var response = await Dio().post(createTripPath, data: trip);

      return response.data["code"];
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> bookNow(data) async {
    try {
      var response = await Dio().post(bookingNow, data: data);

      return response.data["status"];
    } catch (e) {
      print(e);
    }
  }

  static Future<int> loadBalanceUpdated(uid, tripId) async {
    try {
      var response =
          await Dio().post(loadBalance, data: {"uid": uid, "tripId": tripId});

      return response.data["message"]["balance"];
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchingComments(uid, tripId) async {
    try {
      var response =
          await Dio().post(fetchComments, data: {"uid": uid, "tripId": tripId});

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<String> creatingPost(
      uid, tripId, username, comments, file, userImage) async {
    print(file);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";

    FormData formdata = FormData.fromMap({
      "file": file == null ? '' : await MultipartFile.fromFile(file.toString()),
      "uid": uid,
      "tripId": tripId,
      "username": username,
      "comments": comments,
      "user_image_path": userImage,
      "createdAt": DateTime.now().toIso8601String(),
    });

    try {
      var response = await Dio().post(createPost,
          data: formdata, options: Options(contentType: "multipart/form-data"));

      print(response.data["code"]);

      return response.data["code"];
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchingPublicTrips(uid) async {
    try {
      var response = await Dio().post(fetchTripPublic, data: {"uid": uid});

      return response.data["message"];
    } catch (e) {
      print(e);
    }
  }

  static Future<String> updateCover(uid, tripId, file) async {
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.toString()),
      "uid": uid,
      "tripId": tripId,
    });

    try {
      var response = await Dio().post(_updateCover, data: formdata);

      return response.data["code"];
    } catch (e) {
      print(e);
    }
  }
}
