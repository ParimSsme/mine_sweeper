import '../../data/models/board_square.dart';
import '../../data/repositories/game_repository.dart';

class InitializeGame {
  final GameRepository repository;

  InitializeGame(this.repository);

  List<List<BoardSquare>> call() {
    return repository.initializeBoard();
  }
}
