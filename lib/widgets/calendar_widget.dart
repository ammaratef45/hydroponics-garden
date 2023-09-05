import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:hydroponic_garden/apis/calendar_api.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/widgets/error_text_widget.dart';
import 'package:hydroponic_garden/widgets/loading_text_widget.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';

class CalendarPage extends StatelessWidget {
  static const routeName = 'calendar';
  final EventController controller = EventController();

  CalendarPage({super.key});

  // TODO: integrate with apple and google maps and famous reminder apps
  void _addEvents(List<Plant> plants) {
    // TODO: add events to important care events for plants
    //  for example: pruning, trimming, health check .. etc
    for (Plant p in plants) {
      // TODO: make the events show continiously across days
      controller.add(CalendarEventData(
        title: p.description.name,
        date: p.harvestDate,
        endDate: p.endHarvestDate,
        startTime: p.harvestDate,
        endTime: p.endHarvestDate,
      ));
    }
    CalendarAPI();
  }

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      showBottomNavigationMenu: true,
      navigationIndex: 1,
      title: 'Calendar',
      body: StreamBuilder<List<Plant>>(
        stream: FireStore.instance().userPlants(Auth.instance().user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorTextWidget.failedToLoad;
          }
          if (!snapshot.hasData) {
            return LoadingTextWidget.standard;
          }
          controller.removeWhere((e) => true);
          _addEvents(snapshot.data!);
          return MonthView(
            controller: controller,
          );
        },
      ),
    );
  }
}
