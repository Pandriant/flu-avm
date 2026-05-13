import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/config/entities/band.dart';
import 'package:flutter_riverpod/legacy.dart';


enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

final bandsProvider = StateNotifierProvider<BandsNotifier, BandState> ((ref){
  return BandsNotifier ();
});

class BandState{
  final ServerStatus serverStatus;
  final IO.Socket socket;
  final List<Band> bands;

  BandState({
    required this.serverStatus,
    required this.socket,
    required this.bands,
  });

  BandState copyWith({
    ServerStatus? serverStatus,
    IO.Socket? socket,
    List<Band>? bands,
  }) => BandState(
    serverStatus: serverStatus ?? this.serverStatus,
    socket: socket ?? this.socket,
    bands: bands ?? this.bands,
  );
}

class BandsNotifier extends StateNotifier<BandState> {
  BandsNotifier() : super(BandState(
    serverStatus: ServerStatus.Connecting,
    socket: IO.io(
      'http://10.236.15.161:3000',
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build()), 
    bands: [],

  )) {
    _initConfig();
  }

  void _initConfig() {
    state.socket.onConnect((_) {
      state = state.copyWith(serverStatus: ServerStatus.Online);
    });

    state.socket.onDisconnect((_) {
      state = state.copyWith(serverStatus: ServerStatus.Offline);
    });

    state.socket.on('BANDS_LIST', (payload) {
      final bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      state = state.copyWith(bands: bands);
    });
  }
  
  void AddereBand(String nomen) {
    if (nomen.length > 1) {
      state.socket.emit('ADDERE_BAND', {'nomen': nomen});
    }

  }

  void addereVotum(String id) {
    state.socket.emit('ADDERE_VOTUM', {'id': id});
  }

  void delereBand(String id) {
    state.socket.emit('DELERE_BAND', {'id': id});
  }
  

/*
class BandsNotifier extends StateNotifier <List<Band>>{

  BandsNotifier(): super ([
     Band(id: '1', nomen: 'Alvin y las Ardillas', numerusVotum: 5),
  Band(id: '2', nomen: 'Babymetal', numerusVotum: 12),
  Band(id: '3', nomen: 'Limp Bizkit', numerusVotum: 7),
  Band(id: '4', nomen: 'The Cardigans', numerusVotum: 3),

  ]);

  void addereBand(Band band) {
    state = [... state, band];
  }

  void delereBand (Band band) {
    state = state.where((b) => b.id != band.id).toList();
  }

  void addereVotum (Band band) {
    state = state.map ((b) {
      return b.id == band.id
      ? b.copyWith(numerusVotum: b.numerusVotum + 1)
      : b;
      }).toList();
    }
  }
  */
}