import 'package:flutter/material.dart';
import '../../widgets/complere_form.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
 


class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
 State <ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {


  void _initializeCircleAnnotations(MapboxMap mapboxmap) {
    // Aquí puedes agregar código para inicializar anotaciones de círculo en el mapa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapas'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('main_map_widget'),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  -122.467895, // Longitud de Nueva York
                  37.800126,  // Latitud de Nueva York
                ),
              ),
              zoom: 14.5,
            ),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _initializeCircleAnnotations
              // Aquí puedes agregar código para interactuar con el mapa una vez que se haya creado
            ,
          ),
          

          const Align(alignment: Alignment.topRight,
          child: Padding(padding: EdgeInsets.all(12),
          child: ComplereForm()
          ),),
          ]
      )
    );
    
  
  }}

  class MenuItem {}
  
