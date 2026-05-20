// ignore: library_prefixes, unused_import
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChartaService{
  IO.Socket? _socket;

  void conectare(){
    _socket = IO.io(
      'http://192.168.68.57:3200',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()
    );

    _socket!.onConnect((_) {
     
      _socket!.on("CLIENT_JOINED", (payload){
        //TODO: Al usuario que haya llegado lo meteré en el almacen para verlo en pantalla 
      });

      _socket!.on("CLIENT_LEFT", (payload){
        //TODO: Borraré este usuario del almacen y desaaparecerá de la pantalla
    });

      _socket!.on("CLIENT_MOVED", (payload){
        //TODO: Cambiaré la posición del usuario
      });

       _socket!.on("GET_CLIENTS", (payload){
        //TODO: Le llega la lista de clientes
      });

    });

    _socket!.connect();

  }

  void finire(){
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
  }
}