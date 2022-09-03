// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

// Project imports:
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/creep/creep.dart';
import 'package:flame_test/grid.dart';
import 'package:flame_test/level_ui.dart';
import 'package:flame_test/levels/level.dart';
import 'package:flame_test/levels/level_1.dart';

class SpaceShooterGame extends FlameGame
    with
        PanDetector,
        HasCollisionDetection,
        HasDraggableComponents,
        HasTappables {
  late GridComponent grid;
  late Level currentLevel;

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

    final levelUI = LevelUI();
    add(levelUI);

    currentLevel = level_1;
    add(level_1);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
