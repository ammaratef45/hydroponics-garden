import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/storage.dart';

class StorageImage extends StatelessWidget {
  final String id;
  const StorageImage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: Storage.instance().imageUrl(id),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Image.asset('assets/plant.png');
          }
          return Image.network(snapshot.data!);
        });
  }
}
