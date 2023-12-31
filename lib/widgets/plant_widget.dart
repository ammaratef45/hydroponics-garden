import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/editor_preview.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
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
  void _updatePlant() {
    FireStore.instance()
        .addUpdatePlant(
          Auth.instance().user!.uid,
          widget.plant,
        )
        .then(
          (value) => log.d(
            'Updated ${widget.plant.description.name}',
          ),
        );
  }

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
                Switch(
                  value: widget.plant.sprouted,
                  onChanged: (v) {
                    setState(
                      () {
                        widget.plant.sprouted = v;
                        _updatePlant();
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'planted: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.plant.plantedDateString,
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        _updatePlant();
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            if (!widget.plant.sprouted)
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Expected Sprout date: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: widget.plant.sproutDateString,
                      style: TextStyle(
                        color:
                            widget.plant.sproutDate.compareTo(DateTime.now()) >
                                    0
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Expected Harvest date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: widget.plant.harvestDateString,
                    style: TextStyle(
                      color:
                          widget.plant.harvestDate.compareTo(DateTime.now()) > 0
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
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
