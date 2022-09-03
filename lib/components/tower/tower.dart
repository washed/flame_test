// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/tower/bullet.dart';
import 'package:flame_test/components/tower/target_acquisition.dart';
import 'package:flame_test/main.dart';

class Tower extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  static const double angleDeadzone = 0.025;

  final TargetAcquisition targetAcquisition;
  final double fireRate; // 1/s
  final double turnRate; // rad/s

  bool placed = false;

  Tower({
    required this.fireRate,
    required this.turnRate,
    required double firingRange,
    required double acquisitionRange,
  }) : targetAcquisition = TargetAcquisition(
          acquisitionRange: acquisitionRange,
          firingRange: firingRange,
          angleDeadzone: angleDeadzone,
        )..anchor = Anchor.center;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    anchor = Anchor.center;
    width = 25;
    height = 50;

    targetAcquisition.position = Vector2(width / 2, height / 2);

    add(targetAcquisition);
  }

  void turnToTarget(double dt) {
    // TODO: we should probably refactor this into an effect or similar
    final angleError = targetAcquisition.angleErrorToClosestAcquiredTarget();

    if (angleError != null) {
      final solution = targetAcquisition.closestAcquiredTargetInFiringAngle;

      if (!solution) {
        final maxAngleDelta = turnRate * dt;
        final angleDelta = angleError.clamp(-maxAngleDelta, maxAngleDelta);
        angle -= angleDelta;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (placed) {
      turnToTarget(dt);
      maybeShoot(dt);
    }
  }

  double lastShotDt = 0.0;

  void maybeShoot(double dt) {
    if (lastShotDt > 0) {
      lastShotDt -= dt;
    } else if (targetAcquisition.closestAcquiredTargetHasFiringSolution) {
      parent?.add(Bullet(target: targetAcquisition.closestAcquiredTarget!)
        ..position = position
        ..angle = angle);
      lastShotDt = 1 / fireRate;
    }
  }
}
