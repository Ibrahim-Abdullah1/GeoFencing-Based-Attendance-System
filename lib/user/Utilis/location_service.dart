// import 'package:location/location.dart';

// class LocationServices {
//   Location location = Location();
//   late LocationData _locData;

//   Future<void> initialize() async {
//     bool _serviceEnabled;
//     PermissionStatus _permission;

//     _serviceEnabled = await location.serviceEnabled();

//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permission = await location.hasPermission();
//     if (_permission == PermissionStatus.denied) {
//       _permission = await location.requestPermission();
//       if (_permission != PermissionStatus.granted) {
//         return;
//       }
//     }
//   }

//   Future<double?> getlatitude() async {
//     _locData = await location.getLocation();
//     return _locData.latitude;
//   }

//   Future<double?> getlongitude() async {
//     _locData = await location.getLocation();
//     return _locData.longitude;
//   }
// }
