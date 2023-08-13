import 'package:flutter/material.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/model/plant_description.dart';

class NewPlant extends StatefulWidget {
  final Plant plant;
  const NewPlant(this.plant, {super.key});

  @override
  State<NewPlant> createState() => _NewPlantState();
}

class _NewPlantState extends State<NewPlant> {
  DropdownMenuItem _item(PlantDescription p) {
    return DropdownMenuItem(
      value: p,
      child: Text(p.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'What did you plant and when did you plant it?',
            style: TextStyle(fontSize: 20),
          ),
          FutureBuilder<List<PlantDescription>>(
            future: FireStore.instance().plantsDescriptions(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Failed to fetch data...');
              }
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              widget.plant.description = snapshot.data![0];
              return DropdownButton(
                items: snapshot.data!.map((e) => _item(e)).toList(),
                onChanged: (e) {
                  setState(() {
                    widget.plant.description = e;
                  });
                },
                value: widget.plant.description,
              );
            },
          ),
          DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: firstDate,
            lastDate: DateTime.now(),
          )
        ],
      ),
    );
  }
}
