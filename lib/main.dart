// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flame_test/grid.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

// Project imports:
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/creep.dart';

class SpaceShooterGame extends FlameGame
    with
        PanDetector,
        HasCollisionDetection,
        HasDraggableComponents,
        HasTappables {
  late GridComponent grid;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = false;

    children.register<Creep>();

    add(ScreenHitbox());

    grid = GridComponent()
      ..edgeSize = 50
      ..nodesHeight = 10
      ..nodesWidth = 10
      ..position = Vector2(0, 80);

    add(grid);

    final addTowerComponent = AddTowerComponent();
    add(addTowerComponent);

    final creepPath = grid.getPathFromCoords([
      GridCoord(0, 0),
      GridCoord(5, 0),
      GridCoord(5, 3),
      GridCoord(2, 3),
      GridCoord(2, 6),
      GridCoord(9, 6),
    ]);

    final creep1 = Creep();

    final creepPathMoveEffect = MoveAlongPathEffect(
      creepPath,
      EffectController(speed: 100),
    );

    creep1.add(creepPathMoveEffect);

    add(creep1);

    /*

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

    addAll([
      creep1,
      creep2,
    ]);
    */
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
