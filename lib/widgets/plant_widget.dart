import 'package:flutter/material.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';
import 'package:hydroponic_garden/widgets/storage_image.dart';

class PlantPage extends StatefulWidget {
  static const routeName = 'plant';
  final Plant plant;

  const PlantPage({super.key, required this.plant});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  @override
  Widget build(BuildContext context) {
    return MainWidget(
      title: widget.plant.description.name,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StorageImage(widget.plant.description.id),
            Text(widget.plant.description.name),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Sprouted:'),
                Checkbox(
                    value: widget.plant.sprouted,
                    onChanged: (v) {
                      setState(() {
                        widget.plant.sprouted = v ?? false;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('planted: ${widget.plant.plantedDateString}'),
                IconButton(
                  onPressed: () async {
                    DateTime? res = await showDatePicker(
                      context: context,
                      initialDate: widget.plant.plantedDate,
                      firstDate: firstDate,
                      lastDate: DateTime.now(),
                    );
                    if (res != null) {
                      setState(() {
                        widget.plant.plantedDate = res;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            Text('Health: ${widget.plant.health()}'),
          ],
        ),
      ),
    );
  }
}
