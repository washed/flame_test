// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/creep/creep.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/move_extension.dart';

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

class TargetAcquisition extends PositionComponent
    with HasGameRef<SpaceShooterGame>, ParentIsA<Tower> {
  final double acquisitionRange;
  final double firingRange;
  final double angleDeadzone;

  late CircleComponent acquisitionRangeCircle;
  late CircleComponent firingRangeCircle;

  List<Creep> orderedAcquiredTargets = [];
  bool _renderRanges = false;

  TargetAcquisition({
    required this.acquisitionRange,
    required this.firingRange,
    required this.angleDeadzone,
  }) : assert(acquisitionRange >= firingRange);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;

    acquisitionRangeCircle = CircleComponent(
      radius: acquisitionRange,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke,
    );

    firingRangeCircle = CircleComponent(
      radius: firingRange,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );

    renderRanges = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // The toList() call also effectively creates a copy of the object
    // so we don't modify the component cache later on and screw up our game state.
    final acquiredTargets = gameRef.children.query<Creep>().toList();

    acquiredTargets.retainWhere((element) =>
        (element.absolutePosition - absolutePosition).length <=
        acquisitionRange);

    acquiredTargets.sort((a, b) => (a.absolutePosition - absolutePosition)
        .length
        .compareTo((b.absolutePosition - absolutePosition).length));

    orderedAcquiredTargets = acquiredTargets;
  }

  PositionComponent? get closestAcquiredTarget =>
      orderedAcquiredTargets.isNotEmpty ? orderedAcquiredTargets.first : null;

  bool get closestAcquiredTargetInFiringRange => (closestAcquiredTarget != null)
      ? (closestAcquiredTarget!.absolutePosition - absolutePosition).length <
          firingRange
      : false;

  bool get closestAcquiredTargetInFiringAngle =>
      (angleErrorToClosestAcquiredTarget() != null)
          ? angleErrorToClosestAcquiredTarget()!.abs() < angleDeadzone
          : false;

  bool get closestAcquiredTargetHasFiringSolution =>
      closestAcquiredTargetInFiringRange && closestAcquiredTargetInFiringAngle;

  double? angleErrorToClosestAcquiredTarget() {
    if (closestAcquiredTarget != null) {
      final deltaPosition =
          closestAcquiredTarget!.absolutePosition - absolutePosition;

      final myVector = Vector2(
        sin(absoluteAngle),
        -cos(absoluteAngle),
      );

      return deltaPosition.angleToSigned(myVector);
    }
    return null;
  }

  bool get renderRanges => _renderRanges;

  set renderRanges(bool renderRanges) {
    if (!renderRanges) {
      if (acquisitionRangeCircle.isMounted) {
        acquisitionRangeCircle.add(RemoveEffect());
      }
      if (acquisitionRangeCircle.isMounted) {
        firingRangeCircle.add(RemoveEffect());
      }
    } else {
      if (!acquisitionRangeCircle.isMounted) {
        add(acquisitionRangeCircle);
      }
      if (!acquisitionRangeCircle.isMounted) {
        add(firingRangeCircle);
      }
    }

    _renderRanges = renderRanges;
  }
}

class Bullet extends CircleComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  final PositionComponent target;
  final double velocity;
  static const int damage = 100;

  Bullet({
    required this.target,
    this.velocity = 50.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    radius = 5;
    anchor = Anchor.center;

    paint = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.fill;

    final hitbox = RectangleHitbox();
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
