import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); 
  final TextEditingController confirmpasswordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBarSection(context),
            signupsection(context, firstnameController, lastnameController, emailController, passwordController, confirmpasswordController),
          ],
        ),
      ),
    );
  }

  void signup(BuildContext context) async {
    if (passwordController.text != confirmpasswordController.text) {
      showErrorDialog(context, 'Les mots de passe ne correspondent pas.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Stockage des informations personnelles dans Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstname': firstnameController.text,
          'lastname': lastnameController.text,
          'role':0,
            // Crée une sous-collection 'favorites' vide pour l'utilisateur
        'favorites': [],
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        // Redirection vers la page de connexion
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorDialog(context, 'Le mot de passe fourni est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog(context, 'Un compte existe déjà pour cette adresse email.');
      } else {
        showErrorDialog(context, e.message ?? 'Une erreur est survenue.');
      }
    } catch (e) {
      showErrorDialog(context, 'Une erreur est survenue. Veuillez réessayer.');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget appBarSection(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      title: const Text(
        "Sign Up",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Eczar',
          fontSize: 40,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget signupsection(BuildContext context, TextEditingController firstnameController, TextEditingController lastnameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmpasswordController) {
    return Container(
      margin: const EdgeInsets.only(top: 23),
      height: 680,
      width: 443,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          buildTextField('First Name', firstnameController),
          const SizedBox(height: 30),
          buildTextField('Last Name', lastnameController),
          const SizedBox(height: 30),
          buildTextField('Email', emailController),
          const SizedBox(height: 30),
          buildTextField('Password', passwordController, obscureText: true),
          const SizedBox(height: 30),
          buildTextField('Confirm Password', confirmpasswordController, obscureText: true),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white, // Text color
              shadowColor: const Color.fromARGB(255, 200, 200, 200)
                  .withOpacity(0.5), // Shadow color
              elevation: 4, // Elevation of the button
              padding: const EdgeInsets.symmetric(horizontal: 115, vertical: 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
            ),
            onPressed: () {
              signup(context);
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Already have an account? Sign in.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      width: 320,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          hintText: '**********',
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 166, 160, 160),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
