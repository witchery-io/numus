import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';

class EncryptHelper {
  final pin;
  encrypt.IV _iv;
  encrypt.Encrypter _encrypter;

  EncryptHelper({@required this.pin}) {
    final md5Pin = convertToMd5(pin);
    final key = encrypt.Key.fromUtf8(md5Pin);
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  encrypt.Encrypted encryptByPin(val) {
    return _encrypter.encrypt(val, iv: _iv);
  }

  String decryptByPinByBase64(val) {
    try {
      return _encrypter.decrypt64(val, iv: _iv);
    } catch (_) {
      throw Exception('Pin is wrong');
    }
  }

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}
