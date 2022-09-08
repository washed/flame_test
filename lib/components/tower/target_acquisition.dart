// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/main.dart';

class TargetAcquisition extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  final double acquisitionRange;
  final double bulletVelocity;
  final double firingRange;
  final double angleDeadzone;

  late CircleComponent acquisitionRangeCircle;
  late CircleComponent firingRangeCircle;

  List<Creep> orderedAcquiredTargets = [];
  bool _renderRanges = false;

  TargetAcquisition({
    required this.acquisitionRange,
    required this.bulletVelocity,
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

    // for (final orderedAcquiredTarget in orderedAcquiredTargets){}
  }

  double getLeadAngleError(Creep target) {
    final deltaPosition = target.absolutePosition - absolutePosition;

    final targetHeading = Vector2(
      sin(target.absoluteAngle),
      -cos(target.absoluteAngle),
    );

    final losToTargetHeadingAngle = deltaPosition.angleToSigned(targetHeading);

    // double leadTargetDistance = 0.0;
    double angleToLeadTarget = 0.0;
    if (losToTargetHeadingAngle >= 0.0 && losToTargetHeadingAngle < pi / 2) {
      angleToLeadTarget = atan2(target.moveSpeed, bulletVelocity);

      // leadTargetDistance = sin(angleToLeadTarget) * deltaPosition.length;
    } else if (losToTargetHeadingAngle >= pi / 2 &&
        losToTargetHeadingAngle < pi) {
      // TODO: not sure about these radians conversion
      angleToLeadTarget = sin(target.moveSpeed / bulletVelocity * 2 * pi);

      // leadTargetDistance = tan(angleToLeadTarget) * deltaPosition.length;
    } else if (losToTargetHeadingAngle < 0.0 &&
        losToTargetHeadingAngle >= -pi / 2) {
      angleToLeadTarget = -sin(target.moveSpeed / bulletVelocity * 2 * pi);
      // ?
    } else if (losToTargetHeadingAngle < -pi / 2 &&
        losToTargetHeadingAngle >= -pi) {
      angleToLeadTarget = -atan2(target.moveSpeed, bulletVelocity);
      // ?
    }

    // target.leadTarget.position =
    //     Vector2(height / 2, width / 2 + leadTargetDistance);
    return angleToLeadTarget;
  }

  Creep? get closestAcquiredTarget =>
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

      final leadAngleError = getLeadAngleError(closestAcquiredTarget!);
      debugPrint("leadAngleError: $leadAngleError");

      return deltaPosition.angleToSigned(myVector) - leadAngleError;
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
