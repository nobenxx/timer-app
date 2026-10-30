class ModeManager{
  ModeManager({required this.mode});

  enum Game{
    league,
    deadlock,
    sm64
  }
  static Mode mode;
}

class Mode{
  Mode({required this.game});

  Game game;
}