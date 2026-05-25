import 'package:dio/dio.dart';
import 'package:flu_avm/mapper/pokemon_mapper.dart';

class PokemonServices {
  static getPokemon<String>(String pokemonId) async{

    final dio = Dio();

    try {
      final responsio = await dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonId');

      final pokemon = PokemonMapper.pokeApiPokemonToEntity(responsio.data);
      return (pokemon, 'Data obtenida correctamente');
     
    } catch (e) {
     
      return (null, 'Error al obtener los datos');

    }
  }
}