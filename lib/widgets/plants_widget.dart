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

enum PlantOrderOption {
  none('None'),
  sowDate('Planted Date'),
  harvestDate('Harvest Date'),
  name('Name');

  const PlantOrderOption(this.strVal);

  final String strVal;
}

class PlantOrder {
  PlantOrderOption option;
  bool ascending;
  PlantOrder(this.option, [this.ascending = true]);
}

class PlantsPage extends StatefulWidget {
  static const routeName = 'plants';
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  PlantOrder order = PlantOrder(PlantOrderOption.none);

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

  Future<void> _selectOrder() async {
    PlantOrder? o = await showDialog<PlantOrder>(
      context: context,
      builder: (context) {
        bool ascending = order.ascending;
        return Dialog(
          child: ListView(
            children: [
              StatefulBuilder(builder: (context, setState) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ascending?'),
                    Switch(
                      onChanged: (value) {
                        setState(() {
                          ascending = value;
                        });
                      },
                      value: ascending,
                    ),
                  ],
                );
              }),
              ...PlantOrderOption.values
                  .map(
                    (e) => ListTile(
                      title: Text(e.strVal),
                      onTap: () => Navigator.pop(
                        context,
                        PlantOrder(e, ascending),
                      ),
                      selected: order.option == e,
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
    if (o != null) {
      setState(() {
        order = o;
      });
    }
  }

  int Function(Plant, Plant) _comapre() {
    return (p1, p2) {
      switch (order.option) {
        case PlantOrderOption.harvestDate:
          return p1.harvestDate.compareTo(p2.harvestDate);
        case PlantOrderOption.sowDate:
          return p1.plantedDate.compareTo(p2.plantedDate);
        case PlantOrderOption.name:
          return p1.description.name.compareTo(p2.description.name);
        case PlantOrderOption.none:
        default:
          return 0;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      logoutIcon: true,
      showBottomNavigationMenu: true,
      title: 'Plants',
      actions: [
        IconButton(
          onPressed: _selectOrder,
          icon: const Icon(Icons.reorder),
        ),
      ],
      body: StreamBuilder<List<Plant>>(
          stream: FireStore.instance().userPlants(Auth.instance().user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorTextWidget.failedToLoad;
            }
            if (!snapshot.hasData) {
              return LoadingTextWidget.standard;
            }
            List<Plant> plants = snapshot.data!;
            plants.sort(_comapre());
            if (!order.ascending) {
              plants = plants.reversed.toList();
            }
            return ListView(
              children: plants
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
