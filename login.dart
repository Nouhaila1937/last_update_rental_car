import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text controllers to capture user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            appbarsection(context),
            logo,
            loginsection(context, emailController, passwordController),
          ],
        ),
      ),
    );
  }

  // User login function
  void login(BuildContext context) async {
    try {
     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, 
          password: passwordController.text);
       // Fetch the user's document from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        int role = userDoc['role'];

        // Navigate based on the user's role
        if (role == 1) {
          Navigator.pushReplacementNamed(context, '/crud'); // Redirect to admin page
        } else {
          Navigator.pushReplacementNamed(context, '/homepage1'); // Redirect to user homepage
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur est survenue. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget appbarsection(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context,'/homepage1');
          },
        ));
  }

  Widget logo = Container(
    margin: const EdgeInsets.only(top: 4.0),
    height: 87,
    width: 93,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(17),
        bottomRight: Radius.circular(17),
        bottomLeft: Radius.circular(17),
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 8),
          blurStyle: BlurStyle.solid,
        )
      ],
    ),
    child: const Center(
      child: Icon(
        Icons.directions_car_filled_sharp,
        color: Colors.black,
        size: 60,
      ),
    ),
  );

  Widget loginsection(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      height: 539,
      width: 443,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Eczar',
              ),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            width: 320,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'youremail@gmail.com',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 166, 160, 160),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromARGB(255, 166, 160, 160),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 320,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: '*************',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 166, 160, 160),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white, // Text color
              shadowColor: const Color.fromARGB(255, 200, 200, 200)
                  .withOpacity(0.5), // Shadow color
              elevation: 4, // Elevation of the button
              padding:
                  const EdgeInsets.symmetric(horizontal: 115, vertical: 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
            ),
            onPressed: () {
              login(context);
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                "Don't have any account? Sign up.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
