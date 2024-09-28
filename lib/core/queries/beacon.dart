import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BeaconQueries {
  String filterBeacons(String groupId, String type) {
    return '''query{
          filterBeacons(id:"$groupId", type: "$type"){
            _id
            title
            leader{
              _id
              name
            }
            startsAt
            expiresAt
            shortcode
          }
        }
''';
  }

  String rescheduleHike(int newExpirestAt, int newStartsAt, String beaconId) {
    return '''mutation{ rescheduleHike(newExpiresAt: $newExpirestAt, newStartsAt: $newStartsAt, beaconID: "$beaconId"){
            _id
             title
             shortcode
             leader {
               _id
               name
             }
             group{
              _id
              title
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
    }}''';
  }

  String deleteBeacon(String? id) {
    return '''

mutation{
deleteBeacon(id: "$id")
}
''';
  }

  String changeLeader(String? beaconID, String? newLeaderID) {
    return '''
        mutation{
           changeLeader (beaconID:"$beaconID" ,newLeaderID: "$newLeaderID")
          {
            _id
             title
             shortcode
             leader {
               _id
               name
             }
             group{
              _id
              title
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
        }
    ''';
  }

  String createBeacon(String? title, int startsAt, int expiresAt, String lat,
      String lon, String? groupID) {
    return '''
        mutation{
          createBeacon(beacon: {
            title: "$title",
            startsAt: $startsAt,
            expiresAt: $expiresAt,
            startLocation: {
              lat: "$lat", lon: "$lon"
            }
          },
          groupID:"$groupID")
          {
            _id
            title
            shortcode
            leader {
              _id
              name
              email
              beacons{
              _id
              }
            }
            group {
              _id
              title
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

  String updateBeaconLocation(String? id, String lat, String lon) {
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

  String changeUserLocation(String? id, String lat, String lon) {
    return '''
        mutation {
            updateUserLocation(id: "$id", location: {lat: "$lat", lon:"$lon"}){
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

  String joinBeacon(String? shortcode) {
    return '''
        mutation {
            joinBeacon(shortcode: "$shortcode"){
              _id
              title
              shortcode
              group{
                _id
                title
              }
              leader {
                _id
                name
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
            }
        }
    ''';
  }

  String fetchBeaconDetail(String? id) {
    return '''
        query{
          beacon(id:"$id"){
            _id
            title
            leader{
              _id
              name
              location{
              lat
              lon
              }
            }
            group {
              _id
              title
            }
            followers {
              _id
              name
              location{
                lat
                lon
              }
            }
            landmarks{
              _id
              title
              location{
                lat
                lon
              }
              createdBy{
              _id
              name
              }
            }
            location{
              lat
              lon
            }
            route{
              lat
              lon
            }
            startsAt
            expiresAt
            shortcode
          }
        }
    ''';
  }

  String addRoute(String id, LatLng latlng) {
    return '''
     mutation{
       addRoute(
         id: "$id"
         location:{
          lat: "${latlng.latitude}",
          lon: "${latlng.longitude}"
         }
       )
     }
    ''';
  }

  String fetchNearbyBeacons(String id, String lat, String lon, double radius) {
    return '''
        query {
            nearbyBeacons(
            id: "$id",
            location:{
              lat: "$lat",
              lon: "$lon"
            },
            radius: $radius){
              _id
              title
              shortcode
              group {
                _id
                title
              }
              leader {
                _id
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
            }
        }
    ''';
  }

  final beaconLocationSubGql = gql(r'''
    subscription StreamBeaconLocation($id: ID!){
      beaconLocation(id: $id){
        lat
        lon
      }
    }
  ''');

  // Gql for order updated subscription.
  final beaconJoinedSubGql = gql(r'''
    subscription StreamNewlyJoinedBeacons($id: ID!){
      beaconJoined(id: $id){
        name
        location{
          lat
          lon
        }
      }
    }
  ''');

  final joinleaveBeaconSubGql = gql(r'''
    subscription StreamNewlyJoinedBeacons($id: ID!){
      JoinLeaveBeacon(id: $id){
        newfollower{
        _id
        name
        email
        }
        inactiveuser{
        _id
        name
        email
        }
      }
    }
  ''');

  final beaconUpdateSubGql = gql(r'''
    subscription StreamBeaconUpdate($id: ID!){
      updateBeacon(id: $id){
        user{
         _id
         name
         email
         location{
            lat
            lon
          }
        }

        landmark{
          _id
          title
          location{
            lat 
            lon
          }
        }

      }
    }
  ''');

  String createLandmark(String? id, String lat, String lon, String? title) {
    return '''
      mutation{
        createLandmark(
          landmark:{
            location:{lat:"$lat", lon:"$lon"},
            title:"$title"
          },
          beaconID:"$id")
        {
          _id
          title
          location{
            lat
            lon
          }
          createdBy{
          _id
          name
          }
        }
      }
    ''';
  }

  String sos(String id) {
    return '''
      mutation{
        sos( id:"$id"){
          _id
          name
          email
          location{
            lat
            lon
          }
        }
      }
    ''';
  }

  final locationUpdateGQL = gql(r'''
    subscription StreamLocationUpdate($id: ID!){
      beaconLocations(id: $id){

      route{
       lat
       lon
      }

      updatedUser{
       _id
       name
       location{
         lat
         lon
       }
      }

      landmark{
       _id
       title
       location{
       lat
       lon
       }
       createdBy{
       _id
       name
       email
       }
      }

      }
    }
  ''');
}
