import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import '../utils/app_strings.dart';

class HiveDBHelper extends GetxController {
  Box? userPreferenceBox;

  bool _onboardingDone = false;

  bool get onboardingDone => _onboardingDone;

  set onboardingDone(bool onboardingDone) {
    _onboardingDone = onboardingDone;
    userPreferenceBox?.put(AppStrings.isOnBoardingDone, onboardingDone);
  }

  String? _currentChatId;

  String? get currentChatId => _currentChatId;

  set currentChatId(String? currentChatId) {
    _currentChatId = currentChatId;
    userPreferenceBox?.put(AppStrings.currentChatId, currentChatId);
  }

  List<String> _pinnedRoomIdList = <String>[];

  List<String>? get pinnedRoomIdList => _pinnedRoomIdList;

  void addPinnedRoomId(String roomId) {
    _pinnedRoomIdList.add(roomId);
    userPreferenceBox?.put(AppStrings.pinnedRoomIds, _pinnedRoomIdList);
  }

  Map<String, dynamic> _privateKey = <String, dynamic>{};

  set privateKey(Map<String, dynamic> privateKey) {
    _privateKey = privateKey;
    userPreferenceBox?.put(AppStrings.privateKey, privateKey);
  }

  Map<String, dynamic> get privateKey => _privateKey;

  Map<String, dynamic> _publicKey = <String, dynamic>{};

  set publicKey(Map<String, dynamic> publicKey) {
    _publicKey = publicKey;
    userPreferenceBox?.put(AppStrings.publicKey, publicKey);
  }

  Map<String, dynamic> get publicKey => _publicKey;

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
    _pinnedRoomIdList =
        userPreferenceBox?.get(AppStrings.pinnedRoomIds) ?? <String>[];
    _publicKey =
        userPreferenceBox?.get(AppStrings.publicKey) ?? <String, dynamic>{};
    _privateKey =
        userPreferenceBox?.get(AppStrings.privateKey) ?? <String, dynamic>{};
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

  Future<void> clearData()async {
    _publicKey=<String,dynamic>{};
    _privateKey=<String,dynamic>{};
    userPreferenceBox?.clear();
  }
}
