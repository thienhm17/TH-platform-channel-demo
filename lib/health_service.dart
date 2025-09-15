import 'package:flutter/services.dart';

class HealthService {
  static const _channel = MethodChannel("dev.thienhuynh.stepCounter/getSteps");

  static Future<bool> requestAuthorization() async {
    return await _channel.invokeMethod("requestAuthorization");
  }

  static Future<double?> getSteps() async {
    return await _channel.invokeMethod("getSteps");
  }
}