// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/SepetController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';
import 'package:intl/intl.dart';

class SepetSayfa extends StatelessWidget {
  SepetSayfa({Key? key}) : super(key: key);
  final sepetCont = Get.put(SepetController());
  DateTime anlikTarih = DateTime.now();
  DateFormat tarihFormati = DateFormat("yyyy-MM-dd");

  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;

  @override
  Widget build(BuildContext context) {
    num urunToplamFiyat = 0.0;

    var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Text(
          "Sepetim",
          textAlign: TextAlign.start,
          style: TextStyle(color: Color(yaziColor)),
        ),
        actions: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(backgroundColor: Color(yaziColor)),
            onPressed: () {
              Get.toNamed("/SepetEkle");
              VibrationController().tip(titresimTip: "light");
            },
            icon: Icon(
              Icons.add_circle,
              color: Color(barColor),
            ),
            label: Text(
              "Ürün Ekle",
              style: TextStyle(color: Color(barColor)),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: refUrun.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (event.hasError) {
            return Center(child: Text("Hata: ${event.error}"));
          } else if (!event.hasData || event.data?.snapshot.value == null) {
            return const Center(child: Text("Sepet Boş"));
          } else {
            var urunListe = <Urunler>[];
            var gelenSepetUrun = event.data!.snapshot.value as dynamic;
            if (gelenSepetUrun != null) {
              gelenSepetUrun.forEach((key, nesne) {
                var gelen = Urunler.fromJson(key, nesne);
                urunListe.add(gelen);
              });
            }
            return GetBuilder<SepetController>(
              builder: (controller) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.sepetListesi.length,
                        itemBuilder: (context, i) {
                          var sepet = controller.sepetListesi[i];

                          urunToplamFiyat = sepet.urun_fiyat * sepet.sepet_adet;
                          String kusurSil = urunToplamFiyat.toStringAsFixed(2);
                          urunToplamFiyat = double.parse(kusurSil);

                          for (int a = 0; a < urunListe.length; a++) {
                            if (sepet.sepet_id == urunListe[a].urun_id) {
                              sepet.stok_adet = urunListe[a].urun_adet;
                            }
                          }
                          if (sepet.sepet_adet > sepet.stok_adet) {
                            int fark = sepet.sepet_adet - sepet.stok_adet;
                            controller.toplamGuncelle(sepet.urun_fiyat, fark);
                            sepet.sepet_adet = sepet.stok_adet;
                          }

                          return Card(
                            color: Color(butonColor),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sepet.sepet_ad,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(yaziColor)),
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Birim Fiyatı: ${sepet.urun_fiyat}\u{20BA}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(yaziColor)),
                                            ),
                                            Text(
                                              "Fiyat : ${urunToplamFiyat.toStringAsFixed(2)} \u{20BA}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(yaziColor)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                VibrationController()
                                                    .tip(titresimTip: "light");
                                                sepet.sepet_adet > 1
                                                    ? controller.azaltSepetAdet(
                                                        sepet.sepet_id,
                                                        sepet.urun_fiyat)
                                                    : null;
                                              },
                                              icon: const Icon(Icons.remove),
                                              color: Color(backgColor),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Adet: ${sepet.sepet_adet}",
                                              style: TextStyle(
                                                  color: Color(yaziColor)),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {
                                                VibrationController()
                                                    .tip(titresimTip: "light");
                                                (sepet.sepet_adet <
                                                        sepet.stok_adet)
                                                    ? controller
                                                        .arttirSepetAdet(
                                                            sepet.sepet_id,
                                                            sepet.urun_fiyat)
                                                    : null;
                                              },
                                              icon: const Icon(Icons.add),
                                              color: Color(backgColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Stok: ${sepet.stok_adet}",
                                              style: TextStyle(
                                                  color: Color(yaziColor)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          VibrationController()
                                              .tip(titresimTip: "cancel");
                                          controller.urunSil(
                                              sepet.sepet_id,
                                              sepet.urun_fiyat,
                                              sepet.sepet_adet);
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Color(backgColor)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: -3,
                                  blurRadius: 5,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Center(
                                  child: Text(
                                    "Tutar: ${controller.toplamFiyat.toStringAsFixed(2)}\u{20BA}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(yaziColor),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                color: Color(barColor),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Alışverişi tamamla işlemlerini burada yap
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Color(yaziColor),
                                    size: 48,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero)),
                                  label: Text(
                                    "Alışverişi Tamamla",
                                    style: TextStyle(
                                      color: Color(yaziColor),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
