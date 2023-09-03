import 'package:flutter/material.dart';
import 'package:hydroponic_garden/constants.dart';
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
import 'package:hydroponic_garden/widgets/yes_no_dialog.dart';

class PlantsPage extends StatelessWidget {
  static const routeName = 'plants';
  const PlantsPage({super.key});

  Future<void> _startNewPlantFlow(BuildContext context) async {
    List<PlantDescription>? descriptions =
        await showDialog<List<PlantDescription>>(
      context: context,
      builder: (context) {
        return const Dialog(
          child: PickPlant(),
        );
      },
    );
    if (descriptions?.isEmpty == null ||
        descriptions!.isEmpty ||
        // ignore: use_build_context_synchronously
        !context.mounted) {
      return;
    }
    DateTime? sowDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    // ignore: use_build_context_synchronously
    if (sowDate == null || !context.mounted) {
      return;
    }
    for (PlantDescription description in descriptions) {
      Plant p = Plant('', description);
      p.plantedDate = sowDate;
      await FireStore.instance().addUpdatePlant(Auth.instance().user!.uid, p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      logoutIcon: true,
      showBottomNavigationMenu: true,
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
                        trailing: IconButton(
                            onPressed: () async {
                              bool res = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return YesNoDialog(
                                      context: context,
                                      titleText: 'Are you sure?',
                                      contentText:
                                          'Deleting the plant can NOT be reversed, '
                                          'are you sure you want to delete this ${e.description.name} plant?',
                                      okText: 'Delete',
                                      cancelText: 'Abort',
                                    );
                                  });
                              if (res) {
                                await FireStore.instance().deletePlant(
                                  Auth.instance().user!.uid,
                                  e,
                                );
                              }
                            },
                            icon: const Icon(Icons.delete)),
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
          await _startNewPlantFlow(context);
        },
      ),
    );
  }
}
