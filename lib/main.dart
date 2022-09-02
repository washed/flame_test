// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

// Project imports:
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/creep.dart';
import 'package:flame_test/grid.dart';

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
      GridCoord(9, 9),
    ]);

    final creep1 = Creep()
      ..position = grid.getPositionFromCoords(GridCoord(0, 0))
      ..path = creepPath
      ..startMovingDelay = 2.0;

    await add(creep1);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
