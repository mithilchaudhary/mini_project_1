import 'package:flutter/material.dart';
import 'DistancingPage.dart';
import 'HandWashPage.dart';
import 'MaskPage.dart';

class SignedIn extends StatefulWidget {
  final String uid;
  SignedIn(this.uid);
  @override
  _SignedInState createState() => _SignedInState(uid);
}

class _SignedInState extends State<SignedIn> {
  final String uid;
  _SignedInState(this.uid);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [DistancingPage(uid), HandWashPage(), MaskPage()];
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 25,
        selectedFontSize: 13,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Distancing',
            backgroundColor: Colors.red[800],
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'HandWash',
              backgroundColor: Colors.red[800]),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Mask Reminder',
            backgroundColor: Colors.red[800],
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
