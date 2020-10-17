import 'package:encrypt/encrypt.dart';
import 'package:kaladasava/static/staticadd.dart';

class CipherService{

static String encryp(String text) {
  final key = Key.fromUtf8(constCipher.substring(16,48));
  final iv = IV.fromUtf8(constCipher.substring(64,80));
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}

static String decryp(String text) {
  final key = Key.fromUtf8(constCipher.substring(16,48));
  final iv = IV.fromUtf8(constCipher.substring(64,80));
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decrypted;
}

}