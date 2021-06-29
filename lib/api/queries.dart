import 'dart:ffi';

class Queries {
  String registerUser(String name, String email, String password) {
    return '''
        mutation{
          register(user: {name: "$name", credentials: {email: "$email", password: "$password"}})
          {
            _id
            name
            email
          }
        }
    ''';
  }

  String loginUser(String email, String password) {
    return '''
        mutation{
          login(credentials: {email: "$email", password: "$password"})
        }
    ''';
  }

  String fetchUserInfo() {
    return '''
      query{
        me{
          _id
          email
          name
          beacons{
            _id
            leader {
              _id
              name
            }
          }
        }
      }
    ''';
  }

  String createBeacon(String title, int expiresAt) {
    return '''
        mutation{
          createBeacon(beacon: {title: "$title", expiresAt: $expiresAt})
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            followers {
              _id
              name
            }
            startsAt
            expiresAt
          }
        }
    ''';
  }

  String updateLeaderLoc(String id, String lat, String lon) {
    return '''
        mutation {
            updateLocation(id: "$id", location: {lat: "$lat", lon:"$lon"}){
              lat
              lon
            }
        }
    ''';
  }
}
