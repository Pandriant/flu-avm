import 'package:flu_avm/config/config.dart';
import 'package:flu_avm/services/pokemon_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pokemonProvider = FutureProvider.family<Pokemon, String>((ref, id) async{
  final (pokemon, error) =  await PokemonServices.getPokemon(id);

  if(pokemon != null) return pokemon;

  throw Exception(error);
});