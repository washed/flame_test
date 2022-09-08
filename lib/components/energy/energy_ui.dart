// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/main.dart';

class EnergyUI extends PositionComponent with HasGameRef<SpaceShooterGame> {
  final TextComponent basePowerText = TextComponent(
    text: "",
    position: Vector2(0, 0),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  final TextComponent chargePowerText = TextComponent(
    text: "",
    position: Vector2(0, 20),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  final TextComponent totalPowerText = TextComponent(
    text: "",
    position: Vector2(0, 40),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.blue),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(basePowerText);
    add(chargePowerText);
    add(totalPowerText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    basePowerText.text =
        "Base Power: ${gameRef.energy.totalBaseConsumption} / ${gameRef.energy.generation}";
    chargePowerText.text =
        "Charge Power: ${gameRef.energy.totalChargeConsumption} / ${gameRef.energy.netBasePower}";
    totalPowerText.text =
        "Total Power: ${gameRef.energy.netTotalPower} / ${gameRef.energy.generation}";
  }
}
