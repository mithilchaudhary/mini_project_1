import 'package:flutter/material.dart';
import 'package:mini_proj/SignedIn.dart';
import 'package:mini_proj/authentication_services.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges)
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Social Distancing using Geolocator',
            theme: ThemeData(primaryColor: Colors.red[800]),
            home: AuthenticationWrapper()));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return SignedIn(firebaseUser.uid);
    }
    return HomePage();
  }
}
