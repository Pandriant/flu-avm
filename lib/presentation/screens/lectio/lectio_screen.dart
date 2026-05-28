import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/providers.dart';
import '../../../services/lectio_service.dart';

class _AeroPalette {
  static const grad1 = Color(0xFF0A7EC2);
  static const grad2 = Color(0xFF1BAEE0);
  static const grad3 = Color(0xFF3ECFA0);
  
  static const categoryColors = {
    'A': Color(0xFFE74C3C),
    'B': Color(0xFFE67E22),
    'C': Color(0xFFF1C40F),
    'D': Color(0xFF2ECC71),
    'E': Color(0xFF3498DB),
    'F': Color(0xFF9B59B6),
  };
}

class LectioScreen extends ConsumerStatefulWidget {
  const LectioScreen({super.key});

  @override
  ConsumerState<LectioScreen> createState() => _LectioScreenState();
}

class _LectioScreenState extends ConsumerState<LectioScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lectioProvider);
    final notifier = ref.read(lectioProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Lectio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Botón de filtros
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterButton(
              onPressed: () => _showFilterDialog(context, notifier, state),
            ),
          ),
          // Botón de refresh
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _GlassButton(
              icon: Icons.refresh_rounded,
              onTap: () => notifier.loadComments(),
              size: 40,
            ),
          ),
        ],
      ),
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [_AeroPalette.grad1, _AeroPalette.grad2, _AeroPalette.grad3],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Stack(
    children: [
      ..._buildBubbles(),  // ✅ CORREGIDO: operador spread
      SafeArea(
        child: Column(
          children: [
            if (state.selectedCategory != 'Todas' || state.selectedHateWord != null)
              _ActiveFilters(
                category: state.selectedCategory,
                hateWord: state.selectedHateWord,
                onClear: () => notifier.resetFilters(),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.comment_rounded, color: Colors.white.withOpacity(0.7), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${state.filteredComments.length} comentarios',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : state.error != null
                      ? _ErrorWidget(error: state.error!, onRetry: () => notifier.loadComments())
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          itemCount: state.filteredComments.length,
                          itemBuilder: (context, index) {
                            final comment = state.filteredComments[index];
                            return _CommentCard(
                              comment: comment,
                              index: index,
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBubbles() {
    return [
      _AeroBubble(left: -40, top: 80, size: 180, opacity: 0.12),
      _AeroBubble(right: -60, top: 200, size: 220, opacity: 0.10),
      _AeroBubble(left: 30, bottom: 120, size: 150, opacity: 0.09),
      _AeroBubble(right: 20, bottom: 300, size: 130, opacity: 0.08),
    ];
  }

  void _showFilterDialog(BuildContext context, LectioNotifier notifier, LectioState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _FilterSheet(
        categories: state.categories,
        hateWords: state.hateWords,
        selectedCategory: state.selectedCategory,
        selectedHateWord: state.selectedHateWord,
        onCategorySelected: (cat) {
          notifier.setCategory(cat);
          Navigator.pop(ctx);
        },
        onHateWordSelected: (word) {
          notifier.setHateWord(word);
          Navigator.pop(ctx);
        },
        onClear: () {
          notifier.resetFilters();
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

class _AeroBubble extends StatelessWidget {
  final double? left, right, top, bottom, size, opacity;
  const _AeroBubble({this.left, this.right, this.top, this.bottom, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left, right: right, top: top, bottom: bottom,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity! * 1.5),
              Colors.white.withOpacity(opacity! * 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _GlassButton({required this.icon, required this.onTap, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.45),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _FilterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        child: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ActiveFilters extends StatelessWidget {
  final String category;
  final String? hateWord;
  final VoidCallback onClear;

  const _ActiveFilters({required this.category, this.hateWord, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Categoría: $category',
            onDeleted: onClear,
          ),
          if (hateWord != null) ...[
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Palabra: $hateWord',
              onDeleted: onClear,
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _FilterChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(Icons.close, color: Colors.white.withOpacity(0.7), size: 14),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final HateComment comment;
  final int index;

  const _CommentCard({required this.comment, required this.index});

  Color _getCategoryColor() {
    return _AeroPalette.categoryColors[comment.category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con categoría y hate word
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Categoría ${comment.category}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white70, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        comment.hateWord,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contenido del comentario
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              comment.comment,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          // Footer decorativo
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white.withOpacity(0.3), size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.white.withOpacity(0.8), size: 48),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _GlassButton(icon: Icons.refresh, onTap: onRetry, size: 50),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final List<String> categories;
  final List<String> hateWords;
  final String selectedCategory;
  final String? selectedHateWord;
  final Function(String) onCategorySelected;
  final Function(String) onHateWordSelected;
  final VoidCallback onClear;

  const _FilterSheet({
    required this.categories,
    required this.hateWords,
    required this.selectedCategory,
    required this.selectedHateWord,
    required this.onCategorySelected,
    required this.onHateWordSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A5580),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtros', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: onClear, child: const Text('Limpiar', style: TextStyle(color: Colors.white70))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categorías', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = cat == selectedCategory;
                      return GestureDetector(
                        onTap: () => onCategorySelected(cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(cat, style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedCategory != 'Todas' && hateWords.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text('Palabras de odio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: hateWords.map((word) {
                        final isSelected = word == selectedHateWord;
                        return GestureDetector(
                          onTap: () => onHateWordSelected(word),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.2)),
                            ),
                            child: Text(word, style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}