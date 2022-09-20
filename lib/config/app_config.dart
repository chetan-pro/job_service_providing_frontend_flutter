import 'dart:convert';

import 'package:flutter/services.dart';

abstract class BaseConfig {
  String get apiHost;
  bool get useHttps;
  bool get trackEvents;
  bool get reportErrors;
}
class DevConfig implements BaseConfig {
  String get apiHost => "demo";
  // String get razorPayKey => "rzp_live_ADKSwtmkyEay2D";

  bool get reportErrors => false;

  bool get trackEvents => false;

  bool get useHttps => false;
}
class StagingConfig implements BaseConfig {
  String get apiHost => "live";


  bool get reportErrors => true;

  bool get trackEvents => false;

  bool get useHttps => true;
}

class ProdConfig implements BaseConfig {
  String get apiHost => "live";

  // String get razorPayKey => "rzp_test_805HsMwhHeEpIE";


  bool get reportErrors => true;

  bool get trackEvents => true;

  bool get useHttps => true;
}

class Environment {
  factory  Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      case Environment.STAGING:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}

