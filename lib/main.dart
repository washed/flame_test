import 'package:flame/events.dart';
import 'package:flame_test/tower.dart';
import 'package:flame_test/creep.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Creep creep;
  late Tower tower;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // debugMode = true;

    creep = Creep();
    tower = Tower(
      firingRange: 200,
      acquisitionRange: 400,
    );

    children.register<Creep>();
    children.register<Tower>();

    add(ScreenHitbox());
    add(creep);
    add(tower);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    creep.move(info.delta.game);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
