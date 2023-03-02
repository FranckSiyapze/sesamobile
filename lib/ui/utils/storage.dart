import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
void setStorage(String key, String value) async {
  await storage.write(
    key: key,
    value: value,
  );
}

void setStorageAssetment({int? step, String? value}) async {
  await storage.write(
    key: "Assetment" + step.toString(),
    value: value,
  );
}

Future<String> readStorage({String? value}) async {
  final readStorage = await storage.read(key: value);
  return readStorage;
}

void deleteAllStorage() async {
  await storage.deleteAll();
}