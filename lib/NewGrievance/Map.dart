import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';



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
      _markers.clear();

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
        target: position.target,

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
    setState(() {
      _controller1=controller;
    });

  }
  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }
  _getCurrentLocation() async{
    _markers.clear();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    setState(() {
      showSpinner=true;
    });
    await geolocator
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

        setState(() {
          showSpinner=false;
        });
        _gotoLocation(lat, long);
      });
    }).catchError((e) {
      print(e);
    });
  }
  void _showDialog(
      String a,
      String b,
      ) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4),
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            fontSize:SizeConfig.safeBlockHorizontal*4,
            color: Colors.black,
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK",style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showDialog2(
      String a,
      String b,
      ) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black,
              fontSize:SizeConfig.safeBlockHorizontal*5
          ),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            color: Colors.black,
              fontSize:SizeConfig.safeBlockHorizontal*4

          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CONTINUE",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.pop(context);
                _getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
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
                    zoom: 10.0,
                  ),
                  mapType: _currentMapType,
                  markers: _markers,
                  onCameraMove: _onCameraMove,
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget> [
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 62,

                        )
                        ,
                        FloatingActionButton(
                          heroTag: "btn3",
                          onPressed:()async{
                            bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
                            if(isLocationEnabled==false)
                              _showDialog("Location Detection Alert", "Please turn on GPS(Location) service.");
                            else

                            _showDialog2("Note", "To drag the marker, long press on it and drag.");
                          },

                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.my_location, size: SizeConfig.safeBlockHorizontal*8),
                        ),

                        SizedBox(height: SizeConfig.safeBlockVertical*2 ),
                        FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: (){Navigator.pop(context);},
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, size: SizeConfig.safeBlockHorizontal*8),
                        ),

                      ],
                    ),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}