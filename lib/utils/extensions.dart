import 'dart:ui';

extension ColorTintGenerator on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }

  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(alpha, red + ((255 - red) * p).round(),
        green + ((255 - green) * p).round(), blue + ((255 - blue) * p).round());
  }
}

extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));

  bool get containsLowercase => contains(RegExp(r'[a-z]'));

  bool get containsNumerics => contains(RegExp(r'[0-9]'));
}

extension CheckNeitherNullNorEmpty on String?{
  bool neitherNullNorEmpty(){
    if(this!=null && this!.isNotEmpty){
      return true;
  }
    return false;
  }

  bool isEitherNullOrEmpty(){
    if(this!=null || this!.isEmpty){
      return true;
    }
    return false;
  }

}

// extension FirebaseUserToUserModel on User{
//   UserModel toUserModel(){
//     return UserModel(
//       email: email,
//       userName: this.displayName
//     );
//   }
// }
