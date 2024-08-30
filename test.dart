import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:mon_projet2/reservation.dart';
import 'dart:typed_data';
import 'services/firestore.dart';

class Test extends StatefulWidget {
  final String carId;
  const Test({super.key, required this.carId});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late Future<DocumentSnapshot> _carData;
  int _currentIndex = 0;
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _carData =
        FirebaseFirestore.instance.collection('cars').doc(widget.carId).get();
  }

  Future<Uint8List?> removeBackground(String imageUrl) async {
    final response = await http.post(
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
      headers: {
        'X-Api-Key': 'hVdGpbFsrbgWgBXNydde11cU',
      },
      body: {
        'image_url': imageUrl,
        'size': 'auto',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Appbarsection(context),
            FutureBuilder<DocumentSnapshot>(
              future: _carData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error loading data');
                  }
                  if (snapshot.data != null) {
                    DocumentSnapshot carData = snapshot.data!;
                    Map<String, dynamic> carDataMap =
                        carData.data() as Map<String, dynamic>;
                    List<String> imageUrls =
                        List<String>.from(carDataMap['image_urls']);
                    return Column(
                      children: [
                        imgsection(imageUrls),
                        Stack(children: [
                          specificationsection(carDataMap),
                          plussection,
                        ])
                      ],
                    );
                  } else {
                    return const Text('Document not found');
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget Appbarsection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              firestoreService.addToFavorites(widget.carId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Car added to favorite'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Car details",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Eczar',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

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

  Widget imgsection(List<String> imageUrls) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: 340,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            color: Colors.white,
          ),
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: removeBackground(imageUrls[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Image.network(imageUrls[index], fit: BoxFit.cover);
                    } else {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover);
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageUrls.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget specificationsection(Map<String, dynamic> carData) {
    // Assurez-vous que 'rental_price' est une chaîne et convertissez-la en double
    double rentalPrice =
        double.tryParse(carData['rental_price'].toString()) ?? 0.0;

    // Calculez les prix en fonction de la durée et formatez-les avec trois chiffres après la virgule
    String price12Month = '${(rentalPrice * 355).toStringAsFixed(2)} DH';
    String price6Month = '${(rentalPrice * 117).toStringAsFixed(2)} DH';
    String price2Month = '${(rentalPrice * 60).toStringAsFixed(2)} DH';

    return Container(
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
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Brand:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['brand']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Model:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['model']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Year:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['year']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
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
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Color:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['color']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Seats:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['seat']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Available:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['available']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('Fuel:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text('${carData['fuel_type']}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
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
                  innerShadowContainer(
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 35, 79, 234),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 13, top: 4),
                            child: Text('12 Month:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: 'Mukta',
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13, top: 2),
                            child: Text(price12Month,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mukta',
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('6 Month:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text(price6Month,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                  innerShadowContainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 50, top: 4),
                          child: Text('2 Month:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 139, 135, 135),
                                fontFamily: 'Mukta',
                              )),
                        ),
                        Text(price2Month,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mukta',
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Per day',
                      style: TextStyle(fontSize: 18, fontFamily: 'Mukta'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${double.parse(carData['rental_price']).toStringAsFixed(2)}DH', // Ceci est un exemple. Remplacez-le par le prix réel si disponible
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 35, 79, 234),
                  foregroundColor: Colors.white,
                  shadowColor:
                      const Color.fromARGB(255, 200, 200, 200).withOpacity(0.5),
                  elevation: 4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReservationPage(carId: widget.carId),
                    ),
                  );
                },
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
          ),
        ],
      ),
    );
  }
}

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
          color: const Color.fromARGB(255, 244, 242, 242),
        ),
        child: Center(child: child),
      ),
    ),
  );
}
