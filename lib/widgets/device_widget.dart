import 'package:flutter/material.dart';
import 'package:hydroponic_garden/api.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';

class DevicePage extends StatefulWidget {
  static const routeName = 'device';

  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  num? brightness;

  _DevicePageState() {
    _loadStatus();
  }

  _loadStatus() async {
    API api = API();
    brightness = await api.lightBrightness();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      body: Center(
        child: Column(
          children: [Text('Brightness: $brightness')],
        ),
      ),
    );
  }
}
