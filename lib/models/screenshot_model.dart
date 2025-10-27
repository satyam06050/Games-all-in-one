class ScreenshotModel {
  final String path;
  final DateTime timestamp;

  ScreenshotModel({required this.path, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'path': path,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ScreenshotModel.fromJson(Map<String, dynamic> json) => ScreenshotModel(
    path: json['path'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
