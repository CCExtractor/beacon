import 'package:graphql_flutter/graphql_flutter.dart';

class GroupQueries {
  String fetchUserGroups(int page, int pageSize) {
    return '''
    query {
      groups(page: $page, pageSize: $pageSize) {
        _id
        title
        beacons{
               _id
        }
        leader{
               _id
               name
        }
        members{
               _id
               name
        }
       shortcode
       __typename
      }
    }
  ''';
  }

  String createGroup(String? title) {
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

  String joinGroup(String? shortcode) {
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
            beacons{
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

  String groupDetail(String? id) {
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
            }
          }
      }
    ''';
  }

  String fetchHikes(String groupID, int page, int pageSize) {
    return '''
query{
  beacons(groupId: "$groupID", page: $page, pageSize: $pageSize){
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
              group{
                _id
              }
              startsAt
              expiresAt

  }
}
''';
  }

  String changeShortCode(String groupId) {
    return '''
       mutation{
       changeShortcode(groupId: "$groupId"){
       _id
        title
        beacons{
               _id
        }
        leader{
               _id
               name
        }
        members{
               _id
               name
        }
       shortcode
       __typename
       }
       }

''';
  }

  final groupUpdateSubGql = gql(r'''
  subscription groupUpdate($groupIds: [ID!]!) {
    groupUpdate(groupIds: $groupIds) {
        groupId
        
        newUser{
        _id
        name
        email
        }

        newBeacon{
        _id
        title
        leader {
          _id
          name
          email
        }
        followers {
          _id
          name
        }
        group{
        _id
        }
        location {
          lat
          lon
        }
        shortcode
        startsAt
        expiresAt
      }

      deletedBeacon{
      _id
        title
        leader {
          _id
          name
          email
        }
        followers {
          _id
          name
        }
        group{
        _id
        }
        location {
          lat
          lon
        }
        shortcode
        startsAt
        expiresAt
      }

      updatedBeacon{
      _id
        title
        leader {
          _id
          name
          email
        }
        followers {
          _id
          name
        }
        group{
        _id
        }
        location {
          lat
          lon
        }
        shortcode
        startsAt
        expiresAt
      }
      }
  }
''');

  String removeMember(String groupId, String memberId) {
    return '''
      mutation{
        removeMember(groupId: "$groupId", memberId: "$memberId"){
        _id
        name
        email
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
