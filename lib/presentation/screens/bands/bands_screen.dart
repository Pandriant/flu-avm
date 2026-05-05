import 'package:flutter/material.dart';

import '../../../config/config.dart';

class BandsScreen extends StatelessWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bandas'),
        ),
        body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) {
              return ListTile(
            leading: CircleAvatar(
              child: Text(bands[i].nomen.substring(0,2).toUpperCase()),
            ),
          );
          },
        )   
    );
    
    
  }
}