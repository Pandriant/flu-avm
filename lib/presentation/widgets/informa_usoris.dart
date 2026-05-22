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
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    ///return Text(nomen, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nomen.isEmpty ? '__' : nomen,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text('Lat: ${positio.lat.toStringAsFixed(5)}', style: TextStyle(color: Colors.black54),),
            Text('Lng: ${positio.lng.toStringAsFixed(5)}', style: TextStyle(color: Colors.black54),)
        ],
      ),
    );
  }
}