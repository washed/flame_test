// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/creep.dart';
import 'package:flame_test/healthbar.dart';

class Base extends CircleComponent with CollisionCallbacks {
  static const int maxHealth = 1000;
  int health = maxHealth;
  late Healthbar healthbar;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    radius = 10;
    anchor = Anchor.center;

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

    healthbar.health = health / maxHealth;

    if (health == 0) {
      debugPrint("Game over!");
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
