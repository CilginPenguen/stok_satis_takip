// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';

class ClockController extends GetxController {
  var currentTime = DateTime.now().obs;
  late Timer _timer;

  @override
  void onInit() {
    // Her saniyede bir saat bilgisini güncelle
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });

    super.onInit();
  }

  @override
  void onClose() {
    // Timer kapatılmalı
    _timer.cancel();
    super.onClose();
  }
}
