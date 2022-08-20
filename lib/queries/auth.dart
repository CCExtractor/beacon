class AuthQueries {
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

  String loginAsGuest(String name) {
    return '''
        mutation{
          register(user: {name: "$name"})
          {
            _id
            name
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

  String loginUsingID(String id) {
    return '''
        mutation{
          login(id: "$id")
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
          groups{
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
            }
          }
          beacons{
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            followers{
              _id
              name
            }
            location {
              lat
              lon
            }
            startsAt
            expiresAt
          }
        }
      }
    ''';
  }
}
