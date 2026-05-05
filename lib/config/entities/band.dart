class Band {
  String id;
  String nomen;
  int numerusVotum;

  Band({
    required this.id,
    required this.nomen,
    required this.numerusVotum
  });
}

List<Band> bands = [
  Band(id: '1', nomen: 'Alvin y las Ardillas', numerusVotum: 5),
  Band(id: '2', nomen: 'Babymetal', numerusVotum: 12),
  Band(id: '3', nomen: 'Limp Bizkit', numerusVotum: 7),
  Band(id: '4', nomen: 'The Cardigans', numerusVotum: 3),
];