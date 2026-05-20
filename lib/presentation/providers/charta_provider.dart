import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../services/charta_service.dart';


// Init var
final Position initialisMarkerPositio = Position(-122.467895, 37.800126);


//Providers
final formColorProvider = StateProvider<Color>((ref) => Colors.red);
final formNomenProvider = StateProvider<String>((ref) => '');
final markerPositumProvider = StateProvider<bool>((ref) => false);
final coordsMarkerProvider = StateProvider<Position>((ref) => initialisMarkerPositio);
final socketServiceProvider = Provider<ChartaService>((ref) {
  final service = ChartaService();
 
  ref.onDispose(service.finire);
  return service; 
});