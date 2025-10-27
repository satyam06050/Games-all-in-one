class GameApiModel {
  final String name;
  final String url;
  final String icon;
  
  String get id => name;

  GameApiModel({required this.name, required this.url, required this.icon});

  factory GameApiModel.fromJson(Map<String, dynamic> json) {
    return GameApiModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      icon: json['appIcon'] ?? '🎮',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'icon': icon};
  }
}
