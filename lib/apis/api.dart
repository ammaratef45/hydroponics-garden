import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hydroponic_garden/constants.dart';

class API {
  static const String baseUrl = 'http://garden-test:5000';

  Future<num> lightBrightness() async {
    final response = await http.get(Uri.parse('$baseUrl/light/brightness'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['value'];
    } else {
      throw Exception('Failed to load brightness');
    }
  }

  Future<void> setLightBrightness(num v) async {
    final response = await http.post(
      Uri.parse('$baseUrl/light/brightness'),
      body: jsonEncode(
        <String, dynamic>{'value': v},
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      log.d('Successfully adjusted brightness');
    } else {
      throw Exception('Failed to set brightness');
    }
  }
}
