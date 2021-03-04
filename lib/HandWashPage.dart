import 'dart:ui';

import 'package:flutter/material.dart';

class HandWashPage extends StatefulWidget {
  @override
  _HandWashPageState createState() => _HandWashPageState();
}

class _HandWashPageState extends State<HandWashPage> {
  double _timeSliderval = 15;
  @override
  Widget build(BuildContext context) {
    final timeslider = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        child: Slider(
          activeColor: Colors.red[800],
          inactiveColor: Colors.black,
          min: 15,
          max: 30,
          divisions: 3,
          value: _timeSliderval,
          label: (_timeSliderval.toString() + ' mins'),
          onChanged: (value) {
            setState(() {
              _timeSliderval = value;
            });
          },
        ));
    final startButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[800],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {},
          child: Text(
            "Schedule Reminders",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Hand Wash'),
        centerTitle: true,
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36, 200, 36, 36),
        child: Column(
          children: [
            Text('FREQUENCY OF REMINDERS',
                style: TextStyle(
                    color: Colors.red[800],
                    decoration: TextDecoration.underline)),
            SizedBox(
              height: 20,
            ),
            timeslider,
            SizedBox(
              height: 40,
            ),
            startButton
          ],
        ),
      ),
    );
  }
}
