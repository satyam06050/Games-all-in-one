class GameCategory {
  final String id;
  final String name;
  final String icon;
  final List<String> gameIds;

  GameCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.gameIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'gameIds': gameIds,
      };

  factory GameCategory.fromJson(Map<String, dynamic> json) => GameCategory(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        gameIds: List<String>.from(json['gameIds'] ?? []),
      );
}
