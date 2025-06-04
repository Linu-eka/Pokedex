class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String? userImagePath;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.userImagePath,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      userImagePath: json['userImagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'userImagePath': userImagePath,
    };
  }
}