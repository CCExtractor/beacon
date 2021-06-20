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
        }
      }
    ''';
  }
}
