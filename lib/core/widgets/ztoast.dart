import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ZToast {
  static void success(BuildContext context, String message) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      icon: const Icon(Icons.check),
      showIcon: true,
    );
  }

  static void warning(BuildContext context, String message) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      icon: const Icon(Icons.error),
      showIcon: true,
    );
  }

  static void error(BuildContext context, String message) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      icon: const Icon(Icons.error),
      showIcon: true,
    );
  }
}
