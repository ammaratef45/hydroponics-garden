import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/model/plant_description.dart';
import 'package:hydroponic_garden/widgets/error_text_widget.dart';
import 'package:hydroponic_garden/widgets/loading_text_widget.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';
import 'package:hydroponic_garden/widgets/new_plant_widget.dart';
import 'package:hydroponic_garden/widgets/plant_widget.dart';
import 'package:hydroponic_garden/widgets/storage_image.dart';

class PlantsPage extends StatelessWidget {
  static const routeName = 'plants';
  const PlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      logoutIcon: true,
      title: 'Plants',
      body: StreamBuilder<List<Plant>>(
          stream: FireStore.instance().userPlants(Auth.instance().user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorTextWidget.failedToLoad;
            }
            if (!snapshot.hasData) {
              return LoadingTextWidget.standard;
            }
            return ListView(
              children: snapshot.data!
                  .map((e) => ListTile(
                        leading: StorageImage(e.description.id),
                        title: Text(e.description.name),
                        subtitle: Text('planted: ${e.plantedDateString}'),
                        onTap: () => Navigator.pushNamed(
                          context,
                          PlantPage.routeName,
                          arguments: e,
                        ),
                      ))
                  .toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Plant plant = Plant(PlantDescription(
              id: '',
              name: '',
              daysToSprout: 0,
              sproutToHarvest: 0,
              goodFor: 0));
          DateTime? time = await showDialog<DateTime>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                child: NewPlant(plant),
              );
            },
          );
          if (time != null) {
            plant.plantedDate = time;
            await FireStore.instance()
                .addUpdatePlant(Auth.instance().user!.uid, plant);
          }
        },
      ),
    );
  }
}
