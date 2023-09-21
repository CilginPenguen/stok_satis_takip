import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';

class SepetSayfa extends StatelessWidget {
  const SepetSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;
    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(),
    );
  }
}
