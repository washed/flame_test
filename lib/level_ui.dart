// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/main.dart';

class LevelUI extends PositionComponent with HasGameRef<SpaceShooterGame> {
  final TextComponent waveText = TextComponent(
    text: "bla",
    position: Vector2(100, 50),
    anchor: Anchor.center,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(waveText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    waveText.text =
        "${gameRef.currentLevel.completedWaves}/${gameRef.currentLevel.waves.length}";
  }
}
