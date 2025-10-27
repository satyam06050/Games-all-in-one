class GameModel {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final bool isAvailable;

  GameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    this.isAvailable = true,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'isAvailable': isAvailable,
    };
  }
}