import 'dart:typed_data';

import 'package:webcrypto/webcrypto.dart';

class AppE2EE {
  // static Uint8List? derivedBits;
  // static AesGcmSecretKey? aesGcmSecretKey;

  Future<Map<String,dynamic>> getKeys() async {
    // final prefs = await SharedPreferences.getInstance();
    // String derivedBitsString = (prefs.getString('derivedBits') ?? '');
    // if (derivedBitsString.isNotEmpty) {
    //   derivedBits = Uint8List.fromList(derivedBitsString.codeUnits);
    //   print('derivedBits present');
    //   return;
    // }

    KeyPair<EcdhPrivateKey, EcdhPublicKey>? keyPair;

    keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    Map<String, dynamic> publicKeyJwk =
        await keyPair.publicKey.exportJsonWebKey();

    Map<String, dynamic> privateKeyJwk =
        await keyPair.privateKey.exportJsonWebKey();

    // Get.find<HiveDBHelper>().privateKey=privateKeyJwk;
    //
    // if (kDebugMode) {
    //   print('keypair $keyPair, $publicKeyJwk, $privateKeyJwk');
    // }
    return {
      "privateKey":privateKeyJwk,
      "publicKey":publicKeyJwk
    };

    // deriveBits();
  }

  // static Future<void> deriveBits() async {
  //   // 2. Derive bits
  //   derivedBits = await keyPair!.privateKey.deriveBits(256, keyPair!.publicKey);
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('derivedBits', String.fromCharCodes(derivedBits!));
  //   print('derivedBits $derivedBits');
  // }
  //
  static Future<String> encrypt(String message,EcdhPrivateKey senderPrivateKey,EcdhPublicKey receiverPublicKey) async {
    final Uint8List iv =
    Uint8List.fromList('Initialization Vector'.codeUnits);
    final derivedBits=await senderPrivateKey.deriveBits(256, receiverPublicKey);

    List<int> list = message.codeUnits;
    Uint8List data = Uint8List.fromList(list);
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(derivedBits);
    final encryptedBytes=await aesGcmSecretKey.encryptBytes(data, iv);
    String encryptedString = String.fromCharCodes(encryptedBytes);

    print('encryptedString $encryptedString');
    return encryptedString;
  }
  //
  static Future<String> decrypt(String encryptedMessage,EcdhPublicKey senderPublicKey,EcdhPrivateKey receiverPrivateKey) async {
    final derivedBits=await receiverPrivateKey.deriveBits(256, senderPublicKey);
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(derivedBits);
    final Uint8List iv =
    Uint8List.fromList('Initialization Vector'.codeUnits);
    List<int> message = Uint8List.fromList(encryptedMessage.codeUnits);
    Uint8List decryptdBytes = await aesGcmSecretKey.decryptBytes(message, iv);
    String decryptdString = String.fromCharCodes(decryptdBytes);

    print('decryptdString $decryptdString');
    return decryptdString;
  }
}
