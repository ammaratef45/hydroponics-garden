import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/firestore.dart';
import 'package:hydroponic_garden/model/plant_description.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';
import 'package:hydroponic_garden/widgets/storage_image.dart';

class AdminWidget extends StatelessWidget {
  static const routeName = 'admin';

  const AdminWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MainWidget(
      showBottomNavigationMenu: true,
      navigationIndex: 3,
      title: 'Admin',
      body: StreamBuilder<List<PlantDescription>>(
        stream: FireStore.instance().plantsDescriptionsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data....'),
            );
          }
          return ListView(
            children: snapshot.data!
                .map(
                  (e) => ListTile(
                    leading: StorageImage(e.id),
                    title: Text(e.name),
                    subtitle: Text(e.care),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
