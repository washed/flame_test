// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/main.dart';

class EnergyUI extends PositionComponent with HasGameRef<SpaceShooterGame> {
  final TextComponent energyText = TextComponent(
    text: "",
    position: Vector2(20, 60),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(energyText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    energyText.text = "Total Power: ${gameRef.energy.netPower}";
  }
}
