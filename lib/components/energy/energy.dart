import 'package:flame/components.dart';
import 'package:flame_test/components/tower/tower.dart';

class Energy extends Component {
  double generation;

  Energy({
    this.generation = 12.0,
  });

  // TODO: instead of Tower, this should use some sort
  // of mixin for energy consumers
  final List<Tower> _consumers = [];

  bool addConsumer(Tower consumer) {
    if (_consumers.contains(consumer)) {
      return true;
    } else if (netBasePower >= consumer.baseConsumption) {
      _consumers.add(consumer);
      return true;
    } else {
      return false;
    }
  }

  double get totalBaseConsumption => _consumers.fold(
      0, (previousValue, element) => previousValue + element.baseConsumption);

  double get netBasePower => generation - totalBaseConsumption;

  double get totalChargeConsumption => _consumers.fold(
      0, (previousValue, element) => previousValue + element.chargeConsumption);

  double get netChargePower => generation - totalChargeConsumption;

  double get netTotalPower =>
      generation - totalBaseConsumption - totalChargeConsumption;

  void distributeEnergy(double dt) {
    double availableChargeEnergy = (generation - totalBaseConsumption) * dt;
    final totalChargeEnergy = totalChargeConsumption * dt;

    for (final consumer in _consumers) {
      final distributionFactor =
          (availableChargeEnergy / totalChargeEnergy).clamp(0.0, 1.0);
      final chargeEnergyToDistribute =
          consumer.chargeConsumption * distributionFactor * dt;
      final consumedEnergy = consumer.assignEnergy(chargeEnergyToDistribute);
      availableChargeEnergy -= consumedEnergy;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    distributeEnergy(dt);
  }
}
