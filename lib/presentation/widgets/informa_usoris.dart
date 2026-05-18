import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class InformaUsoris extends StatelessWidget {

  final String nomen;
  final Position positio;
  final Color color;

  const InformaUsoris({
    super.key,
    required this.nomen,
    required this.positio,
    required this.color });

  @override
  Widget build(BuildContext context) {
    return Container (
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text( nomen.isEmpty ? '____' : nomen, 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
           ),
           const SizedBox(height: 6),
           Text('Lat: ${positio.lat.toStringAsFixed(5)}, Lng: ${positio.lng.toStringAsFixed(5)}', style: TextStyle(color: Colors.black54),)
        ]
            )
      );

  }
}