class ModeManager{

  static Mode mode = Mode(game: Game.league);
}

enum Game{
    league,
    deadlock,
    sm64
  }

class Mode{
  Mode({required this.game});

  Game game;
}