import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flutter/material.dart';

class PlaceTowerButton extends ButtonComponent
    with HasGameRef, ComponentViewportMargin, ParentIsA<AddTowerComponent> {
  static TextComponent buttonText = TextComponent(text: "Place tower");
  static RectangleComponent buttonComponent = RectangleComponent(
      size: Vector2(200, 50),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.blue,
      children: [buttonText]);
  static RectangleComponent buttonDownComponent = buttonComponent
    ..paint.color = Colors.red;

  PlaceTowerButton()
      : super(
          button: buttonComponent,
          buttonDown: buttonDownComponent,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    onPressed = pressed;
  }

  void pressed() {
    if (parent.newTower != null) {
      parent.newTower!.placed = true;
      parent.newTower = null;
      add(RemoveEffect());
    }
  }
}
