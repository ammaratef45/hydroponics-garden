import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/model/plant_description.dart';

class FireStore {
  // static instance to use this as a singleton
  static FireStore? _instance;

  late FirebaseFirestore _store;
  List<PlantDescription>? _descriptions;

  FireStore._() {
    _store = FirebaseFirestore.instance;
    plantsDescriptions().then((value) => log.d('loaded descriptions'));
  }

  static FireStore instance() {
    _instance ??= FireStore._();
    return _instance!;
  }

  Future<List<PlantDescription>> plantsDescriptions() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _store.collection(kPlantDescriptionCollectionPath).get();
    _descriptions ??= snapshot.docs
        .map(
          (e) => PlantDescription(
            id: e.id,
            name: e.data()['name'],
            daysToSprout: e.data()['daysToSprout'],
            sproutToHarvest: e.data()['sproutToHarvest'],
            goodFor: e.data()['goodFor'],
            care: e.data()['care'] ?? '',
          ),
        )
        .toList();
    return _descriptions!;
  }

  Stream<List<PlantDescription>> plantsDescriptionsStream() {
    return _store.collection(kPlantDescriptionCollectionPath).snapshots().map(
          (e) => e.docs
              .map(
                (e) => PlantDescription(
                  id: e.id,
                  name: e.data()['name'],
                  daysToSprout: e.data()['daysToSprout'],
                  sproutToHarvest: e.data()['sproutToHarvest'],
                  goodFor: e.data()['goodFor'],
                  care: e.data()['care'] ?? '',
                ),
              )
              .toList(),
        );
  }

  Stream<List<Plant>> userPlants(String uid) {
    return _store
        .collection(kUsersCollectionPath)
        .doc(uid)
        .collection(kPlantsList)
        .snapshots()
        .asyncMap((event) async {
      while (_descriptions == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      return event.docs.map((e) {
        String descriptionId = e.data()[kDescriptionFiled];
        PlantDescription description = _descriptions![0];
        for (PlantDescription des in _descriptions!) {
          if (des.id == descriptionId) {
            description = des;
            break;
          }
        }
        return Plant.fromDoc(e.data(), e.id, description);
      }).toList();
    });
  }

  Future<void> addUpdatePlant(String uid, Plant p) {
    CollectionReference<Map<String, dynamic>> collectionReference = _store
        .collection(kUsersCollectionPath)
        .doc(uid)
        .collection(kPlantsList);
    if (p.id.isEmpty) {
      return collectionReference.add(p.doc());
    }
    return collectionReference.doc(p.id).update(p.doc());
  }

  Future<void> deletePlant(String uid, Plant p) {
    return _store
        .collection(kUsersCollectionPath)
        .doc(uid)
        .collection(kPlantsList)
        .doc(p.id)
        .delete();
  }
}
