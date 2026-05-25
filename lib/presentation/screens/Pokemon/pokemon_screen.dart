import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";


class PokemonScreen extends StatelessWidget {
  final String pokemon_id;
  const PokemonScreen({
    required this.pokemon_id,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nombre del Pokemon'),
      ),
      body: Text('Datos del Pokemon $pokemon_id', style: GoogleFonts.russoOne(fontSize: 22) ),
    );
  }
}