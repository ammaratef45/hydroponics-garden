import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/model/plant_description.dart';
import 'package:intl/intl.dart';

class Plant {
  final DateFormat _format = DateFormat.yMMMMEEEEd();

  PlantDescription description;
  DateTime plantedDate = DateTime.now();
  bool sprouted = false;

  String get plantedDateString => _format.format(plantedDate);
  void setPlantedDateFromString(String s) {
    plantedDate = _format.parse(s);
  }

  Plant(this.description);

  static Plant fromDoc(Map<String, dynamic> doc, PlantDescription description) {
    Plant p = Plant(description);
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

  String health() {
    int daysSincePlanted = DateTime.now().difference(plantedDate).inDays;
    if (!sprouted && daysSincePlanted >= description.daysToSprout) {
      return 'Check Plant';
    } else if (daysSincePlanted >= description.seedToHarvest) {
      if (daysSincePlanted < description.goodFor) {
        return 'Ready to Harvest';
      } else {
        return 'Time to Replace';
      }
    }
    return 'Good';
  }
}
