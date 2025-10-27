import '../models/game_model.dart';

class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  Future<List<GameModel>> getGames() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      GameModel(
        id: '1',
        name: 'Tic Tac Toe',
        description: 'Classic 3x3 grid game',
        imagePath: 'assets/images/tictactoe.png',
      ),
      GameModel(
        id: '2',
        name: 'Snake Game',
        description: 'Classic snake eating game',
        imagePath: 'assets/images/snake.png',
      ),
    ];
  }
}