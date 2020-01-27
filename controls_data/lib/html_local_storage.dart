import 'package:universal_html/prefer_sdk/html.dart';
import 'local_storage_interface.dart';

class PlataformLocalStorage extends LocalStorageInterface {
  Storage _storage = window.localStorage;
  init() async {}
  setKey(key, value) {
    _storage[key] = value;
  }

  getKey(key) {
    return _storage[key];
  }

  @override
  dispose() {}
}
