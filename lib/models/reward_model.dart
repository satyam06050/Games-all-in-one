class DailyReward {
  final int day;
  final int xp;
  final bool claimed;

  DailyReward({required this.day, required this.xp, required this.claimed});

  Map<String, dynamic> toJson() => {'day': day, 'xp': xp, 'claimed': claimed};

  factory DailyReward.fromJson(Map<String, dynamic> json) => DailyReward(
        day: json['day'],
        xp: json['xp'],
        claimed: json['claimed'],
      );
}

class Challenge {
  final String id;
  final String title;
  final String icon;
  final int reward;
  final String rewardType;
  final int current;
  final int target;
  final bool completed;

  Challenge({
    required this.id,
    required this.title,
    required this.icon,
    required this.reward,
    required this.rewardType,
    required this.current,
    required this.target,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'reward': reward,
        'rewardType': rewardType,
        'current': current,
        'target': target,
        'completed': completed,
      };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json['id'],
        title: json['title'],
        icon: json['icon'],
        reward: json['reward'],
        rewardType: json['rewardType'],
        current: json['current'],
        target: json['target'],
        completed: json['completed'],
      );
}
