import 'package:flame/events.dart';
import 'package:flame_test/tower.dart';
import 'package:flame_test/player.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  late Tower tower;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();
    tower = Tower(
      target: player,
      fireRange: 200,
      acquisitionRange: 400,
      renderRanges: true,
    );

    add(ScreenHitbox());
    add(player);
    add(tower);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
