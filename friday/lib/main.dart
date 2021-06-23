import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friday/screens/dashboard/dashboard.dart';
import 'package:friday/screens/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Kanit",
        primaryColor: Color.fromRGBO(177, 30, 94, 1),
        accentColor: Color.fromRGBO(234, 0, 97, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(234, 0, 97, 1),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {},
      home: FutureBuilder(
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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Index();
        },
      ),
    );
  }
}
