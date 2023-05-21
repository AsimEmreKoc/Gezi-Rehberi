import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gezi_rehberi/screens/Pages/login.dart';
import 'package:gezi_rehberi/screens/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
     MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Gezi Rehberi',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home:  StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return VerifyEmailPage();
            }else{
              return loginRef();
            }
          },
        )); }
