import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  // static instance to use this as a singleton
  static Storage? _instance;

  late FirebaseStorage _storage;

  Storage._() {
    _storage = FirebaseStorage.instance;
  }

  static Storage instance() {
    _instance ??= Storage._();
    return _instance!;
  }

  Future<String> imageUrl(String id) {
    return _storage.ref(id).getDownloadURL();
  }
}
