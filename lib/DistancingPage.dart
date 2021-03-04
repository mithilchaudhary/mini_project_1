import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_proj/authentication_services.dart';
import 'package:mini_proj/data_services.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class DistancingPage extends StatefulWidget {
  final String uid;
  DistancingPage(this.uid);
  @override
  _DistancingPageState createState() => _DistancingPageState(uid);
}

class _DistancingPageState extends State<DistancingPage> {
  //states:  1=scanning,0=stopped
  double _currentSliderval = 1;
  double _timeSliderval = 10;
  Timer t;
  final String uid;
  int statedef = 0;
  bool breached;
  int breaches = 0;
  _DistancingPageState(this.uid);
  Position position;
  @override
  void initState() {
    super.initState();
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Alert',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: (breaches == 0)
                ? Text('No breach currently detected.')
                : (breaches == 1)
                    ? Text('1 breach currently detected.')
                    : Text(
                        breaches.toString() + ' breaches currently detected.'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[800])),
            )
          ],
        );
      },
    );
  }

  void startTimer() {
    t = Timer.periodic(Duration(seconds: _timeSliderval.round()),
        (timer) async {
      await getPos();
      DataService(uid: uid)
          .updateLocation(GeoPoint(position.latitude, position.longitude));
      breaches =
          await DataService(uid: uid).checkBreach(position, _currentSliderval);
      showMyDialog();
    });
  }

  Future<void> getPos() async {
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = p;
      statedef++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (statedef == 1) {
      startTimer();
    }
    final startButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[800],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() {
              statedef = 1;
            });
          },
          child: Text(
            "Start Scan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));

    final stopButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[800],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            t.cancel();
            setState(() {
              statedef = 0;
            });
          },
          child: Text(
            "Stop Scan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));

    final slider = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        child: Slider(
          activeColor: Colors.red[800],
          inactiveColor: Colors.black,
          min: 1,
          max: 3,
          divisions: 4,
          value: _currentSliderval,
          label: (_currentSliderval.toString() + ' m'),
          onChanged: (value) {
            setState(() {
              _currentSliderval = value;
            });
          },
        ));

    final timeslider = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        child: Slider(
          activeColor: Colors.red[800],
          inactiveColor: Colors.black,
          min: 10,
          max: 30,
          divisions: 4,
          value: _timeSliderval,
          label: (_timeSliderval.toString() + ' s'),
          onChanged: (value) {
            setState(() {
              _timeSliderval = value;
            });
          },
        ));

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Distancing Alerts'),
          backgroundColor: Colors.red[800],
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                })
          ],
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(36, 130, 36, 36),
              child: Column(
                children: [
                  Text(
                    'YOUR RECENT POSITION',
                    style: TextStyle(
                        color: Colors.red[800],
                        decoration: TextDecoration.underline),
                  ),
                  Text((position == null)
                      ? ('-° N , ' + '-° E')
                      : (position.latitude.toString() +
                          '° N , ' +
                          position.longitude.toString() +
                          '° E')),
                  SizedBox(
                    height: 20.0,
                  ),
                  (statedef == 0) ? startButton : stopButton,
                  SizedBox(
                    height: 40.0,
                  ),
                  (statedef == 0)
                      ? Text(
                          'DISTANCE TO BE MAINTAINED :',
                          style: TextStyle(color: Colors.red[800]),
                        )
                      : Text(''),
                  (statedef == 0)
                      ? slider
                      : Text('LOOKING FOR BREACHES',
                          style: TextStyle(color: Colors.red[800])),
                  SizedBox(height: 40),
                  (statedef == 0)
                      ? Text(
                          'DURATION BETWEEN SCANS :',
                          style: TextStyle(color: Colors.red[800]),
                        )
                      : Text(''),
                  (statedef == 0) ? timeslider : Text('')
                ],
              )),
        ));
  }
}
