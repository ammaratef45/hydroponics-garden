import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/model/plant_description.dart';
import 'package:intl/intl.dart';

class Plant {
  final DateFormat _format = DateFormat.yMMMMEEEEd();

  String id;
  PlantDescription description;
  DateTime plantedDate = DateTime.now();
  bool sprouted = false;

  String get plantedDateString => _format.format(plantedDate);
  void setPlantedDateFromString(String s) {
    plantedDate = _format.parse(s);
  }

  DateTime get sproutDate =>
      plantedDate.add(Duration(days: description.daysToSprout));
  String get sproutDateString => _format.format(sproutDate);

  DateTime get harvestDate =>
      plantedDate.add(Duration(days: description.seedToHarvest));
  String get harvestDateString => _format.format(harvestDate);

  DateTime get endHarvestDate => harvestDate.add(
        Duration(
          days: description.goodFor,
          hours: 23,
          minutes: 59,
          seconds: 59,
        ),
      );

  Plant(this.id, this.description);

  static Plant fromDoc(
      Map<String, dynamic> doc, String id, PlantDescription description) {
    Plant p = Plant(id, description);
    p.setPlantedDateFromString(doc[kDateFiled]);
    p.sprouted = doc[kSproutedFiled];
    return p;
  }

  Map<String, dynamic> doc() {
    return {
      kDescriptionFiled: description.id,
      kDateFiled: plantedDateString,
      kSproutedFiled: sprouted
    };
  }
}
