import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/tower.dart';
import 'package:flutter/foundation.dart';

class Player extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const int maxHealth = 1000;
  int health = maxHealth;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    position = gameRef.size / 2;
    width = 50;
    height = 100;
    anchor = Anchor.center;

    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void getHit(int damage) {
    health -= damage;
    if (health <= 0) {
      health = 0;
      debugPrint("I'm dead!");
      add(RemoveEffect());
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    if (other is Bullet) {
      debugPrint("Got hit by a bullet!");
      getHit(Bullet.damage);
    }
  }
}
