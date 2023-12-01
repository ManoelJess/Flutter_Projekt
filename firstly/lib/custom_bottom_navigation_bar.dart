import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red, 
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Nachrichten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: Colors.blue),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.blue),
            label: 'Konto',
          ),
        ],
        backgroundColor: Colors.red, // Fond rouge pour le conteneur
        selectedItemColor: Colors.black, // Couleur du texte sélectionné
        unselectedItemColor: Colors.green, // Couleur du texte non sélectionné
      ),
    );
  }
}
