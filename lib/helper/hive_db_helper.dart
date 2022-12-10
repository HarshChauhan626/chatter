import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../utils/app_strings.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HiveDBHelper extends GetxController {
  Box? userPreferenceBox;

  bool _onboardingDone = false;

  bool get onboardingDone => _onboardingDone;

  set onboardingDone(bool onboardingDone) {
    _onboardingDone = onboardingDone;
    userPreferenceBox?.put(AppStrings.isOnBoardingDone, onboardingDone);
  }

  String? _currentChatId;

  String? get currentChatId=>_currentChatId;

  set currentChatId(String? currentChatId){
    _currentChatId=currentChatId;
    userPreferenceBox?.put(AppStrings.currentChatId, currentChatId);
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    await initBoxes();
    await setUpData();
  }

  Future<void> setUpData() async {
    _onboardingDone =
        userPreferenceBox?.get(AppStrings.isOnBoardingDone) ?? false;
  }

  Future<void> initBoxes() async {
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
    userPreferenceBox = await Hive.openBox(AppStrings.userPreferences,
        encryptionCipher: HiveAesCipher(generatedKey));
  }
}
