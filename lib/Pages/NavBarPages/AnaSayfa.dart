// ignore_for_file: file_names

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ClockController.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/GecmisController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';

class AnaSayfa extends StatelessWidget {
  final ClockController clockController = Get.put(ClockController());

  AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    //Renkleri Getirmek için kullandığım Get metotları
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Obx(() {
          String saat = clockController.currentTime.value.hour < 10
              ? "0${clockController.currentTime.value.hour}"
              : "${clockController.currentTime.value.hour}";
          String dakika = clockController.currentTime.value.minute < 10
              ? "0${clockController.currentTime.value.minute}"
              : "${clockController.currentTime.value.minute}";
          String saniye = clockController.currentTime.value.second < 10
              ? "0${clockController.currentTime.value.second}"
              : "${clockController.currentTime.value.second}";
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ana Sayfa",
                style: TextStyle(color: Color(yaziColor)),
              ),
              Text(
                "$saat:$dakika:$saniye",
                style: TextStyle(color: Color(yaziColor)),
              ),
            ],
          );
        }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Ciro Buraya Gelicek",
              style: TextStyle(fontSize: 33, color: Color(yaziColor)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(butonColor),
                    ),
                    onPressed: () {
                      Get.toNamed("/urunEkle");
                      VibrationController().tip(titresimTip: "light");
                    },
                    label: Text(
                      "Ürün Ekle",
                      style: TextStyle(color: Color(yaziColor), fontSize: 17),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Color(yaziColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(butonColor)),
                    onPressed: () {
                      VibrationController().tip(titresimTip: "light");
                      Get.toNamed("/Sepet");
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Color(yaziColor),
                    ),
                    label: Text(
                      "Alışveriş",
                      style: TextStyle(color: Color(yaziColor), fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(butonColor)),
                    onPressed: () {
                      VibrationController().tip(titresimTip: "light");
                      Get.toNamed("StokSayfa");
                    },
                    label: Text(
                      "Stok Az: 50",
                      style: TextStyle(color: Color(yaziColor), fontSize: 15),
                    ),
                    icon: Icon(
                      Icons.warning,
                      color: Color(yaziColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(butonColor)),
                    onPressed: () {
                      VibrationController().tip(titresimTip: "light");
                      Get.toNamed("/Gecmis");
                    },
                    label: Text(
                      "Geçmiş ",
                      style: TextStyle(color: Color(yaziColor), fontSize: 16),
                    ),
                    icon: Icon(
                      Icons.restore_outlined,
                      color: Color(yaziColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
