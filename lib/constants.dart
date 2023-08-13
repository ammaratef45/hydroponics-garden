import 'package:logger/logger.dart';

// Logger
Logger log = Logger();

// This app is being developed in August.
// I decided to make the first date you can specify as planted date to be
//   the International Mother Earth Day in 2023 (April 22nd).
final DateTime firstDate = DateTime(2023, DateTime.april, 22);

// === Firebase constants ====== //
const String kPlantDescriptionCollectionPath = 'PlantDescription';
const String kUsersCollectionPath = 'users';
const String kPlantsList = 'plants';
const String kDescriptionFiled = 'des';
const String kDateFiled = 'date';
const String kSproutedFiled = 'spr';
