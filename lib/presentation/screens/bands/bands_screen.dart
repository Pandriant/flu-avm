import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config/entities/band.dart';
import '../../../config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

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
              return _bandTile(bands[i]);
            
          
          },
        ),
           floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: ()=> addereNovumBand(context),),
    );   
  }
  
  ListTile _bandTile (Band band) {

  return ListTile (

            leading: CircleAvatar(
              child: Text(band.nomen.substring(0,2).toUpperCase()),
            ),
            title: Text (band.nomen),
            trailing: Text('${band.numerusVotum}', style: TextStyle(fontSize: 20),),
            onTap: () {
            },
          );
          }

addereNovumBand(BuildContext context) {

  final TextEditingController textumController = TextEditingController();

 // showDialog(
 //            context: context, 
 //            builder: (context) {
 //             return AlertDialog (
 //                 title: Text('New Band Name'),
 //                 content: TextField (controller: textumController, ),
 //                 actions: [
 //                   MaterialButton(
 //                     onPressed: () => addereBandAdCollecione(context, textumController.text),
 //                     textColor: Colors.blue,
 //                     elevation: 5,
 //                     child: Text('Add'),
 //                     )
 //                 ],
 //             );
 //            },
 //           );

    showCupertinoDialog(
  context: context, 
  builder: ( BuildContext context ) => CupertinoAlertDialog(
    title: const Text('New band name'),
    content:  CupertinoTextField(
      controller: textumController,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white 
          : Colors.black
        )
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Add'),
          onPressed: () {
            addereBandAdCollecione(context, textumController.text);
            context.pop();
          }
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Close'),
          onPressed: () => context.pop()
        ),
      ],
   )
);


        }
  void addereBandAdCollecione (BuildContext context, String nomen) {
      print(nomen);
      context.pop();
  }

}

          
  
