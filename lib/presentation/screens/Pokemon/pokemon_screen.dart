import "package:flu_avm/config/config.dart";
import "package:flu_avm/presentation/providers/providers.dart";
import "package:flu_avm/presentation/screens/screens.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";


class PokemonScreen extends ConsumerWidget {
  final String pokemon_id;
  const PokemonScreen({
    required this.pokemon_id,
    super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pokemonAsync = ref.watch(pokemonProvider(pokemon_id));  

    return pokemonAsync.when(
      data: (pokemon) => _PokemonVisum(pokemon: pokemon), 
      error: (error, stackTrace) => _ErrorWidget(nuntius: error.toString()), 
      loading: ()=> _LoadingWidget());
  }
}

class _PokemonVisum extends StatelessWidget {

  final Pokemon pokemon;

  const _PokemonVisum({
    required this.pokemon
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nomen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            Text('Sus habilidades son:', style: GoogleFonts.russoOne(fontSize: 20),),
            Text(pokemon.facultates.join(', '), style: GoogleFonts.russoOne(fontSize: 22),),
            Image.network(pokemon.faciemImaginem ?? '',
            fit: BoxFit.contain,
            width: 300,
            height: 300,),
            SizedBox(
              height: 15,
              
            ),
            Text('Mide ${pokemon.altitudo/10}m. y pesa ${pokemon.pondus/10}kg. ', 
            style: GoogleFonts.russoOne(fontSize: 22),)
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final nuntius;
  const _ErrorWidget({
    required this.nuntius
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $nuntius'),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}