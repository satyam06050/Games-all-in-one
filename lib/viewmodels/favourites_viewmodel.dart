import 'package:get/get.dart';
import '../models/game_api_model.dart';

class FavouritesViewModel extends GetxController {
  final favouriteGames = <GameApiModel>[].obs;

  void addToFavourites(GameApiModel game) {
    if (!favouriteGames.contains(game)) {
      favouriteGames.add(game);
    }
  }

  void removeFromFavourites(GameApiModel game) {
    favouriteGames.remove(game);
  }

  bool isFavourite(GameApiModel game) {
    return favouriteGames.contains(game);
  }
}