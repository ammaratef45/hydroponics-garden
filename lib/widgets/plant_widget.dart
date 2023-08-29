import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/editor_preview.dart';
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            StorageImage(widget.plant.description.id),
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
            // TODO: change style (make the part before colon bold)
            // TODO: show remaining number of days with the date (maybe click to toggle)
            if (!widget.plant.sprouted)
              Text('Expected Sprout date: ${widget.plant.sproutDate}'),
            Text('Expected Harvest date: ${widget.plant.harvestDate}'),
            const Text(
              'Care instructions:',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            MarkdownPreview(
              text: widget.plant.description.care,
            ),
          ],
        ),
      ),
    );
  }
}
