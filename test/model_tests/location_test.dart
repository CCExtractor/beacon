import 'package:beacon/models/location/location.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> dummyJson = {"lat": "100.1", "lon": "200.1"};

  test('Checking if location fetch from Json is working: ', () {
    Location location = Location.fromJson(dummyJson);

    //location latitude
    expect("100.1", location.lat);
    //location longitude
    expect("200.1", location.lon);
  });
}
