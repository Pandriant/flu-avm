import 'package:flu_avm/config/config.dart';
import '../../services/charta_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


final formNomenProvider = StateProvider((ref) => '');

final formColorProvider = StateProvider<Color>((ref) => Colors.red);

final markerPositumProvider = StateProvider<bool>((ref) => false);

final Position initialisMarkerPoistio = Position(-122.467895, 37.800126);
final coordsMarkerProvider = StateProvider<Position>((ref) => initialisMarkerPoistio);

final socketServiceProvider = Provider<ChartaService>((ref) {
  final service = ChartaService();

  ref.onDispose(service.finire);
  
  return service;
});


final aliiUsoresProvider = StreamProvider<List<Usor>>((ref) {
  final service = ref.watch(socketServiceProvider);
  return service.usoresStream;
});