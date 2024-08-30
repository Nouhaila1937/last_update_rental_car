import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: user.uid)
            .orderBy('startDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Une erreur est survenue : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucune réservation."));
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final status = reservation['status'];
              final carId = reservation['carId'];
              final startDate = reservation['startDate']?.toDate();
              final endDate = reservation['endDate']?.toDate();

              if (startDate == null || endDate == null) {
                return const ListTile(
                  title: Text("Format de date incorrect."),
                );
              }

              String statusText = "";
              if (status == 'pending') {
                statusText = "En attente";
              } else if (status == 'accepted') {
                statusText = "Acceptée";
              } else if (status == 'rejected') {
                statusText = "Refusée";
              }

              // Création d'une future pour récupérer les détails de la voiture
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('cars').doc(carId).get(),
                builder: (context, carSnapshot) {
                  if (carSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Chargement des détails de la voiture..."),
                    );
                  }

                  if (carSnapshot.hasError) {
                    return Center(child: Text("Une erreur est survenue : ${carSnapshot.error}"));
                  }

                  if (!carSnapshot.hasData || !carSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text("Détails de la voiture non trouvés."),
                    );
                  }

                  final carData = carSnapshot.data!.data() as Map<String, dynamic>;
                  final brand = carData['brand'] ?? 'Marque inconnue';
                  final model = carData['model'] ?? 'Modèle inconnu';

                  return ListTile(
                    title: Text("Réservation $statusText"),
                    subtitle: Text(
                      "Marque : $brand\n"
                      "Modèle : $model\n"
                      "Du ${startDate.day}/${startDate.month}/${startDate.year} au ${endDate.day}/${endDate.month}/${endDate.year}",
                    ),
                    trailing: status == 'pending'
                        ? const Icon(Icons.hourglass_empty)
                        : const Icon(Icons.check),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
