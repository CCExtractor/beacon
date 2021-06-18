class Queries {
  String registerUser(String name, String email, String password) {
    return """
        mutation{
          register(user: {name: "$name", credentials: {email: "$email", password: "$password"}})
          {
            _id
            name
          }
        }
    """;
  }

  String loginUser(String id, String email, String password) {
    return """
        mutation{
          login(id: "$id", credentials: {email: "$email", password: "$password"})
        }
    """;
  }

  String fetchUserInfo = '''
    query me{
      email
      name
      _id
    }
  ''';
}
