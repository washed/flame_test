// Project imports:
import 'package:flame_test/components/tower/tower.dart';

class PlasmaTower extends Tower {
  PlasmaTower()
      : super(
          turnRate: 10.0,
          bulletVelocity: 50.0,
          baseConsumption: 5.0,
          chargeConsumption: 2.0,
          chargeEnergy: 1.0,
          firingRange: 500, // 75,
          acquisitionRange: 500, // 100,
        );
}
