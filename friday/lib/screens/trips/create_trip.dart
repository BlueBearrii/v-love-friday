import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/database/trips/create_trip_database.dart';
import 'package:friday/utils/loading/call_loading.dart';
import 'package:intl/intl.dart';

class CreateTrip extends StatefulWidget {
  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  String tripName;
  int budget;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));

  User user = FirebaseAuth.instance.currentUser;

  _selectDate(BuildContext context, _initialDate, day) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _initialDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Select booking date', // Can be used as title
      cancelText: 'Not now',
      confirmText: 'Book',
    );
    if (day == 0) {
      if (picked != null && picked != selectedStartDate)
        setState(() {
          selectedStartDate = picked;
          selectedEndDate = picked.add(Duration(days: 1));
        });
    } else {
      if (picked != null && picked != selectedEndDate)
        setState(() {
          selectedEndDate = picked;
        });
    }
  }

  _createTripOnDatabase() async {
    CallLoading.onLoading(context);
    await TripDatabase.createTrip(tripName, user.uid.toString(), budget,
            selectedStartDate, selectedEndDate)
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.teal, //change your color here
        ),
        title: Text(
          "Create new trip!",
          style: TextStyle(color: Colors.teal),
        ),
      ),
      backgroundColor: Colors.teal,
      body: Center(
        child: SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        elevation: 1,
                        child: Center(child: Text("Image")),
                      ),
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                tripName = value;
                              });
                            },
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                budget = int.parse(value);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text("Start", style: TextStyle(fontSize: 16)),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, selectedStartDate, 0);
                                },
                                child: Text(
                                  DateFormat.yMMMd().format(selectedStartDate),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text("End", style: TextStyle(fontSize: 16)),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, selectedEndDate, 1);
                                },
                                child: Text(
                                  DateFormat.yMMMd().format(selectedEndDate),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              _createTripOnDatabase();
                            },
                            child: Text("Go Go !!")))
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
