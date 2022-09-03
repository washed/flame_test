// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

// Project imports:
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/base.dart';
import 'package:flame_test/creep/creep.dart';
import 'package:flame_test/creep_spawner.dart';
import 'package:flame_test/grid.dart';

class SpaceShooterGame extends FlameGame
    with
        PanDetector,
        HasCollisionDetection,
        HasDraggableComponents,
        HasTappables {
  late GridComponent grid;
  late Base base;
  late CreepSpawner creepSpawner;

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

    base = Base()..position = grid.getPositionFromCoords(GridCoord(9, 9));
    add(base);

    final pathGridCoords = [
      GridCoord(0, 0),
      GridCoord(5, 0),
      GridCoord(5, 3),
      GridCoord(2, 3),
      GridCoord(2, 6),
      GridCoord(9, 6),
      GridCoord(9, 9),
    ];

    final interpolateGridCoords = grid.interpolateGridCoords(pathGridCoords);

    for (final pathGridCoord in interpolateGridCoords) {
      final node = grid.getGridNode(pathGridCoord);
      node.paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.blueGrey.withOpacity(0.5);
      node.buildable = false;
    }

    final creepPath = grid.getPathFromCoords(pathGridCoords);

    creepSpawner = CreepSpawner()
      ..firstSpawnDelay = 5.0
      ..creepCount = 10
      ..creepPath = creepPath
      ..gridPosition = GridCoord(0, 0)
      ..spawnPeriod = 0.5;

    add(creepSpawner);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
