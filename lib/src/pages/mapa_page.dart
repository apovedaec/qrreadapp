import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType tipoMapa = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    final CameraPosition puntoInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 14.4746,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: scan.getLatLng(), zoom: 114.4746)));
              })
        ],
      ),
      body: _crearFlutterMap(scan, puntoInicial),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan, puntoInicial) {
    return GoogleMap(
      mapType: tipoMapa,
      markers: _crearMarcadores(scan),
      initialCameraPosition: puntoInicial,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
    // return FlutterMap(
    //   mapController: map,
    //   options: MapOptions(center: scan.getLatLng(), zoom: 15),
    //   layers: [_crearMapa(), _crearMarcadores(scan)],
    // );
  }

  // _crearMapa() {
  //   return TileLayerOptions(
  //       urlTemplate: 'https://api.mapbox.com/styles/v1/'
  //           'mapbox/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
  //       additionalOptions: {
  //         'accessToken':
  //             'pk.eyJ1IjoiYXBvdmVkYWVjIiwiYSI6ImNraDlybTM1ODBnanYyc251YWR5bDBoZGgifQ.AVcpoMev568RvbeeZeVWgQ',
  //         'id': '$tipoMapa'
  //         //streets-v11, outdoors-v11, light-v10, dark-v10, satellite-v9, satellite-streets-v11
  //       });
  // }

  _crearMarcadores(ScanModel scan) {
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
      markerId: MarkerId('geo-location'),
      position: scan.getLatLng(),
    ));
    return markers;
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.layers),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //streets-v11, outdoors-v11, light-v10, dark-v10, satellite-v9, satellite-streets-v11
        if (tipoMapa == MapType.normal) {
          tipoMapa = MapType.hybrid;
        } else if (tipoMapa == MapType.hybrid) {
          tipoMapa = MapType.satellite;
        } else if (tipoMapa == MapType.satellite) {
          tipoMapa = MapType.terrain;
        } else {
          tipoMapa = MapType.normal;
        }
        setState(() {});
      },
    );
  }
}
