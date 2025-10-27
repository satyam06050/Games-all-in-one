import 'package:get/get.dart';

class ChessViewModel extends GetxController {
  final board = List.generate(8, (_) => List.filled(8, '')).obs;
  final currentPlayer = 'white'.obs;
  final selectedPiece = Rx<List<int>?>(null);
  final whiteScore = 0.obs;
  final blackScore = 0.obs;
  final winner = ''.obs;
  final whiteEmoji = ''.obs;
  final blackEmoji = ''.obs;
  final emojis = ['😀', '😎', '😡', '🎉', '💪', '😢', '😂', '🔥'].obs;

  void setPlayerEmoji(String player, String emoji) {
    if (player == 'white') {
      whiteEmoji.value = emoji;
    } else {
      blackEmoji.value = emoji;
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (player == 'white') {
        whiteEmoji.value = '';
      } else {
        blackEmoji.value = '';
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    initializeBoard();
  }

  void initializeBoard() {
    board.value = [
      ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'],
      ['♟', '♟', '♟', '♟', '♟', '♟', '♟', '♟'],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
      ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'],
    ];
  }

  void selectSquare(int row, int col) {
    final piece = board[row][col];
    
    if (selectedPiece.value == null) {
      if (piece.isNotEmpty && isPieceOfCurrentPlayer(piece)) {
        selectedPiece.value = [row, col];
      }
    } else {
      final fromRow = selectedPiece.value![0];
      final fromCol = selectedPiece.value![1];
      
      if (row == fromRow && col == fromCol) {
        selectedPiece.value = null;
      } else {
        movePiece(fromRow, fromCol, row, col);
        selectedPiece.value = null;
      }
    }
  }

  bool isPieceOfCurrentPlayer(String piece) {
    if (currentPlayer.value == 'white') {
      return ['♙', '♖', '♘', '♗', '♕', '♔'].contains(piece);
    } else {
      return ['♟', '♜', '♞', '♝', '♛', '♚'].contains(piece);
    }
  }

  void movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    final piece = board[fromRow][fromCol];
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = '';
    currentPlayer.value = currentPlayer.value == 'white' ? 'black' : 'white';
    board.refresh();
  }

  void resetGame() {
    initializeBoard();
    currentPlayer.value = 'white';
    selectedPiece.value = null;
    winner.value = '';
  }
}
