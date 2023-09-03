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
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            //
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What did you plant?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              DropdownButton(
                items: snapshot.data!.map((e) => _item(e)).toList(),
                onChanged: (e) {
                  setState(() {
                    description = e!;
                  });
                },
                value: description,
              ),
              const SizedBox(height: 12),
              const Text(
                'Click next to choose sow date',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context, description),
                child: const Text('next'),
              ),
            ],
          ),
        );
      },
    );
  }
}
