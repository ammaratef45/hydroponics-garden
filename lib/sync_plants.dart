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
  {'name': 'Matilda', 'daysToSprout': 14, 'sproutToHarvest': 52, 'goodFor': 28},
  {
    'name': 'Monte Carlo',
    'daysToSprout': 14,
    'sproutToHarvest': 93,
    'goodFor': 56
  },
  {
    'name': 'Purslane',
    'daysToSprout': 11,
    'sproutToHarvest': 10,
    'goodFor': 32
  },
  {
    'name': 'Red Amaranth',
    'daysToSprout': 9,
    'sproutToHarvest': 110,
    'goodFor': 25
  },
  {
    'name': 'Red Mustard',
    'daysToSprout': 13,
    'sproutToHarvest': 33,
    'goodFor': 35
  },
  {'name': 'Red Sail', 'daysToSprout': 9, 'sproutToHarvest': 40, 'goodFor': 42},
  {
    'name': 'Red Salad Bowl',
    'daysToSprout': 8,
    'sproutToHarvest': 45,
    'goodFor': 45
  },
  {
    'name': 'Red Sorrel',
    'daysToSprout': 18,
    'sproutToHarvest': 10,
    'goodFor': 25
  },
  {'name': 'Romaine', 'daysToSprout': 9, 'sproutToHarvest': 68, 'goodFor': 28},
  {
    'name': 'Rouge d\'hiver',
    'daysToSprout': 14,
    'sproutToHarvest': 39,
    'goodFor': 28
  },
  {'name': 'Sorrel', 'daysToSprout': 18, 'sproutToHarvest': 67, 'goodFor': 25},
  {
    'name': 'Swiss Chard',
    'daysToSprout': 14,
    'sproutToHarvest': 46,
    'goodFor': 32
  },
  {'name': 'Tatsoi', 'daysToSprout': 13, 'sproutToHarvest': 33, 'goodFor': 32},
  {
    'name': 'Wasabi Greens',
    'daysToSprout': 8,
    'sproutToHarvest': 45,
    'goodFor': 49
  },
  {
    'name': 'Watercress',
    'daysToSprout': 14,
    'sproutToHarvest': 60,
    'goodFor': 28
  },
  {
    'name': 'Wheatgrass',
    'daysToSprout': 6,
    'sproutToHarvest': 21,
    'goodFor': 45
  },
  {
    'name': 'Banana Peppers',
    'daysToSprout': 11,
    'sproutToHarvest': 73,
    'goodFor': 81
  },
  {
    'name': 'Cape Gooseberry',
    'daysToSprout': 19,
    'sproutToHarvest': 67,
    'goodFor': 120
  },
  {
    'name': 'Cucumbers',
    'daysToSprout': 12,
    'sproutToHarvest': 55,
    'goodFor': 70
  },
  {
    'name': 'Mini Eggplant',
    'daysToSprout': 9,
    'sproutToHarvest': 68,
    'goodFor': 25
  },
  {
    'name': 'Mini Strawberries',
    'daysToSprout': 13,
    'sproutToHarvest': 110,
    'goodFor': 183
  },
  {
    'name': 'Sugar Snap Peas',
    'daysToSprout': 11,
    'sproutToHarvest': 70,
    'goodFor': 70
  },
  {
    'name': 'Sweet Peppers',
    'daysToSprout': 19,
    'sproutToHarvest': 79,
    'goodFor': 98
  },
  {
    'name': 'Black Cherry Tomatoes',
    'daysToSprout': 8,
    'sproutToHarvest': 70,
    'goodFor': 84
  },
  {
    'name': 'Jubilee Tomatoes',
    'daysToSprout': 8,
    'sproutToHarvest': 80,
    'goodFor': 84
  },
  {
    'name': 'Roma Tomatoes',
    'daysToSprout': 8,
    'sproutToHarvest': 78,
    'goodFor': 84
  },
  {
    'name': 'San Marzano Tomatoes',
    'daysToSprout': 8,
    'sproutToHarvest': 78,
    'goodFor': 84
  },
  {
    'name': 'Rio Grande Tomatoes',
    'daysToSprout': 8,
    'sproutToHarvest': 75,
    'goodFor': 84
  },
  {
    'name': 'Night-Scented Stock',
    'daysToSprout': 13,
    'sproutToHarvest': 60,
    'goodFor': 100
  },
  {'name': 'Borage', 'daysToSprout': 8, 'sproutToHarvest': 55, 'goodFor': 100},
  {'name': 'Torenia', 'daysToSprout': 13, 'sproutToHarvest': 91, 'goodFor': 91},
  {
    'name': 'Red Marietta Gold',
    'daysToSprout': 11,
    'sproutToHarvest': 60,
    'goodFor': 100
  },
  {
    'name': 'Radio Calendula',
    'daysToSprout': 10,
    'sproutToHarvest': 53,
    'goodFor': 100
  },
  {'name': 'Petunia', 'daysToSprout': 10, 'sproutToHarvest': 35, 'goodFor': 35},
  {
    'name': 'Oopsy Daisy',
    'daysToSprout': 14,
    'sproutToHarvest': 53,
    'goodFor': 53
  },
  {
    'name': 'Lavender',
    'daysToSprout': 23,
    'sproutToHarvest': 105,
    'goodFor': 105
  },
  {
    'name': 'Fiesta Gitana',
    'daysToSprout': 14,
    'sproutToHarvest': 53,
    'goodFor': 53
  },
  {
    'name': 'Chamomille',
    'daysToSprout': 12,
    'sproutToHarvest': 98,
    'goodFor': 56
  },
  {
    'name': 'Campanula',
    'daysToSprout': 21,
    'sproutToHarvest': 65,
    'goodFor': 65
  },
];
