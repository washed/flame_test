// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/components/statusbar/health_bar.dart';

class Base extends CircleComponent with CollisionCallbacks {
  static const int maxHealth = 100;
  int health = maxHealth;
  late Healthbar healthbar;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    radius = 10;
    anchor = Anchor.center;
    paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;

    healthbar = Healthbar()
      ..size = Vector2(40, 6)
      ..position = Vector2(width / 2, 0)
      ..anchor = Anchor.center;

    add(CircleHitbox());
    add(healthbar);
  }

  void getHit(Creep creep) {
    debugPrint("Got hit by a creep!");

    health -= creep.baseDamage;
    health = health = health.clamp(0, double.infinity).toInt();

    healthbar.value = health / maxHealth;

    if (health == 0) {
      debugPrint("Game over!");
      // TODO: actually stop the game somehow
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Creep) {
      getHit(other);
    }
  }
}
