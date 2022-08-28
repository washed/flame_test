import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/tower.dart';
import 'package:flame_test/creep.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection, HasDraggables, HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = false;

    children.register<Creep>();
    children.register<Tower>();

    final addTowerComponent = AddTowerComponent()..position = Vector2(50, 50);
    add(addTowerComponent);

    final creep1 = Creep()
      ..position = Vector2(900, 200)
      ..angle = pi;

    final creepPath = Path();
    creepPath.lineTo(500, 100);
    creepPath.lineTo(500, 500);
    creepPath.lineTo(200, 500);
    creepPath.lineTo(200, 1000);

    final creepPathMoveEffect = MoveAlongPathEffect(
      creepPath,
      EffectController(speed: 100),
    );

    creep1.add(creepPathMoveEffect);

    final creep2 = Creep()
      ..position = Vector2(900, 100)
      ..angle = pi;

    creep2.add(MoveEffect.by(
        Vector2(0, 1000),
        EffectController(
          duration: 10,
          reverseDuration: 10,
          infinite: true,
        )));

    /*
    final tower1 = Tower(
      firingRange: 200,
      acquisitionRange: 250,
    )..position = Vector2(800, 600);

    final tower2 = Tower(
      firingRange: 200,
      acquisitionRange: 250,
    )..position = Vector2(800, 800);
    */

    add(ScreenHitbox());

    addAll([
      creep1,
      creep2,
      // tower1,
      // tower2,
    ]);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
