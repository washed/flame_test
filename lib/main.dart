import 'package:flame/events.dart';
import 'package:flame_test/tower.dart';
import 'package:flame_test/creep.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection, HasDraggables {
  late Creep creep;
  late Creep creep2;
  late Tower tower;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = false;

    creep = Creep();
    creep2 = Creep();
    tower = Tower(
      firingRange: 200,
      acquisitionRange: 400,
    );

    children.register<Creep>();
    children.register<Tower>();

    add(ScreenHitbox());
    add(creep);
    add(creep2);
    add(tower);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
