import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:mon_projet2/acceuil.dart';
import 'homepage1.dart';
import 'like.dart';
import 'login.dart';
import 'signup.dart';
import 'details_car.dart';
import 'contact.dart'; 
import 'admin/add_car.dart';
import 'admin/add_brand.dart';
import 'admin/crud.dart';
 void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Assure que les widgets Flutter sont initialisés.
  await Firebase.initializeApp(); // Initialise Firebase dans l'application.
  runApp(const MyApp()); // Lance l'application Flutter.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AcceuilPage(),
        '/homepage1': (context) => const Homepage1(), 
        '/login': (context) =>  LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/details_car': (context) => const DetailsCarPage(),
        '/like': (context) => const LikePage(),
        '/contact': (context) => const ContactPage(), 
        '/addcar':(context)=>const Addcar(),
        '/addbrand':(context)=>const Addbrand(),
        // '/modifycar':(context)=>const Modifycar(),
        '/crud':(context)=> const Crud(),
      },
    );
  }
}
