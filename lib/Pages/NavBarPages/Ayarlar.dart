// ignore_for_file: must_be_immutable
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:stok_satis_takip/Cores/RenkAyar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';

class Ayarlar extends StatelessWidget {
  Ayarlar({super.key});

  var refAyar = FirebaseDatabase.instance.ref().child("Ayarlar");

  // ignore: non_constant_identifier_names
  Future<void> renksec(String renk_id, int renk_kod) async {
    int secRenk = renk_kod;
    await Get.dialog(AlertDialog(
      title: const Text("Renk Seçiniz"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: Color(renk_kod),
          onColorChanged: (color) {
            secRenk = color.value;
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              guncelle(renk_id, secRenk);
            },
            child: const Text("Değiştir"))
      ],
    ));
  }

  Future<void> guncelle(String renk_id, int renk_kod) async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["renk_kod"] = renk_kod;
    await refAyar.child(renk_id).update(bilgi);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
        stream: refAyar.onValue,
        builder: (context, event) {
          if (event.hasData) {
            var ayarListe = <RenkAyar>[];
            var gelenAyarlar = event.data!.snapshot.value as dynamic;
            if (gelenAyarlar != null) {
              gelenAyarlar.forEach((key, nesne) {
                var gelenAyar = RenkAyar.fromJson(key, nesne);
                ayarListe.add(gelenAyar);
              });
            }
            int backg = ayarListe[0].renk_kod;
            int barBg = ayarListe[1].renk_kod;
            int yazi = ayarListe[2].renk_kod;
            int buton = ayarListe[3].renk_kod;

            Get.find<renkKontrol>().guncelle(backg, barBg, yazi, buton);

            return Scaffold(
              backgroundColor: Color(backg),
              appBar: AppBar(
                backgroundColor: Color(barBg),
                title: Text("Ayarlar", style: TextStyle(color: Color(yazi))),
              ),
              body: Center(
                child: ListView.builder(
                  itemCount: ayarListe.length,
                  itemBuilder: (context, i) {
                    var ayar = ayarListe[i];
                    return GestureDetector(
                      onTap: () {
                        renksec(ayar.renk_id, ayar.renk_kod);
                      },
                      child: Card(
                        color: Color(buton),
                        child: SizedBox(
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ayar.renk_aciklama,
                                  style: TextStyle(
                                      color: Color(yazi), fontSize: 15),
                                ),
                                Text(
                                  "Ayarla",
                                  style: TextStyle(color: Color(yazi)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Ayarlar Gelmedi"),
            );
          }
        });
  }
}
