// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/util/move_extension.dart';

class Bullet extends CircleComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  final PositionComponent target;
  final double velocity;
  static const int damage = 100;

  Bullet({
    required this.target,
    required this.velocity,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    radius = 2.5;
    anchor = Anchor.center;
    paint = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.fill;

    final hitbox = CircleHitbox.relative(0.9, parentSize: size);
    add(hitbox);

    final moveEffect = MoveInDirectionEffect(
      target.position - position,
      EffectController(
        speed: velocity,
        infinite: true,
      ),
    );
    add(moveEffect);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      add(RemoveEffect());
    } else if (other is Creep) {
      debugPrint("Hit creep!");
      add(RemoveEffect());
    }
  }
}
