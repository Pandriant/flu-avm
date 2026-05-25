import 'package:dio/dio.dart';

class PokemonServices {
  static getPokemon<String>(String pokemonId) async{

    final dio = Dio();

    try {
      final responsio = await dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonId');
     
    } catch (e) {
     
    }
  }
}