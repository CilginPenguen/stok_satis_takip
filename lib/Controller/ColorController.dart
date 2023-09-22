// ignore_for_file: file_names, camel_case_types

import 'package:get/get.dart';

class renkKontrol extends GetxController {
  var backbg = 0.obs;
  var barBg = 0.obs;
  var yazi = 0.obs;
  var buton = 0.obs;

  void guncelle(int backbgR, int barBgR, int yaziR, int butonR) {
    backbg.value = backbgR;
    barBg.value = barBgR;
    yazi.value = yaziR;
    buton.value = butonR;
  }
}
