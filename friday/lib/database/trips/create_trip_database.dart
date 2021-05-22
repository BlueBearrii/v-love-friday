import 'package:cloud_firestore/cloud_firestore.dart';

class TripDatabase {
  static Future createTrip(String tripName, String uid, int budget,
      DateTime start, DateTime end) async {
    var data = {
      "tripName": tripName,
      "tripId": null,
      "uid": uid,
      "budget": budget,
      "start": start,
      "end": end
    };
    await FirebaseFirestore.instance
        .collection("trips")
        .add(data)
        .then((value) {
      value.update({"tripId": value.id}).then((value) {
        return true;
      }).catchError((onError) {
        return false;
      });
    }).catchError((onError) {
      return false;
    });
  }
}
