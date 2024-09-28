abstract class UseCase<Type, Paramas> {
  Future<Type> call(Paramas paramas);
}
