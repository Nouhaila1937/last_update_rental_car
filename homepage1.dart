import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:mon_projet2/navigation_bar.dart';
import 'package:mon_projet2/search.dart';
import 'package:mon_projet2/test.dart';
import 'notification.dart';

class Homepage1 extends StatelessWidget {
  const Homepage1({super.key});

  @override

  Widget build(BuildContext context) {  
  
    return Scaffold(
       appBar: AppBar(
        title: const Text('Accueil'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 5, 5, 5),
      body: SingleChildScrollView(
          child: Column(
        children: [
          searchsection(context),
          brandssection,
          availablesection,
        ],
      )),
      bottomNavigationBar: const Navigationbar(),
    );
  }
}
Future<Uint8List> removeBackground(String imageUrl) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
      headers: {
        'X-Api-Key': 'hVdGpbFsrbgWgBXNydde11cU', // clé API
      },
      body: {
        'image_url': imageUrl,
        'size': 'auto',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      // En cas d'erreur, essayez de retourner l'image originale
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        return imageResponse.bodyBytes;
      } else {
        throw Exception('Failed to fetch original image');
      }
    }
  } catch (e) {
    // Gérer les exceptions en essayant d'obtenir l'image originale
    final imageResponse = await http.get(Uri.parse(imageUrl));
    if (imageResponse.statusCode == 200) {
      return imageResponse.bodyBytes;
    } else {
      throw Exception('Failed to fetch original image');
    }
  }
}

Widget searchsection(BuildContext context) => Container(
  margin: const EdgeInsets.only(top: 80, bottom: 12),
  width: 360,
  height: 60,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(23),
  ),
  child: Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.manage_search_outlined,
            color: Color.fromARGB(255, 81, 80, 80),
            size: 40,
          ),
        ),
      ),
      Expanded(
        child: TextField(
          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            hintText: "Search Car...",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          textAlign: TextAlign.left,
          onSubmitted: (query) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(searchQuery: query),
              ),
            );
          },
        ),
      ),
    ],
  ),
);

Widget brandssection = Container(
  margin: const EdgeInsets.all(20),
  child: Column(
    children: [
      const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Brands",
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontFamily: 'Ledger',
          ),
        ),
      ),
      const SizedBox(height: 20),
      FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('brand').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final brands = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: brands.map((brand) {
                final brandData = brand.data() as Map<String, dynamic>;
                return FutureBuilder<Uint8List>(
                  future: removeBackground(brandData['logo_url']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 39, 47, 54),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              brandData['logo_url'], // Affiche l'image d'origine en cas d'erreur
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 39, 47, 54),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 39, 47, 54),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    ],
  ),
);

Widget availablesection = Container(
  margin: const EdgeInsets.all(20),
  child: Column(
    children: [
      const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Available cars",
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontFamily: 'Ledger',
          ),
        ),
      ),
      const SizedBox(height: 20),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No cars available');
          }

          final cars = snapshot.data!.docs;
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
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 320,
                            height: 170,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 217, 217, 217),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.network(
                                carData['image_urls'][0], // Affiche l'image d'origine en cas d'erreur
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
                            color: const Color.fromARGB(255, 217, 217, 217),
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
                                          WidgetStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 35, 79, 234)),
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(14),
                                            bottomRight: Radius.circular(22),
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
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
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
                            color: const Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          // child: const Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                      height: 40), // Ajustez la taille de l'espace selon vos besoins
                ],
              );
            },
          );
        },
      ),
    ],
  ),
);
