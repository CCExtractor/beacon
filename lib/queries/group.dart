import 'package:graphql_flutter/graphql_flutter.dart';

class GroupQueries {
  String createGroup(String title) {
    return '''
        mutation{
          createGroup(group: {
            title: "$title"
            }
           )
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            members {
              _id
              name
            }
            beacons
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
            }
          }
        }
    ''';
  }

  String joinGroup(String shortcode) {
    return '''
      mutation{
          joinGroup(
            shortcode: "$shortcode"
           )
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            members {
              _id
              name
            }
            beacons
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
            }
          }
        }
    ''';
  }

  String groupDetail(String id) {
    return '''
      query{
        group(id:"$id")
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            members {
              _id
              name
            }
            beacons
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
            }
          }
      }
    ''';
  }

  final groupJoinedSubGql = gql(r'''
    subscription StreamNewlyJoinedGroups($id: ID!){
      groupJoined(id: $id){
        name
        location{
          lat
          lon
        }
      }
    }
  ''');
}
