class AuthQueries {
  String registerUser(String? name, String email, String? password) {
    return '''
        mutation{
          register(user: {name: "$name", credentials: {email: "$email", password: "$password"}})
          {
            _id
            name
            email
            imageUrl
          }
        }
    ''';
  }

  String gAuth(String? name, String email, String? imageUrl) {
    return '''
        mutation{
          oAuth(userInput: {email: "$email", name: "$name", imageUrl: "$imageUrl"})
        }
    ''';
  }

  String loginAsGuest(String? name) {
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

  String sendVerficationCode(String? email) {
    return '''
        mutation{
          sendVerificationCode(email: "$email")
        }
    ''';
  }

  String completeVerificationCode(String? userId) {
    return '''
        mutation{
           completeVerification(
                userId: "$userId"
           ){
               _id
               email
               name
               groups{
                _id
               }
               isVerified
               beacons{
                _id
               }
           }
        }
    ''';
  }

  String loginUser(String email, String? password) {
    return '''
        mutation{
          login(credentials: {email: "$email", password: "$password"})
        }
    ''';
  }

  String loginUsingID(String? id) {
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
          isVerified
          imageUrl
          groups{
            _id
          }
          beacons{
            _id
          }
        }
      }
    ''';
  }
}
