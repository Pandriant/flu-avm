import 'package:flutter_riverpod/legacy.dart';
import '../../config/config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;



enum ServerStatus{
  Online, Offline, Connecting
}
final bandsProvider = StateNotifierProvider<BandsNotifier,BandsState>((ref){
  return BandsNotifier();
});

class BandsState {
  final ServerStatus serverStatus;
  final IO.Socket socket;
  final List<Band> bands;

  BandsState({
    required this.serverStatus,
    required this.socket,
    required this.bands
  });

  BandsState copyWith({
    ServerStatus? serverStatus,
    IO.Socket? socket,
    List<Band>? bands 
  }){
    return BandsState(
      serverStatus: serverStatus ?? this.serverStatus, 
      socket: socket ?? this.socket, 
      bands: bands ?? this.bands);
  }
}

class BandsNotifier extends StateNotifier<BandsState>{
  BandsNotifier() : super(BandsState(
  serverStatus: ServerStatus.Connecting,
  socket: IO.io("http://192.168.68.50:3000", IO.OptionBuilder()
  .setTransports(["websocket"])
  .enableAutoConnect()
  .build()
  ),
  bands: []
  )) {
    _initConfig();
  }

  void _initConfig(){

    state.socket.onConnect((_){
      state = state.copyWith(serverStatus: ServerStatus.Online);
    });

    state.socket.onDisconnect((_){
      state = state.copyWith(serverStatus: ServerStatus.Offline);
    });

    state.socket.on('BANDS_LIST', (payload){
      final bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      state = state.copyWith(bands: bands);
    });
  }
    void addereBand(String nomen) {
      if (nomen.length > 1) {
        state.socket.emit('ADD_BAND', {'nomen': nomen});
      }
    }

    void delereBand(String id) {
      state.socket.emit('DELETE_BAND', {'id': id});
    }

    void addereVotum(String id) {
      state.socket.emit('VOTE_BAND', {'id': id});
    }
    
  
}

/*class BandsNotifier extends StateNotifier<List<Band>>{
  
  //Esto es el state
  BandsNotifier() : super([
    Band(id: '1', nomen: 'Quien', numerusVotum: 4),
    Band(id: '2', nomen: 'Bronzalica', numerusVotum: 2),
    Band(id: '3', nomen: 'Bon Juani', numerusVotum: 8),
    Band(id: '4', nomen: 'MILKA', numerusVotum: 1)
  ]);

  void addereBand(Band band){
    state = [...state, band];
  }

  void delereBand(Band band){
    state = state.where((b) => b.id != band.id ).toList();
  }

  void addereVotum(Band band){
    state = state.map((b) {
      return b.id == band.id 
        ? b.copyWith(numerusVotum: b.numerusVotum + 1)  
        : b;
    }).toList();
  }
}*/