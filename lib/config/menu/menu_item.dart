import 'package:flutter/material.dart';

class MenuItem {
  final String titulus;
  final String subtitulus;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.titulus,
    required this.subtitulus,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    titulus: 'Contador',
    subtitulus: 'Introducción a Riverpod',
    link: '/numerator-river',
    icon: Icons.add
  ),
  MenuItem(
    titulus: 'Bandas musicales',
    subtitulus: 'Gráficos PieChart y votaciones',
    link: '/bands',
    icon: Icons.music_note_outlined
  ),
];
