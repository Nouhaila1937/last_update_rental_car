import 'package:flutter/material.dart';

class AcceuilPage extends StatelessWidget {
  const AcceuilPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bugatti.jpg'),
              // fit: BoxFit.co,
            ),
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),
              const Center(
                child: Text(
                  'Rental Car',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jura',
                  ),
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Find your favorite car with a good price',
                style: TextStyle(
                  color: Color.fromARGB(223, 255, 255, 255),
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the next page
                    Navigator.pushNamed(context, '/homepage1');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 17, 60, 216),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  label: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 21,
                      fontFamily: 'Mukta',
                      color: Color.fromARGB(236, 255, 255, 255),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(236, 255, 255, 255),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
