// lib/services/lectio_service.dart
import 'package:flutter/services.dart';

class HateComment {
  final String category;
  final String hateWord;
  final String comment;

  HateComment({
    required this.category,
    required this.hateWord,
    required this.comment,
  });
}

class LectioService {
  static Future<List<HateComment>> loadComments() async {
    try {
      final String content = await rootBundle.loadString('assets/logs/combined.log');
      return _parseComments(content);
    } catch (e) {
      print('Error loading combined.log: $e');
      return [];
    }
  }

  static List<HateComment> _parseComments(String content) {
    final List<HateComment> comments = [];
    final lines = content.split('\n');
    
    String currentCategory = '';
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      // Detectar categoría
      if (line.startsWith('categoría:') || line.startsWith('categoría:') || line.startsWith('HATE WORD')) {
        // Extraer categoría
        if (line.contains('categoría:')) {
          currentCategory = line.replaceAll('categoría:', '').trim();
        }
        
        // Buscar Hate Word en la misma línea o siguiente
        String hateWord = '';
        String comment = '';
        
        if (line.contains('Hate Word:') || line.contains('HATE WORD:')) {
          // Extraer hate word
          final hateIndex = line.indexOf(RegExp(r'Hate Word:|HATE WORD:'));
          if (hateIndex != -1) {
            hateWord = line.substring(hateIndex).replaceAll(RegExp(r'Hate Word:|HATE WORD:'), '').trim();
          }
          
          // Buscar comment en línea siguiente
          if (i + 1 < lines.length && lines[i + 1].trim().startsWith('Comment:')) {
            comment = lines[i + 1].trim().replaceAll('Comment:', '').trim();
            i++; // Saltar la línea del comment
          }
        } else if (line.contains('Comment:')) {
          comment = line.replaceAll('Comment:', '').trim();
          // Buscar hate word en línea anterior
          if (i - 1 >= 0 && (lines[i - 1].contains('Hate Word:') || lines[i - 1].contains('HATE WORD:'))) {
            final hateLine = lines[i - 1];
            final hateIndex = hateLine.indexOf(RegExp(r'Hate Word:|HATE WORD:'));
            if (hateIndex != -1) {
              hateWord = hateLine.substring(hateIndex).replaceAll(RegExp(r'Hate Word:|HATE WORD:'), '').trim();
            }
          }
        }
        
        if (hateWord.isNotEmpty && comment.isNotEmpty) {
          comments.add(HateComment(
            category: currentCategory.isNotEmpty ? currentCategory : 'General',
            hateWord: hateWord,
            comment: comment,
          ));
        }
      }
    }
    
    return comments;
  }
}