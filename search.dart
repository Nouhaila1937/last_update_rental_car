import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'test.dart';

class SearchPage extends StatelessWidget {
  final String searchQuery;

  const SearchPage({required this.searchQuery, super.key});

  Future<Uint8List> removeBackground(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.remove.bg/v1.0/removebg'),
        headers: {
          'X-Api-Key': 'hVdGpbFsrbgWgBXNydde11cU', // Remplacez par votre clé API
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

  @override
  Widget build(BuildContext context) {
    final lowerCaseQuery = searchQuery.toLowerCase();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 5, 5),
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 60),
            Expanded(
              child: Scrollbar(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cars')
                      .snapshots(),
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

                    final cars = snapshot.data!.docs.where((car) {
                      final carData = car.data() as Map<String, dynamic>;
                      final brand = (carData['brand'] as String).toLowerCase();
                      final model = (carData['model'] as String).toLowerCase();
                      return brand.contains(lowerCaseQuery) || model.contains(lowerCaseQuery);
                    }).toList();

                    if (cars.isEmpty) {
                      return const Text('No cars found matching your query');
                    }

                    return ListView.builder(
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
                                    return const Text('Something went wrong');
                                  }
                                  return Container(
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
                                                    builder: (context) => Test(carId: car.id),
                                                  ),
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStateProperty.all<Color>(
                                                    const Color.fromARGB(255, 35, 79, 234)),
                                                foregroundColor: WidgetStateProperty.all<Color>(
                                                    Colors.white),
                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 60), // Ajustez la taille de l'espace selon vos besoins
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
