import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/firebase/firebase_options.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant_description.dart';

int updated = 0;
int added = 0;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Auth.instance().signIn();
  List<PlantDescription> exiting =
      await FireStore.instance().plantsDescriptions();
  values.map((e) => fromDoc(e)).forEach((element) async {
    PlantDescription description = existAlready(exiting, element);
    await publish(description);
    log.d('Updated $updated element, Added $added elements');
  });
}

Future<void> publish(PlantDescription p) {
  var ref =
      FirebaseFirestore.instance.collection(kPlantDescriptionCollectionPath);
  if (p.id.isNotEmpty) {
    updated++;
    return ref.doc(p.id).set(toDoc(p));
  }
  added++;
  return ref.add(toDoc(p));
}

PlantDescription existAlready(List<PlantDescription> list, PlantDescription p) {
  for (PlantDescription element in list) {
    if (element.name == p.name) {
      return element;
    }
  }
  return p;
}

Map<String, dynamic> toDoc(PlantDescription p) {
  return {
    'name': p.name,
    'daysToSprout': p.daysToSprout,
    'sproutToHarvest': p.seedToHarvest,
    'goodFor': p.goodFor
  };
}

PlantDescription fromDoc(Map<String, dynamic> val) {
  return PlantDescription(
      id: val['id'] ?? '',
      name: val['name'],
      daysToSprout: val['daysToSprout'],
      sproutToHarvest: val['sproutToHarvest'],
      goodFor: val['goodFor']);
}

List<Map<String, dynamic>> values = [
  {
    'name': 'Bulls Blood Beets',
    'daysToSprout': 14,
    'sproutToHarvest': 48,
    'goodFor': 32
  },
  {
    'name': 'Buttercrunch',
    'daysToSprout': 9,
    'sproutToHarvest': 55,
    'goodFor': 28
  },
  {
    'name': 'Cherry Tomato',
    'daysToSprout': 13,
    'sproutToHarvest': 103,
    'goodFor': 84
  },
  {'name': 'Arugula', 'daysToSprout': 13, 'sproutToHarvest': 48, 'goodFor': 32},
  {'name': 'Breen', 'daysToSprout': 14, 'sproutToHarvest': 59, 'goodFor': 28},
  {
    'name': 'Jalapeño',
    'daysToSprout': 19,
    'sproutToHarvest': 89,
    'goodFor': 98
  },
  {
    'name': 'Flashy Trout Back',
    'daysToSprout': 8,
    'sproutToHarvest': 44,
    'goodFor': 36
  },
  {
    'name': 'Celery',
    'daysToSprout': 22,
    'sproutToHarvest': 150,
    'goodFor': 128
  },
  {
    'name': 'Green Mustard',
    'daysToSprout': 13,
    'sproutToHarvest': 44,
    'goodFor': 42
  },
  {
    'name': 'Cardinale',
    'daysToSprout': 13,
    'sproutToHarvest': 44,
    'goodFor': 42
  },
  {
    'name': 'Butterhead',
    'daysToSprout': 14,
    'sproutToHarvest': 59,
    'goodFor': 28
  },
  {'name': 'Kale', 'daysToSprout': 14, 'sproutToHarvest': 73, 'goodFor': 42},
  {
    'name': 'Endive Lettuce',
    'daysToSprout': 8,
    'sproutToHarvest': 56,
    'goodFor': 48
  },
  {'name': 'Bok Choi', 'daysToSprout': 8, 'sproutToHarvest': 41, 'goodFor': 25},
  {
    'name': 'Kale Lacinato',
    'daysToSprout': 14,
    'sproutToHarvest': 65,
    'goodFor': 42
  },
  {
    'name': 'Lollo Rossa',
    'daysToSprout': 9,
    'sproutToHarvest': 40,
    'goodFor': 42
  },
];
