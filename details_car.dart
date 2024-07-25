import 'package:flutter/material.dart';

class DetailsCarPage extends StatelessWidget {
  const DetailsCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Appbarsection(context),
            imgsection,
            Stack(children: [
              specificationsection,
              plussection,
            ])
          ],
        ),
      ),
    );
  }
}

Widget Appbarsection(BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 30,
              ))
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homepage1');
          },
        ),
        title: const Text(
          "Cars details",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Eczar',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ));
}

Widget imgsection = Container(
  margin: const EdgeInsets.only(top: 10.0),
  width: 340,
  height: 210,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(33),
    color: Colors.white,
  ),
);

Widget plussection = Container(
  margin: const EdgeInsets.only(top: 50.0, left: 160),
  width: 80,
  height: 6,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(14),
    color: const Color.fromARGB(255, 217, 217, 217),
    border: Border.all(color: Colors.black),
  ),
);

Widget specificationsection = Container(
  margin: const EdgeInsets.only(top: 30.0),
  width: 400,
  height: 440,
  decoration: const BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(28),
      topRight: Radius.circular(28),
    ),
    color: Colors.white,
  ),
  child: Column(
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(top: 50, right: 190),
        child: Text(
          'Specifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              innerShadowContainer(const Text('Text 1')),
              innerShadowContainer(const Text('Text 2')),
              innerShadowContainer(const Text('Text 3')),
              innerShadowContainer(const Text('Text 4')),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 2, left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              innerShadowContainer(const Text('Text 5')),
              innerShadowContainer(const Text('Text 6')),
              innerShadowContainer(const Text('Text 7')),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 24),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                'Price',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 2, left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              innerShadowContainer(const Text('Text 5')),
              innerShadowContainer(const Text('Text 6')),
              innerShadowContainer(const Text('Text 7')),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10), // Correction ici : ajout d'une virgule après le SizedBox
    Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: <Widget>[
    const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 30),
          child: Column(
            children: [
              Text(
                'Per day',
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30), // Add left padding to "500.00 DH"
                child: Text(
                  '500.00 DH',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 35, 79, 234),
              foregroundColor: Colors.white,
              shadowColor: const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
            ),
            onPressed: () {},
            child: const Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Book Now',
                  style: TextStyle(fontSize: 18),
                ),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ), // Correction ici : ajout d'une parenthèse fermante pour fermer la liste des enfants de Column
    ],
  ),
);

Widget innerShadowContainer(Widget child) {
  return Container(
    margin: const EdgeInsets.only(right: 20.0),
    width: 161,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15), // Appliquer borderRadius ici
    ),
    child: Padding(
      padding: const EdgeInsets.all(
          8.0), // Ajustez l'espace intérieur pour contrôler la taille de l'ombre
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 233, 8, 8),
        ),
        child: Center(child: child),
      ),
    ),
  );
}
