// ignore_for_file: file_names, must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:stok_satis_takip/Controller/ClockController.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Gecmis.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';

class AnaSayfa extends StatelessWidget {
  final ClockController clockController = Get.put(ClockController());

  RxDouble totalCiro = 0.0.obs;
  RxInt limit = 0.obs;

  AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    var refGecmis = FirebaseDatabase.instance.ref().child("Gecmis");
    var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

    //Renkleri Getirmek için kullandığım Get metotları
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    Rx<DateTime> anlikTarih = DateTime.now().obs;
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
            StreamBuilder<DatabaseEvent>(
                stream: refGecmis.onValue,
                builder: (context, event) {
                  if (event.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (event.hasError) {
                    return Center(child: Text("Hata: ${event.error}"));
                  } else if (!event.hasData ||
                      event.data?.snapshot.value == null) {
                    return Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Günlük Kazanç: 0.0",
                          style:
                              TextStyle(fontSize: 28, color: Color(yaziColor)),
                        ),
                      ],
                    ));
                  } else {
                    var gecmisListe = <Gecmis>[];
                    var gelenGecmis = event.data!.snapshot.value as dynamic;
                    if (gelenGecmis != null) {
                      totalCiro.value = 0.0;
                      gelenGecmis.forEach((key, nesne) {
                        if (nesne["tarih"] ==
                            tarihFormati.format(anlikTarih.value)) {
                          var gelenGecmis = Gecmis.fromJson(key, nesne);
                          gecmisListe.add(gelenGecmis);
                          totalCiro.value += gelenGecmis.urun_toplam;
                        }
                      });
                    }
                    return Text(
                      "Günlük Kazanç: $totalCiro",
                      style: TextStyle(fontSize: 28, color: Color(yaziColor)),
                    );
                  }
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
                StreamBuilder(
                    stream: refUrun.onValue,
                    builder: (context, event) {
                      if (event.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (event.hasError) {
                        return Center(child: Text('Error: ${event.error}'));
                      } else if (!event.hasData ||
                          event.data?.snapshot.value == null) {
                        return const Center(child: Text('No data available'));
                      } else {
                        String? limitStr = GetStorage().read("limit");
                        if (limitStr != null) {
                          limit.value = int.parse(limitStr);
                        }
                        var urunListe = <Urunler>[];
                        var gelenUrunler =
                            event.data!.snapshot.value as dynamic;
                        if (gelenUrunler != null) {
                          gelenUrunler.forEach((key, nesne) {
                            //print(nesne["urun_ad"].runtimeType); //bu önemli
                            if (limit.value >= nesne["urun_adet"]) {
                              var gelenUrun = Urunler.fromJson(key, nesne);
                              urunListe.add(gelenUrun);
                            }
                          });
                        }
                        return SizedBox(
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
                              "Stok Az: ${urunListe.length}",
                              style: urunListe.isNotEmpty
                                  ? const TextStyle(
                                      color: Colors.red, fontSize: 18)
                                  : TextStyle(
                                      color: Color(yaziColor), fontSize: 15),
                            ),
                            icon: Icon(
                              Icons.warning,
                              color: Color(yaziColor),
                            ),
                          ),
                        );
                      }
                    }),
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
