import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mon_projet2/admin/crud.dart';
import 'package:mon_projet2/test.dart';
import 'services/firestore.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarSection(context),
            const FavSection(),
          ],
        ),
      ),
    );
  }
}

Widget AppBarSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    child: AppBar(
      backgroundColor: Colors.black,
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
        "Favorite Cars",
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

class FavSection extends StatefulWidget {
  const FavSection({super.key});

  @override
  _FavSectionState createState() => _FavSectionState();
}

class _FavSectionState extends State<FavSection> { 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData ||
                  snapshot.data!['favorites'] == null ||
                  (snapshot.data!['favorites'] as List).isEmpty) {
                return const Text('No favorite cars');
              }

              List<dynamic> favoriteCarIds = snapshot.data!['favorites'];
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cars')
                    .where(FieldPath.documentId, whereIn: favoriteCarIds)
                    .snapshots(),
                builder: (context, carSnapshot) {
                  if (carSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (carSnapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (!carSnapshot.hasData || carSnapshot.data!.docs.isEmpty) {
                    return const Text('No cars available');
                  }

                  final cars = carSnapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      final carData = car.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          FutureBuilder<Uint8List>(
                            future: removeBackground(carData['image_urls'][0]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: 320,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 217, 217, 217),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: Image.network(
                                        carData['image_urls'][
                                            0], // Affiche l'image d'origine en cas d'erreur
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: 320,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 217, 217, 217),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                        top: -40,
                                        left: (330 - 230) / 2,
                                        child: Image.memory(
                                          snapshot.data!,
                                          width: 230,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          //button pour afficher les details
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Test(carId: car.id),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                          Color>(
                                                      const Color.fromARGB(
                                                          255, 35, 79, 234)),
                                              foregroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(14),
                                                    bottomRight:
                                                        Radius.circular(22),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: const Text('Details'),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${carData['brand']} ${carData['model']} ${carData['year']}', // Concatenate values
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'DH ${carData['rental_price']} /day',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(Icons.favorite,
                                              color: Colors.red),
                                          onPressed: () async {
                                            await FirestoreService()
                                                .removeFromFavorites(car.id);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Car removed'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: 320,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 217, 217, 217),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                              height:
                                  40), // Ajustez la taille de l'espace selon vos besoins
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
