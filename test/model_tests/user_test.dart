import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:test/test.dart';

void main() {
  //structered according to fetchBeaconDetail Query.
  Map<String, dynamic> dummyJson = {
    "_id": "61fd509bf0c4c3219ce356ed",
    "name": "asdasd",
    "email": "asdf@g.com",
    "location": {"lat": "10", "lon": "20"},
    "beacons": [
      {
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
      }
    ],
  };
  Map<String, dynamic> dummyJson2 = {
    "_id": "61fd509bf0c4c3219ce356de",
    "name": "asd",
    "email": "as@g.com",
    "location": {"lat": "20", "lon": "10"},
    "beacons": [
      {
        "_id": "61fd51b4f0c4c3219ce3565f",
        "title": "newer",
        "leader": {"name": "asd"},
        "followers": [
          {
            "_id": "61fd509bf0c4c3219ce356de",
            "name": "asd",
            "location": {"lat": "20", "lon": "10"}
          }
        ],
        "landmarks": [
          {
            "title": "landmark",
            "location": {"lat": "2", "lon": "1"}
          }
        ],
        "location": {"lat": "2", "lon": "1"},
        "startsAt": 1669746600001,
        "expiresAt": 1669746600002,
        "shortcode": "WCQDUK"
      }
    ],
  };

  group('Testing User Model', () {
    test('User.fromJson method works or not: ', () {
      User user = User.fromJson(dummyJson);
      Beacon beacon = user.beacon.first;
      //user id;
      expect("61fd509bf0c4c3219ce356ed", user.id);
      //name
      expect("asdasd", user.name);
      //email
      expect("asdf@g.com", user.email);
      //isGuest
      expect(false, user.isGuest);
      //location
      expect("10", user.location.lat);
      expect("20", user.location.lon);
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

    test('Testing if update() method works', () {
      User user = User.fromJson(dummyJson);
      user.authToken = 'authTokenIntial';
      User updateToUser = User.fromJson(dummyJson2);
      updateToUser.authToken = 'FinalAuthToken';
      updateToUser.isGuest = true;
      user.update(updateToUser);
      Beacon beacon = user.beacon.first;
      //auth token
      expect("FinalAuthToken", user.authToken);
      //userID
      expect("61fd509bf0c4c3219ce356ed", user.id);
      //name
      expect("asd", user.name);
      //email
      expect("as@g.com", user.email);
      //isGuest
      expect(true, user.isGuest);
      //location
      expect("20", user.location.lat);
      expect("10", user.location.lon);
      //beacon id
      expect("61fd51b4f0c4c3219ce3565f", beacon.id);
      //title
      expect("newer", beacon.title);
      //leader name
      expect("asd", beacon.leader.name);
      //follower id
      expect("61fd509bf0c4c3219ce356de", beacon.followers.first.id);
      //follower name
      expect("asd", beacon.followers.first.name);
      //follower location
      expect("20", beacon.followers.first.location.lat);
      //longitude
      expect("10", beacon.followers.first.location.lon);
      //landmark
      expect("landmark", beacon.landmarks.first.title);
      expect("2", beacon.landmarks.first.location.lat);
      expect("1", beacon.landmarks.first.location.lon);
      //beacon location
      expect("2", beacon.location.lat);
      expect("1", beacon.location.lon);
      //starts at
      expect(1669746600001, beacon.startsAt);
      //expires at
      expect(1669746600002, beacon.expiresAt);
      //short code
      expect("WCQDUK", beacon.shortcode);
    });
  });
}
