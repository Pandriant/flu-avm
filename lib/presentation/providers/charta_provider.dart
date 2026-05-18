import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final formNomenProvider = StateProvider((ref) => '');
final formColorProvider = StateProvider<Color>((ref) => Colors.white);

final markerPositumProvider = StateProvider<bool>((ref) => false); // Madrid

final Position initialisMarkerPositio = Position( 122.4567895, 37.800126);
final coordsMarkerProvider = StateProvider<Position>((ref) => initialisMarkerPositio);