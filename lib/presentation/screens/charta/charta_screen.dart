import 'package:flutter/material.dart';
import '../../widgets/complere_form.dart';


class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
 State <ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {
  @override
  Widget build(BuildContext context) {
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

  class MenuItem {}
  
