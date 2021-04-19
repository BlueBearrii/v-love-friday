import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friday/components/app/booking/booking.dart';
import 'package:friday/components/app/booking/booking_select.dart';
import 'package:friday/components/app/booking/create_booking.dart';
import 'package:friday/components/app/index.dart';
import 'package:friday/components/general/signin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/sign_in': (context) => SignIn(),
        '/booking': (context) => Booking(),
        '/create_booking': (context) => CreateBooking(),
        '/booking_select': (context) => BookingSelect(),
      },
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Something went wrong"),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Index();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
