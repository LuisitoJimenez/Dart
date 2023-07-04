//Main.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");
  runApp(App());
}

class App extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return MaterialApp(

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }

}