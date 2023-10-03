// ignore_for_file: file_names

import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stok_satis_takip/Controller/ClockController.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/GecmisController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Gecmis.dart';

class AnaSayfa extends StatelessWidget {
  final ClockController clockController = Get.put(ClockController());
  var refGecmis = FirebaseDatabase.instance.ref().child("Gecmis");

  AnaSayfa({super.key});

  void fetchData() {
    DatabaseReference dbref = FirebaseDatabase.instance.ref().child("Gecmis");
    dbref.once().then((DatabaseEvent event) {
      List<Gecmis> dataList = [];
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          Gecmis gelen = Gecmis.fromJson(key, value);
          dataList.add(gelen);
        });

        // Print the dataList
        print(dataList);

        // Access each Gecmis instance
        for (Gecmis gecmis in dataList) {
          print("Gecmis ID: ${gecmis.urun_toplam}");
          // Access other properties and perform actions as needed
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Renkleri Getirmek için kullandığım Get metotları
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    DateTime anlikTarih = DateTime.now();
    DateFormat tarihFormati = DateFormat('yyyy-MM-dd');

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
            StreamBuilder(
                stream: refGecmis.onValue,
                builder: (context, ev) {
                  if (ev.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (ev.hasError) {
                    return Center(child: Text("Hata: ${ev.error}"));
                  } else if (!ev.hasData || ev.data?.snapshot.value == null) {
                    return Text(
                      "Günlük Ciro: 0",
                      style: TextStyle(fontSize: 33, color: Color(yaziColor)),
                    );
                  } else {
                    var gecmisListe = <Gecmis>[];
                    var gelenGecmisler = ev.data!.snapshot.value as dynamic;
                    if (gelenGecmisler != null) {
                      double toplamCiro = 0;
                      gelenGecmisler.forEach((key, nesne) {
                        if (nesne["tarih"] == tarihFormati.format(anlikTarih)) {
                          var gelenGecmis = Gecmis.fromJson(key, nesne);
                          gecmisListe.add(gelenGecmis);
                          toplamCiro += gelenGecmis.urun_toplam;
                        }
                      });
                      return Text(
                        "Günlük Ciro:$toplamCiro ",
                        style: TextStyle(fontSize: 33, color: Color(yaziColor)),
                      );
                    }
                  }
                  return const Text("Günlük Ciro:0");
                }),
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
                      fetchData();
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
