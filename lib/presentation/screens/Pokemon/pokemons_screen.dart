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

    scrollController.addListener((){
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent){
        vadeProximaPagina();
      }
    });
    
    super.initState();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          title: Text('Pokemon'),
          floating: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
        ),
        _PokeonGrid(),
      ]
    );
  }

  Future vadeProximaPagina() async{

    if(oneratusEst) return;

    oneratusEst = true;

    ref.read(pokemonIdsProvider.notifier).update((state)=>[
      ...state,
      ...List.generate(30, (index) => state.length + index + 1)
    ]);
    oneratusEst = false;

    movereScrollAdDescendit();
  }

  void movereScrollAdDescendit(){
    if(scrollController.position.pixels + 100 <= scrollController.position.maxScrollExtent) return;
   
    scrollController.animateTo(
      scrollController.position.pixels + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn
    );
    
  }

}

class _PokeonGrid extends ConsumerWidget {
  const _PokeonGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pokemonIds = ref.watch(pokemonIdsProvider);
    
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2, 
        ),
      itemCount: pokemonIds.length  ,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push('/request/${index + 1}');
          },
          child: Image.network(
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png",
            fit: BoxFit.contain,
),
        );
      },
    );
  }
}