import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final formNomenProvider = StateProvider((ref) => '');
final formColorProvider = StateProvider<Color>((ref) => Colors.white);

final markerPositumProvider = StateProvider<bool>((ref) => false); // Madrid