import 'package:flutter/services.dart';

class VibrationController {
  void tip({required String titresimTip}) {
    switch (titresimTip) {
      case "light":
        HapticFeedback.lightImpact();
        break;
      case "medium":
        HapticFeedback.mediumImpact();
        break;
      case "heavy":
        HapticFeedback.heavyImpact();
        break;
      case "success":
        HapticFeedback.lightImpact();
        Future.delayed(const Duration(milliseconds: 250), () {
          HapticFeedback.heavyImpact();
        });
        break;
      case "cancel":
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 125), () {
          HapticFeedback.heavyImpact();
        });
    }
  }
}
