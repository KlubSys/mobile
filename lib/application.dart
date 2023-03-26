import 'package:klub/data/providers/apis/implementation/http_klub.api.dart';
import 'package:klub/data/providers/apis/implementation/local_klub.api.dart';
import 'package:klub/data/providers/apis/klub.api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Application {

  static const _storage = FlutterSecureStorage();
  
  static KlubApi klubApi = HttpKlubApi(); 
}
