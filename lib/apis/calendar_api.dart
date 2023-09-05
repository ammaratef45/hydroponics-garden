import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hydroponic_garden/constants.dart';
import 'package:hydroponic_garden/firebase/auth.dart';

class CalendarAPI {
  CalendarAPI() {
    _init();
  }

  Future<void> _init() async {
    AuthClient? client = await Auth.instance().apiClient();
    if (client == null) {
      log.d('null client, will not do anything');
    } else {
      CalendarApi api = CalendarApi(client);
      CalendarList list = await api.calendarList.list();
      log.d(list.items![0].id);
      // await api.calendars.insert(Calendar(id: 'newCal', summary: 'Hydropnic'));
    }
  }
}
