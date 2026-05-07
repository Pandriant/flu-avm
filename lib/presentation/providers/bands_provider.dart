
import 'package:flutter_application_1/config/entities/band.dart';
import 'package:flutter_riverpod/legacy.dart';


final BandsProvider = StateNotifierProvider<BandsNotifier, List<Band>> ((ref){
  return BandsNotifier ();
});

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


