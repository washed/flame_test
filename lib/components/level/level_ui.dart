// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/main.dart';

class LevelUI extends PositionComponent with HasGameRef<SpaceShooterGame> {
  final TextComponent waveText = TextComponent(
    text: "",
    position: Vector2(20, 40),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  final TextComponent waveCountdownText = TextComponent(
    text: "",
    position: Vector2(100, 40),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(waveText);
    add(waveCountdownText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.currentLevel != null) {
      final completedWaves = gameRef.currentLevel!.completedWaves;
      final allWavesCount = gameRef.currentLevel!.waves.length;
      waveText.text = "Wave $completedWaves/$allWavesCount";

      final nextWaveTMinus =
          gameRef.currentLevel!.nextWaveTMinus?.toStringAsFixed(2) ?? "...";
      waveCountdownText.text = "Next wave in $nextWaveTMinus s";
    }
  }
}
