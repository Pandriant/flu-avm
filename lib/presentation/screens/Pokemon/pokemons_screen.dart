import "package:flu_avm/presentation/providers/providers.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PokemonsVisum(),
    );
  }
}

class PokemonsVisum extends ConsumerStatefulWidget {
  const PokemonsVisum({super.key});

  @override
  ConsumerState<PokemonsVisum> createState() => _PokemonsVisumState();
}

class _PokemonsVisumState extends ConsumerState<PokemonsVisum> {
  bool oneratusEst = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels + 200 >
          scrollController.position.maxScrollExtent) {
        vadeProximaPagina();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A7EC2), Color(0xFF1BAEE0), Color(0xFF3ECFA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          // AppBar Aero
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.30),
                    width: 1,
                  ),
                ),
              ),
            ),
            title: const Text(
              'Pokémon',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          // Grid
          const _PokemonGrid(),
          // Padding inferior
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Future<void> vadeProximaPagina() async {
    if (oneratusEst) return;
    oneratusEst = true;
    ref.read(pokemonIdsProvider.notifier).update(
          (state) => [
            ...state,
            ...List.generate(30, (index) => state.length + index + 1),
          ],
        );
    oneratusEst = false;
    movereScrollAdDescendit();
  }

  void movereScrollAdDescendit() {
    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(
      scrollController.position.pixels + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}

class _PokemonGrid extends ConsumerWidget {
  const _PokemonGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonIds = ref.watch(pokemonIdsProvider);

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: pokemonIds.length,
        itemBuilder: (context, index) {
          return _PokemonCard(index: index);
        },
      ),
    );
  }
}

class _PokemonCard extends StatefulWidget {
  final int index;
  const _PokemonCard({required this.index});

  @override
  State<_PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<_PokemonCard> {
  bool _pressed = false;

  // Gradientes rotativos Aero por índice
  static const _gradients = [
    [Color(0xFF1B9FD8), Color(0xFF0D6EA8)],
    [Color(0xFF27C48A), Color(0xFF0F8F63)],
    [Color(0xFF5B8FE8), Color(0xFF2E5CC4)],
    [Color(0xFF39C9B0), Color(0xFF1A8E7A)],
    [Color(0xFF60B8F0), Color(0xFF1E7FC4)],
    [Color(0xFF4DD9A0), Color(0xFF1CA872)],
  ];

  List<Color> get _gradient =>
      _gradients[widget.index % _gradients.length];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/request/${widget.index + 1}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _gradient[0].withOpacity(0.45),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Reflejo gloss superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.28),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Burbuja decorativa
                Positioned(
                  right: -12,
                  bottom: -12,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // Imagen del Pokémon
                Center(
                  child: Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.index + 1}.png",
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none, // pixel art nítido
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Número del Pokémon
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '#${widget.index + 1}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}