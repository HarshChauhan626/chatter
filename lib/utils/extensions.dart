import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

extension ColorTintGenerator on Color{
  Color darken([int percent=10]){
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        alpha,
        (red * f).round(),
        (green  * f).round(),
        (blue * f).round()
    );
  }

  Color lighten([int percent=10]){
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        alpha,
        red + ((255 - red) * p).round(),
        green + ((255 - green) * p).round(),
        blue + ((255 - blue) * p).round()
    );
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