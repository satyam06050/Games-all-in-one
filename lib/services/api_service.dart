import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_api_model.dart';

class ApiService {
  static const String baseUrl =
      'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/appy/service/smart_game.json';

  static Future<List<GameApiModel>> fetchGames() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        List<GameApiModel> games = [];

        if (jsonData is Map<String, dynamic> &&
            jsonData['status'] == '1' &&
            jsonData.containsKey('data')) {
          final dataList = jsonData['data'] as List;

          for (var category in dataList) {
            if (category['appList'] != null) {
              final appList = category['appList'] as List;
              for (var app in appList) {
                games.add(GameApiModel.fromJson(app));
              }
            }
          }
        }

        return games;
      } else {
        throw Exception('Failed to load games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching games: $e');
    }
  }
}
