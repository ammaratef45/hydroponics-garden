final class PlantDescription {
  final String id;
  final String name;
  final String care;
  final int daysToSprout;
  final int sproutToHarvest;
  final int goodFor;

  int get seedToHarvest => daysToSprout + sproutToHarvest;
  int get totalGrowth => seedToHarvest + goodFor;

  PlantDescription({
    required this.id,
    required this.name,
    required this.daysToSprout,
    required this.sproutToHarvest,
    required this.goodFor,
    required this.care,
  });

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PlantDescription) {
      return other.name == name;
    }
    return false;
  }

  @override
  String toString() {
    return 'PlantDescription:('
        'id:$id, name: $name, daysToSprout:$daysToSprout,'
        'sproutToHarvest:$sproutToHarvest, goodFor:$goodFor)';
  }
}
