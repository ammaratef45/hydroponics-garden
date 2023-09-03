import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant_description.dart';
import 'package:hydroponic_garden/widgets/error_text_widget.dart';
import 'package:hydroponic_garden/widgets/loading_text_widget.dart';

class PickPlant extends StatefulWidget {
  const PickPlant({super.key});

  @override
  State<PickPlant> createState() => _PickPlantState();
}

class _PickPlantState extends State<PickPlant> {
  PlantDescription? description;
  List<PlantDescription> selected = [];

  Widget _selectedWidget(
      PlantDescription d, void Function(void Function()) setstate) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(d.name),
          IconButton(
            onPressed: () {
              setstate(
                () {
                  selected.remove(d);
                },
              );
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<PlantDescription> _item(PlantDescription p) {
    return DropdownMenuItem(
      value: p,
      child: Text(p.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantDescription>>(
      future: FireStore.instance().plantsDescriptions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorTextWidget.failedToLoad;
        }
        if (!snapshot.hasData) {
          return LoadingTextWidget.standard;
        }
        description ??= snapshot.data![0];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'What did you plant?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton(
                    items: snapshot.data!.map((e) => _item(e)).toList(),
                    onChanged: (e) {
                      setState(() {
                        description = e!;
                      });
                    },
                    value: description,
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      if (description == null) return;
                      selected.add(description!);
                    }),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...selected.map((e) => _selectedWidget(e, setState)).toList(),
              const SizedBox(height: 12),
              const Text(
                'Click next to choose sow date',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context, selected),
                child: const Text('next'),
              ),
            ],
          ),
        );
      },
    );
  }
}
