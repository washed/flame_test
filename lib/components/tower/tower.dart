// Package imports:
import 'package:flame/components.dart';
import 'package:flame_test/components/statusbar/charge_bar.dart';

// Project imports:
import 'package:flame_test/components/tower/bullet.dart';
import 'package:flame_test/components/tower/target_acquisition.dart';
import 'package:flame_test/main.dart';

class Tower extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  static const double angleDeadzone = 0.025;

  final TargetAcquisition targetAcquisition;
  final double turnRate; // rad/s
  final double baseConsumption;
  final double chargeConsumption;
  final double chargeEnergy;

  late ChargeBar _chargeBar;

  double _chargedEnergy = 0.0;

  bool placed = false;
  bool _powered = false;

  bool get powered => _powered;

  Tower({
    required this.turnRate,
    required this.baseConsumption,
    required this.chargeConsumption,
    required this.chargeEnergy,
    required double firingRange,
    required double acquisitionRange,
  }) : targetAcquisition = TargetAcquisition(
          acquisitionRange: acquisitionRange,
          firingRange: firingRange,
          angleDeadzone: angleDeadzone,
        )..anchor = Anchor.center;

  set chargedEnergy(double chargedEnergy) {
    _chargedEnergy = chargedEnergy;
    _chargeBar.value = _chargedEnergy / chargeEnergy;
  }

  double get chargedEnergy => _chargedEnergy;

  double assignEnergy(double assignedEnergy) {
    final leftOverEnergy = (assignedEnergy + chargedEnergy - chargeEnergy)
        .clamp(0, double.infinity)
        .toDouble();
    chargedEnergy = (chargedEnergy + assignedEnergy).clamp(0.0, chargeEnergy);
    return leftOverEnergy;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    anchor = Anchor.center;
    width = 25;
    height = 50;

    targetAcquisition.position = Vector2(width / 2, height / 2);

    add(targetAcquisition);

    _chargeBar = ChargeBar()
      ..value = 0.0
      ..size = Vector2(40, 6)
      ..position = Vector2(width / 2, 0)
      ..anchor = Anchor.center;
    add(_chargeBar);
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
      _powered = gameRef.energy.addConsumer(this);
    }

    if (placed && powered) {
      turnToTarget(dt);
      maybeShoot(dt);
    }
  }

  void maybeShoot(double dt) {
    if (targetAcquisition.closestAcquiredTargetHasFiringSolution &&
        chargedEnergy >= chargeEnergy) {
      chargedEnergy = chargedEnergy - chargeEnergy;
      parent?.add(Bullet(target: targetAcquisition.closestAcquiredTarget!)
        ..position = position
        ..angle = angle);
    }
  }
}
