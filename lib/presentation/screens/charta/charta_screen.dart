import 'package:flutter/material.dart';
import '../../widgets/complere_form.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/charta_provider.dart';


class ChartaScreen extends ConsumerStatefulWidget {
  const ChartaScreen({super.key});

  @override
 ConsumerState<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends ConsumerState<ChartaScreen> {



  CircleAnnotationManager? _circleAnnotationManager;

  void _initiareCircleAnnotations(MapboxMap mapboxMap) {
    mapboxMap.annotations.createCircleAnnotationManager().then((manager) {
      
      
      

      _addeVelRenovareMarker();
    }
    );
  }

  Future<void> _addeVelRenovareMarker() async {
    
    final manager = _circleAnnotationManager;
    if (manager == null) return;

    final placed = ref.read(markerPositumProvider);
    if (!placed) {
      await manager.deleteAll();
      return;
    };


    final situs = Position(-0.376, 39.469);
    final color = ref.read(formColorProvider);

    final optiones = CircleAnnotationOptions(
      geometry: Point(coordinates: situs),
      circleColor: color.toARGB32(),
      circleRadius: 14,
      circleStrokeColor: Colors.white.toARGB32(),
      circleStrokeWidth: 2,
      isDraggable: true,

    );

    try {
      await manager.create(optiones);
    } catch (e) {
      print('Error creando la anotación: $e');
    }

  @override
  Widget build(BuildContext context) {


    ref.listen<bool>(markerPositumProvider, (previous, next) {
      if (next == true) {
        _addeVelRenovareMarker();
      }
    });


    return Scaffold(
      appBar: AppBar(
        title: Text('Mapas'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Colors.blueGrey,
          child: Center(
            child: Text(
              'Mapa a pantalla completa ',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          )
        
    ),
        

        Align(alignment: Alignment.topRight,
        child: Padding(padding: EdgeInsets.all(12),
        child: ComplereForm()
        ),),
        ]
      )
    );
    
  
  }}
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  
  
}