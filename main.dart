import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mon_projet2/acceuil.dart';
import 'package:mon_projet2/admin/admin_notif.dart';
import 'notification.dart';
import 'reservation.dart';
import 'homepage1.dart';
import 'like.dart';
import 'login.dart';
import 'signup.dart'; 
import 'contact.dart';
import 'admin/add_car.dart';
import 'admin/add_brand.dart';
import 'admin/crud.dart';
// ignore: depend_on_referenced_packages
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  setUrlStrategy(PathUrlStrategy());
  // Configuration pour le routage web
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyCviHE_DEtD8Y35NdPz-eFMk3AiPByedwk",
      //   authDomain: "projet-stage-12cc9.firebaseapp.com",
      //   projectId: "projet-stage-12cc9",
      //   storageBucket: "projet-stage-12cc9.appspot.com",
      //   messagingSenderId: "666048063853",
      //   appId: "1:666048063853:web:71eec0d5fd75de82a81264",
      //   measurementId: "G-XXXXXXX",
      // ),
      ); // Initialise Firebase dans l'application
  runApp(const MyApp()); // Lance l'application Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
      // '/': (context) => const  NotificationsPage(),
        '/': (context) => const AcceuilPage(),
        '/homepage1': (context) => const Homepage1(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/like': (context) => const LikePage(),
        '/contact': (context) => const ContactPage(),
        '/addcar': (context) => const Addcar(),
        '/addbrand': (context) => const Addbrand(),
        // '/modifycar':(context)=>const Modifycar(),
        '/crud': (context) => const Crud(),
        // '/reservation': (context) => const ReservationPage(carId: '',),
        '/notification': (context) => const AdminReservationsPage(),
      },
    );
  }
}
