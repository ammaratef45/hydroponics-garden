import 'dart:convert';

import 'package:http/http.dart' as http;

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
}
