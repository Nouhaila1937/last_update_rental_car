import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigationbar extends StatelessWidget {
  const Navigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    void checkAuthAndNavigate() {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/like');
      }
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.hasData;

        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0), // Background color of the bottom bar
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, -2), // Changes the position of the shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white, // Background color of the BottomNavigationBar
              selectedItemColor: const Color.fromARGB(255, 31, 42, 241),
              unselectedItemColor: Colors.grey.withOpacity(0.7),
              selectedFontSize: 14,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(
                    Icons.home_rounded,
                    size: 28,
                  ),
                ),
                const BottomNavigationBarItem(
                  label: 'Contact',
                  icon: Icon(
                    Icons.messenger,
                    size: 28,
                  ),
                ),
                const BottomNavigationBarItem(
                  label: 'Favorites',
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 28,
                  ),
                ),
                BottomNavigationBarItem(
                  label: isLoggedIn ? 'Logout' : 'Login',
                  icon: const Icon(
                    Icons.account_circle,
                    size: 28,
                  ),
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/homepage1');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/contact');
                    break;
                  case 2:
                    checkAuthAndNavigate();
                    break;
                  case 3:
                    if (isLoggedIn) {
                      FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully logged out')),
                      );
                    } else {
                      Navigator.pushNamed(context, '/login');
                    }
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }
}
