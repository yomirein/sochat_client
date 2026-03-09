import 'package:cryptography/cryptography.dart';

class SenderKey {
  int keyVersion;
  SecretKey key;

  SenderKey({required this.keyVersion, required this.key});
}