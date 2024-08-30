import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationPage extends StatefulWidget {
  final String carId;
  const ReservationPage({super.key, required this.carId});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

void _submitReservation() async {
  String? userId = _getUserId();

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez vous connecter pour faire une réservation')),
    );
    return;
  }

  if (_startDate != null &&
      _endDate != null &&
      _startTime != null &&
      _endTime != null ) {
    // Fusion des dates et heures sans conversion de fuseau horaire
    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    await FirebaseFirestore.instance.collection('reservations').add({
      'userId': userId,
      'carId': widget.carId,
      'startDate': Timestamp.fromDate(startDateTime),
      'endDate': Timestamp.fromDate(endDateTime),
      'startTime': Timestamp.fromDate(startDateTime),
      'endTime': Timestamp.fromDate(endDateTime),
      'status': 'pending',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Réservation envoyée avec succès')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez sélectionner une plage de dates et d\'heures valide')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faire une Réservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return (day.isSameDate(_startDate) || day.isSameDate(_endDate));
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (_startDate == null || (_startDate != null && _endDate != null)) {
                    _startDate = selectedDay;
                    _startTime = const TimeOfDay(hour: 9, minute: 0);
                    _endDate = null;
                  } else if (_endDate == null) {
                    if (selectedDay.isAfter(_startDate!)) {
                      _endDate = selectedDay;
                      _endTime = const TimeOfDay(hour: 17, minute: 0);
                    } else {
                      _endDate = _startDate;
                      _endTime = _startTime!;
                      _startDate = selectedDay;
                      _startTime = const TimeOfDay(hour: 9, minute: 0);
                    }
                  }
                }
                );
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectStartTime(context),
              child: const Text('Choisir Heure de Départ'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectEndTime(context),
              child: const Text('Choisir Heure d\'Arrivée'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReservation,
              child: const Text('Soumettre la Réservation'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }
}
