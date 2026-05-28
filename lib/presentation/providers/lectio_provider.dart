// lib/presentation/providers/lectio_provider.dart
import '../../services/lectio_service.dart';
import 'package:flutter_riverpod/legacy.dart';

class LectioState {
  final List<HateComment> comments;
  final bool isLoading;
  final String? error;
  final String selectedCategory;
  final String? selectedHateWord;

  LectioState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'Todas',
    this.selectedHateWord,
  });

  LectioState copyWith({
    List<HateComment>? comments,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? selectedHateWord,
  }) {
    return LectioState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedHateWord: selectedHateWord,
    );
  }

  List<HateComment> get filteredComments {
    if (selectedCategory == 'Todas' && selectedHateWord == null) {
      return comments;
    }
    
    return comments.where((comment) {
      if (selectedCategory != 'Todas' && comment.category != selectedCategory) {
        return false;
      }
      if (selectedHateWord != null && comment.hateWord != selectedHateWord) {
        return false;
      }
      return true;
    }).toList();
  }

  List<String> get categories {
    final cats = {'Todas'};
    for (final comment in comments) {
      if (comment.category.isNotEmpty) {
        cats.add(comment.category);
      }
    }
    return cats.toList();
  }

  List<String> get hateWords {
    final words = <String>{};
    for (final comment in comments) {
      if (selectedCategory == 'Todas' || comment.category == selectedCategory) {
        words.add(comment.hateWord);
      }
    }
    return words.toList();
  }
}

class LectioNotifier extends StateNotifier<LectioState> {
  LectioNotifier() : super(LectioState()) {
    loadComments();
  }

  Future<void> loadComments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final comments = await LectioService.loadComments();
      state = state.copyWith(comments: comments, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar los comentarios: $e',
      );
    }
  }

  void setCategory(String category) {
    state = state.copyWith(
      selectedCategory: category,
      selectedHateWord: null,
    );
  }

  void setHateWord(String? hateWord) {
    state = state.copyWith(selectedHateWord: hateWord);
  }

  void resetFilters() {
    state = state.copyWith(
      selectedCategory: 'Todas',
      selectedHateWord: null,
    );
  }
}

final lectioProvider = StateNotifierProvider<LectioNotifier, LectioState>((ref) {
  return LectioNotifier();
});