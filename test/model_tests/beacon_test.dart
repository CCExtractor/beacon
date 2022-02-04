import 'package:beacon/models/beacon/beacon.dart';
import 'package:test/test.dart';

void main() {
  //structered according to fetchBeaconDetail Query.
  Map<String, dynamic> dummyJson = {
    "_id": "61fd51b4f0c4c3219ce356f5",
    "title": "new",
    "leader": {"name": "asdasd"},
    "followers": [
      {
        "_id": "61fd509bf0c4c3219ce356ed",
        "name": "asdasd",
        "location": {"lat": "10", "lon": "20"}
      }
    ],
    "landmarks": [
      {
        "title": "land",
        "location": {"lat": "1", "lon": "2"}
      }
    ],
    "location": {"lat": "1", "lon": "2"},
    "startsAt": 1669746600000,
    "expiresAt": 1669746600001,
    "shortcode": "WCQDUR"
  };

  test('Beacon.fromJson method works or not: ', () {
    Beacon beacon = Beacon.fromJson(dummyJson);
    //beacon id
    expect("61fd51b4f0c4c3219ce356f5", beacon.id);
    //title
    expect("new", beacon.title);
    //leader name
    expect("asdasd", beacon.leader.name);
    //follower id
    expect("61fd509bf0c4c3219ce356ed", beacon.followers.first.id);
    //follower name
    expect("asdasd", beacon.followers.first.name);
    //follower location
    expect("10", beacon.followers.first.location.lat);
    //longitude
    expect("20", beacon.followers.first.location.lon);
    //landmark
    expect("land", beacon.landmarks.first.title);
    expect("1", beacon.landmarks.first.location.lat);
    expect("2", beacon.landmarks.first.location.lon);
    //beacon location
    expect("1", beacon.location.lat);
    expect("2", beacon.location.lon);
    //starts at
    expect(1669746600000, beacon.startsAt);
    //expires at
    expect(1669746600001, beacon.expiresAt);
    //short code
    expect("WCQDUR", beacon.shortcode);
  });
}
