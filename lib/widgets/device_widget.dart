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
  bool? pump;
  API api = API();

  _DevicePageState() {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    brightness = await api.lightBrightness();
    pump = await api.isPumpOn();
    setState(() {});
  }

  Future<void> _updateBrightness(num v) async {
    await api.setLightBrightness(v);
    await _loadStatus();
  }

  Future<void> _updatePump(bool v) async {
    await api.pumpOnOff(v);
    await _loadStatus();
  }

  List<Widget> _brightness() => [
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
      ];

  List<Widget> _pump() => [
        Text('Pump: ${pump != null ? {pump! ? 'on' : 'off'} : 'unknown'}'),
        Switch(
            value: pump ?? false,
            onChanged: (v) {
              pump = v;
              setState(() {});
              _updatePump(v);
            }),
      ];

  @override
  Widget build(BuildContext context) {
    return MainWidget(
      body: Center(
        child: Column(
          children: [
            ..._brightness(),
            ..._pump(),
          ],
        ),
      ),
    );
  }
}
