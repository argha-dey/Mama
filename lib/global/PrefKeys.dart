import 'package:hive/hive.dart';

class PrefKeys {
  static const String LANG = 'Language';
  static const String MAMA_APP_DEVICE_TOKEN = 'app_device_token';
  static const String AUTH_TOKEN = 'auth_token';
  static const String IS_LOGIN_STATUS = 'is_login';
  static const String USER_ID = 'mama_user_id';
  static const String USER_TYPE = 'user_type';
  static const String USER_NAME = 'name_en';
}

class PrefObj {
  static Box? preferences;
}
