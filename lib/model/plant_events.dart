import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:hydroponic_garden/model/plant.dart';

// TODO: add events to important care events for plants
//  for example: pruning, trimming, health check ... etc
class PlantEvents {
  final Plant _plant;

  PlantEvents(this._plant);

  List<CalendarEventData> harvestEvents() {
    List<CalendarEventData> res = [];
    for (int i = 0;
        i < _plant.harvestDate.getDayDifference(_plant.endHarvestDate);
        i++) {
      DateTime date = _plant.harvestDate.add(Duration(days: i));
      res.add(CalendarEventData(
        title: 'harvest ${_plant.description.name} - Day $i',
        date: date,
        endDate: date,
        startTime: date,
        color: Colors.green,
      ));
    }
    return res;
  }

  List<CalendarEventData> careEvents() {
    List<CalendarEventData> res = [];
    for (int i = 0;
        i < _plant.plantedDate.getDayDifference(_plant.sproutDate);
        i += 3) {
      DateTime date = _plant.plantedDate.add(Duration(days: i));
      res.add(CalendarEventData(
        title: 'care ${_plant.description.name} - Day $i',
        date: date,
        endDate: date,
        startTime: date,
        color: Colors.green,
      ));
    }
    return res;
  }
}
