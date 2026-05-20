import '../../../presentation/widgets/wirget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../providers/providers.dart';

class ChartaScreen extends ConsumerStatefulWidget{
  const ChartaScreen({super.key});

  @override
  ConsumerState<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends ConsumerState<ChartaScreen> {

  CircleAnnotationManager? _circleAnnotationManager;

  Cancelable? _dragCancelable;
  

  void _initializeCiecleAnnotations(MapboxMap mapBoxMap){
  
    mapBoxMap.annotations.createCircleAnnotationManager().then((manager){
      _circleAnnotationManager = manager;

      _addVelRenovareMarker();
    });
  }

  void _setupDragListener(CircleAnnotationManager manager){
    _dragCancelable?.cancel();

    _dragCancelable = manager.dragEvents(
      onChanged: (CircleAnnotation annotation) {
      final pos = annotation.geometry.coordinates;
      ref.read(coordsMarkerProvider.notifier).state = pos;
    },
      onEnd: (CircleAnnotation annotation) {
      final pos = annotation.geometry.coordinates;
      ref.read(coordsMarkerProvider.notifier).state = pos;
    }
  );
  }

  Future<void> _addVelRenovareMarker() async{
    final manager = _circleAnnotationManager;

    if(manager == null) return;

    await manager.deleteAll();

     _setupDragListener(manager);

    final placed = ref.read(markerPositumProvider);

    if(!placed){
      await manager.deleteAll();
      return;
    }

    final situs = ref.read(coordsMarkerProvider);
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
        debugPrint('Error al crear el marcador: $e');
      }
  }

  @override
    void dispose() {
    _dragCancelable?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(markerPositumProvider, (prev, next) {
      if(next) _addVelRenovareMarker();
    });


    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('main_mapa'),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: initialisMarkerPositio,
              ),
              zoom: 14.5,
            ),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _initializeCiecleAnnotations
          ),
          Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ref.watch(markerPositumProvider)
            ? InformaUsoris(
            nomen: ref.watch(formNomenProvider),
            color: ref.watch(formColorProvider),
            positio: ref.watch(coordsMarkerProvider),
          ) // InformaUsoris
        : const ComplereForm(),
            ), // Padding
          ) // Align
        ],
      ),
    );
  }
}