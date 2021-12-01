// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_webservice/places.dart';
//
// class InputLocation extends StatefulWidget {
//   @override
//   State<InputLocation> createState() => InputLocationState();
// }
//
// class InputLocationState extends State<InputLocation> {
//   GoogleMapController mapController;
//   Map<String, Marker> _markers = {};
//
//   Firestore firestore = Firestore.instance;
//   Geoflutterfire geo = Geoflutterfire();
//
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocus = FocusNode();
//   String get _searchText => _searchController.text;
//
//   String _mapSearchErrorText;
//   String _markerLocation = '';
//   GeoPoint _markerPoint;
//
//   Future<void> _showPrediction() async {
//     Prediction prediction = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: 'AIzaSyBhcoax9k-GeiyCxaNvtTfVK2oFOxgdQrw',
//         mode: Mode.overlay, // Mode.fullscreen
//         language: "en",
//         components: [Component(Component.country, "in")]);
//
//     GoogleMapsPlaces _places =
//         new GoogleMapsPlaces(apiKey: 'AIzaSyBhcoax9k-GeiyCxaNvtTfVK2oFOxgdQrw');
//     PlacesDetailsResponse detail =
//         await _places.getDetailsByPlaceId(prediction.placeId);
//     double latitude = detail.result.geometry.location.lat;
//     double longitude = detail.result.geometry.location.lng;
//     //String address = prediction.description;
//
//     _setLocation(latitude, longitude);
//   }
//
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         title: Text('Choose your location'),
//       ),
//       body: Stack(
//         children: <Widget>[
// //              TextField(
// //                decoration: InputDecoration(
// //                  border: OutlineInputBorder(),
// //                  focusColor: Colors.blue,
// //                  labelText: 'Search',
// //                  errorText: _mapSearchErrorText,
// //                  icon: Icon(Icons.search),
// //                ),
// //                focusNode: _searchFocus,
// //                controller: _searchController,
// //                textInputAction: TextInputAction.search,
// //                onEditingComplete: _searchText == '' ? () {} : _searchLocation,
// //                onChanged: (searchText) {
// //                  setState(() {});
// //                },
// //              ),
//           Container(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(20.5937, 78.9629),
//                 zoom: 4,
//               ),
//               onMapCreated: _onMapCreated,
//               markers: Set<Marker>.of(_markers.values),
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: true,
//               onTap: (latLng) =>
//                   _setLocation(latLng.latitude, latLng.longitude),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               border: Border.all(color: petColor,style: BorderStyle.solid,width: 2.0),
//               boxShadow: [
//                 BoxShadow(color: Colors.black26,spreadRadius: 0,offset: Offset(1,3),blurRadius: 4)
//               ],
//             ),
//             child: ListTile(
//               title: Text(_markerLocation,style: TextStyle(fontSize: 18)),
//               leading: Icon(Icons.search,size: 27,color: metColor),
//               onTap: _showPrediction,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           FloatingActionButton(
//             onPressed: _searchText == '' ? _getLocation : _searchLocation,
//             tooltip: 'Get Location',
//             child: _searchText == ''
//                 ? Icon(Icons.my_location)
//                 : Icon(Icons.search),
//             heroTag: null,
//           ),
//           SizedBox(width: 50.0),
//           FloatingActionButton(
//             onPressed: () => submitLocation(context),
//             tooltip: 'Submit Location',
//             backgroundColor: Colors.pink,
//             child: Icon(Icons.done),
//             heroTag: null,
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   void _setLocation(double latitude, double longitude) async {
//     List<Placemark> getLocation =
//         await Geolocator().placemarkFromCoordinates(latitude, longitude);
//     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(latitude, longitude),
//       zoom: 17.0,
//     )));
//     setState(() {
//       _searchController.clear();
//       _searchFocus.unfocus();
//     });
//
//     _placeMarker(
//       latitude: latitude,
//       longitude: longitude,
//       placemark: getLocation[0],
//     );
//   }
//
//   void _searchLocation() async {
//     setState(() {
//       _mapSearchErrorText = null;
//       _searchFocus.unfocus();
//     });
//
//     try {
//       List<Placemark> searchLocation =
//           await Geolocator().placemarkFromAddress(_searchText);
//       print(searchLocation[0].position.toString()); //testing purpose
//       mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(searchLocation[0].position.latitude,
//             searchLocation[0].position.longitude),
//         zoom: 17.0,
//       )));
//       _placeMarker(
//         latitude: searchLocation[0].position.latitude,
//         longitude: searchLocation[0].position.longitude,
//         placemark: searchLocation[0],
//       );
//     } on PlatformException catch (e) {
//       setState(() {
//         if (e.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND' ||
//             e.code == 'ERROR_GEOCODING_ADDRESS') {
//           _mapSearchErrorText = 'Address not found';
//         } else {
//           _mapSearchErrorText = e.message;
//           print(e.message);
//         }
//       });
//     }
//   }
//
//   Future<void> _getLocation() async {
//     try {
//       var currentLocation = await Geolocator()
//           .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//
//       mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(currentLocation.latitude, currentLocation.longitude),
//         zoom: 17.0,
//       )));
//
//       List<Placemark> _placemarkList =
//           await Geolocator().placemarkFromCoordinates(
//         currentLocation.latitude,
//         currentLocation.longitude,
//       );
//
//       _placeMarker(
//         latitude: currentLocation.latitude,
//         longitude: currentLocation.longitude,
//         placemark: _placemarkList[0],
//       );
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   void _placeMarker({double latitude, double longitude, Placemark placemark}) {
//     setState(() {
//       _markerLocation = placemark.name + "," + placemark.subLocality;
//       final marker = Marker(
//         markerId: MarkerId("curr_loc"),
//         position: LatLng(latitude, longitude),
//       );
//       _markers["Current Location"] = marker;
//
//       _markerPoint = GeoPoint(latitude, longitude);
//     });
//   }
//
//   void submitLocation(BuildContext context) {
//     if (_markerPoint != null) {
//       GeoFirePoint point = geo.point(
//           latitude: _markerPoint.latitude, longitude: _markerPoint.longitude);
//       Map<String, dynamic> locationData = {
//         'latitude': _markerPoint.latitude,
//         'longitude': _markerPoint.longitude,
//         'address': _markerLocation
//       };
//       print(
//           "User selected new address which will be returned to previous page on stack" +
//               locationData['address']);
//       Navigator.pop(context, locationData);
//     } else {
//       showPlatformDialog(
//         context: context,
//         builder: (context) {
//           return PlatformAlertDialog(
//             title: Text('Location not Selected'),
//             content: Text('Please select a location to proceed'),
//             actions: <Widget>[
//               PlatformDialogAction(
//                 child: PlatformText('OK'),
//                 onPressed: Navigator.of(context).pop,
//               )
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }
// }
