import 'package:graphql_flutter/graphql_flutter.dart';

class BeaconQueries {
  String createBeacon(
      String title, int startsAt, int expiresAt, String lat, String lon) {
    return '''
        mutation{
          createBeacon(beacon: {
            title: "$title",
            startsAt: $startsAt,
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

  String fetchBeaconDetail(String id) {
    return '''
        query{
          beacon(id:"$id"){
            _id
            title
            leader{
              name
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
              title
              location{
                lat
                lon
              }
            }
            location{
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

  final beaconLocationSubGql = gql(r'''
    subscription StreamBeaconLocation($id: ID!){
      beaconLocation(id: $id){
        lat
        lon
      }
    }
  ''');

  // Gql for oreder updated subscription.
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
