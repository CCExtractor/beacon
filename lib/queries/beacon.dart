import 'dart:ffi';

class BeaconQueries {
  String createBeacon(String title, int expiresAt, String lat, String lon) {
    return '''
        mutation{
          createBeacon(beacon: {
            title: "$title", 
            expiresAt: $expiresAt,
            startLocation: {
              lat: "$lat", lon: "$lon"
            }
          })
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            location{
              lat
              lon
            }
            followers {
              _id
              name
            }
            startsAt
            expiresAt
            landmarks {
              title
              location {
                lat
                lon
              }
            }
          }
        }
    ''';
  }

  String updateLeaderLoc(String id, String lat, String lon) {
    return '''
        mutation {
            updateBeaconLocation(id: "$id", location: {lat: "$lat", lon:"$lon"}){
              location{
                lat
                lon
              }
            }
        }
    ''';
  }

  String addLandmark(String title, String lat, String lon, String id) {
    return '''
        mutation{
          createLandmark(
            landmark: {
              title: "$title", 
              location: {
                lat:"$lat", 
                lon:"$lon"
              }
            }
            beaconID:"$id"
          ){
            location{
              lat
              lon
            }
          }
        }
    ''';
  }

  String joinBeacon(String shortcode) {
    return '''
        mutation {
            joinBeacon(shortcode: "$shortcode"){
              _id
              title
              shortcode
              leader {
                name
                location {
                  lat
                  lon
                }
              }
              location {
                lat
                lon
              }
              followers {
                _id
                name
              }
              startsAt
              expiresAt
              landmarks {
                title
                location {
                  lat
                  lon
                }
              }
            }
        }
    ''';
  }

  String fetchNearbyBeacons(String lat, String lon) {
    return '''
        query {
            nearbyBeacons(location:{
              lat: "$lat",
              lon: "$lon"
            }){
              _id
              title
              shortcode
              leader {
                name
                location {
                  lat
                  lon
                }
              }
              location {
                lat
                lon
              }
              followers {
                _id
                name
              }
              startsAt
              expiresAt
              landmarks {
                title
                location {
                  lat
                  lon
                }
              }
            }
        }
    ''';
  }

  String fetchLocationUpdates(String id) {
    return '''
        subscription {
            beaconLocation (id: "$id") {
              lat
              lon
            }
        }
    ''';
  }

  String fetchUserLocation(String id) {
    return '''
        subscription {
            userLocation (id: "$id") {
              _id
              name
              location{
                lat
                lon
              }
            }
        }
    ''';
  }

  String fetchFollowerUpdates(String id) {
    return '''
        subscription {
            beaconJoined (id: "$id") {
              _id
              name
            }
        }
    ''';
  }

  String createLandmark(String id, String lat, String lon, String title) {
    return '''
      mutation{
        createLandmark(
          landmark:{
            location:{lat:"$lat", lon:"$lon"}, 
            title:"$title"
          }, 
          beaconID:"$id")
        {
          title
          location{
            lat
            lon
          }
        }
        }
    ''';
  }
}
