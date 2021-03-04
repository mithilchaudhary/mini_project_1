import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DataService {
  final String uid;

  DataService({this.uid});
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  Future updateLocation(GeoPoint geoPoint) async {
    return await _collectionReference.doc(uid).set({'loc': geoPoint});
  }

  Future<int> checkBreach(Position p, double min) async {
    int b = 0;
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GeoPoint o = doc.data()['loc'];
        double d = Geolocator.distanceBetween(
            p.latitude, p.longitude, o.latitude, o.longitude);

        if (d < min && d > 0) {
          b++;
        }
      });
    });
    return b;
  }
}
