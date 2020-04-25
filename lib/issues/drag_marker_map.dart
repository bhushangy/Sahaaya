import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';



class DragMarkerMap extends StatefulWidget {
  double whichlat = _DragMarkerMapState.lat;
  double whichlong=_DragMarkerMapState.long;

  @override
  _DragMarkerMapState createState() => _DragMarkerMapState();
}

class _DragMarkerMapState extends State<DragMarkerMap> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller1;

  static const LatLng _center = const LatLng(12.9716, 77.5946);

  Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;
  bool showSpinner=false;


  MapType _currentMapType = MapType.normal;
  static double lat,long;
  Position pos;
  Widget _child;
  Position _currentPosition;
  int i=0;

//void initState(){
//  _getCurrentLocation();
//
//  super.initState();
//}
  //this above method will position a marker when map is opened in the beginning


  void _onAddMarkerButtonPressed() {
    setState(() {

      _markers.add(Marker(
        onDragEnd: ((value){
          lat =value.latitude;
          long=value.longitude;
          Provider.of<DropDown>(context,listen: false).map(lat,long);



        }),
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        draggable: true,
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Marker',
          //snippet: 'Custom Place',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    CameraPosition newPos = CameraPosition(
        target: position.target
    );
    Marker marker = _markers.first;

    setState((){
      _markers.first.copyWith(
          positionParam: newPos.target
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat=_currentPosition.latitude;
        long=_currentPosition.longitude;
        Provider.of<DropDown>(context,listen: false).map(lat,long);

        _markers.add(Marker(
          onDragEnd: ((value){
            lat =value.latitude;
            long=value.longitude;


          }),
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(LatLng(_currentPosition.latitude,_currentPosition.longitude).toString()),
          draggable: true,
          position: LatLng(_currentPosition.latitude,_currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Marker',
            //snippet: 'Custom Place',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: <Widget>[
              GoogleMap(

                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
//               target: LatLng(
//                 pos.latitude,pos.longitude
//               ),
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget> [
                      SizedBox(
                        height: 480,
                      )
                      ,
                      FloatingActionButton(
                        heroTag: "btn3",
                        onPressed:_getCurrentLocation ,

                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.black,
                        child: const Icon(Icons.my_location, size: 36.0),
                      ),
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: _onAddMarkerButtonPressed ,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.add_location, size: 36.0),
                      ),
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: (){Navigator.pop(context);},
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.check, size: 36.0),
                      ),


                    ],
                  ),
                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
}