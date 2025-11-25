class Pokemon {
  final int id;
  final String name;
  final List<String> types;

  Pokemon({required this.id, required this.name, required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
    );
  }
}
