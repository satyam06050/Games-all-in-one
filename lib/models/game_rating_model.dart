class GameRating {
  final String gameId;
  final String gameName;
  final double stars;
  final String emoji;
  final DateTime ratedAt;

  GameRating({
    required this.gameId,
    required this.gameName,
    required this.stars,
    required this.emoji,
    required this.ratedAt,
  });

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'gameName': gameName,
        'stars': stars,
        'emoji': emoji,
        'ratedAt': ratedAt.toIso8601String(),
      };

  factory GameRating.fromJson(Map<String, dynamic> json) => GameRating(
        gameId: json['gameId'],
        gameName: json['gameName'],
        stars: json['stars'],
        emoji: json['emoji'],
        ratedAt: DateTime.parse(json['ratedAt']),
      );
}
