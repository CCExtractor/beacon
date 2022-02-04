import 'package:beacon/models/landmarks/landmark.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> dummyJson = {
    "title": "landmark",
    "location": {"lat": "100.1", "lon": "200.1"}
  };

  test('Checking if landmark fetch from Json is working: ', () {
    Landmark landmark = Landmark.fromJson(dummyJson);
    //landmark title
    expect("landmark", landmark.title);
    //landmark latitude
    expect("100.1", landmark.location.lat);
    //landmark longitude
    expect("200.1", landmark.location.lon);
  });
}
