import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final map = new MapController();
  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Coordenadas QR'),
          actions: [
            IconButton(
                  icon: Icon(Icons.my_location), 
                  onPressed: (){
                    map.move(scan.getLatLng(), 15);
                  })
          ],
        ),
        body: _crearFlutterMap(scan),
        floatingActionButton: _crearBotonFlotante(context),
    );
  }

 Widget _crearFlutterMap(ScanModel scan) {
        return FlutterMap(
          mapController: map,
                    options: MapOptions(
                                 center: scan.getLatLng(),
                                 zoom: 15
                      ),
                    layers: [
                        _crearMapa(),
                        _crearMarcadores(scan)
                    ],  
              );
 }

  _crearMapa() {
    return TileLayerOptions(
              urlTemplate: 'https://api.mapbox.com/styles/v1/'
                           'mapbox/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
              additionalOptions: {
                    'accessToken':'pk.eyJ1IjoiYXBvdmVkYWVjIiwiYSI6ImNraDlybTM1ODBnanYyc251YWR5bDBoZGgifQ.AVcpoMev568RvbeeZeVWgQ',
                    'id': '$tipoMapa'
                    //streets-v11, outdoors-v11, light-v10, dark-v10, satellite-v9, satellite-streets-v11
              }
      );
  }

  _crearMarcadores(ScanModel scan) {

    return MarkerLayerOptions(
        markers: [
          Marker(
                width: 100.0,
                height: 100.0,
                point: scan.getLatLng(),
                builder: (context)=> Container(
                  child: Icon(Icons.location_on, size: 70.0, color: Theme.of(context).primaryColor,),
                  ),
            )
        ]
    );

  }

 Widget _crearBotonFlotante(BuildContext context) {
   return FloatingActionButton(
     child: Icon(Icons.repeat),
     backgroundColor: Theme.of(context).primaryColor,
     onPressed: (){
       //streets-v11, outdoors-v11, light-v10, dark-v10, satellite-v9, satellite-streets-v11
       if(tipoMapa == 'streets-v11'){
         tipoMapa = 'dark-v10';
       } else if(tipoMapa == 'dark-v10'){
         tipoMapa = 'light-v10';
       } else if(tipoMapa == 'light-v10'){
         tipoMapa = 'outdoors-v11';
        } else if(tipoMapa == 'outdoors-v11'){
         tipoMapa = 'satellite-v9';
       } else if(tipoMapa == 'satellite-v9'){
         tipoMapa = 'satellite-streets-v11';
       } else {
         tipoMapa = 'streets-v11';
       }
       setState(() {
         
       });
     },
   );
 }
}