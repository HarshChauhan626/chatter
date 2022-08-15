import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../utils/app_strings.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HiveDBHelper {
  Box? userPreferenceBox;
  void initData() async {
    List<int> generatedKey = [
      213,
      61,
      167,
      5,
      148,
      20,
      11,
      127,
      18,
      146,
      196,
      139,
      158,
      37,
      24,
      142,
      119,
      150,
      80,
      96,
      217,
      103,
      14,
      228,
      47,
      242,
      124,
      47,
      189,
      166,
      54,
      181
    ];
    debugPrint(generatedKey.toString());
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    var userPreferenceBox = await Hive.openBox(AppStrings.userPreferences,
        encryptionCipher: HiveAesCipher(generatedKey));
    userPreferenceBox.put(AppStrings.isOnBoardingDone, true);
    debugPrint(userPreferenceBox.get(AppStrings.isOnBoardingDone).toString());
  }
}
