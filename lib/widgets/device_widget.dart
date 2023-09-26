import 'package:flutter/material.dart';
import 'package:hydroponic_garden/apis/api.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';

class DevicePage extends StatefulWidget {
  static const routeName = 'device';

  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  num? brightness;
  API api = API();

  _DevicePageState() {
    _loadStatus();
  }

  _loadStatus() async {
    brightness = await api.lightBrightness();
    setState(() {});
  }

  _updateBrightness(num v) async {
    await api.setLightBrightness(v);
    await _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      body: Center(
        child: Column(
          children: [
            Text('Brightness: $brightness%'),
            Slider(
              value: brightness?.toDouble() ?? 0,
              max: 100,
              divisions: 5,
              label: 'Brightness: $brightness%',
              onChanged: (val) {
                brightness = val;
                setState(() {});
                _updateBrightness(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
