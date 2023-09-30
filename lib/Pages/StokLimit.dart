// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/StokController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';

class StokLimit extends StatelessWidget {
  StokLimit({super.key});
  var refUrun = FirebaseDatabase.instance.ref().child("Urunler");
  var tfLimit = TextEditingController();

  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;
  final stokLimit stokController = Get.put(stokLimit());

  @override
  Widget build(BuildContext context) {
    tfLimit.text = (GetStorage().read("limit")).toString();
    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Text(
          "Stok Kontrol",
          style: TextStyle(color: Color(yaziColor), fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SizedBox(
              height: 40,
              width: 75,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color(butonColor), width: 5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Color(yaziColor)),
                  controller: tfLimit,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    //int limit = int.parse(value);
                    //VibrationController().tip(titresimTip: "light");
                    //GetStorage().write("limit", limit);
                    stokController.setLimit(int.parse(value));
                  },
                ),
              ),
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
            return Center(child: Text('Error: ${event.error}'));
          } else if (!event.hasData || event.data?.snapshot.value == null) {
            return const Center(child: Text('No data available'));
          } else {
            var urunListe = <Urunler>[];
            var gelenUrunler = event.data!.snapshot.value as dynamic;
            if (gelenUrunler != null) {
              gelenUrunler.forEach((key, nesne) {
                //print(nesne["urun_ad"].runtimeType); //bu önemli
                int limit = GetStorage().read("limit");
                if (limit >= nesne["urun_adet"]) {
                  var gelenUrun = Urunler.fromJson(key, nesne);
                  urunListe.add(gelenUrun);
                }
              });
            }
            return ListView.builder(
              itemCount: urunListe.length,
              itemBuilder: (context, i) {
                var urunS = urunListe[i];
                String fiyatText = "${urunS.urun_fiyat}";
                double tamFiyat = double.parse(fiyatText);
                return GestureDetector(
                  onTap: () {
                    EkranUyari().urunGuncelle(
                        mesaj: "${urunS.urun_ad} Güncelle",
                        barkodVarMi: urunS.urun_barkod == "." ? false : true,
                        barkod: urunS.urun_barkod,
                        urun_ad: urunS.urun_ad,
                        urun_adet: urunS.urun_adet,
                        urun_fiyat: urunS.urun_fiyat,
                        urun_id: urunS.urun_id);
                  },
                  child: Card(
                    color: Color(butonColor),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(urunS.urun_ad,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(yaziColor))),
                                const SizedBox(height: 8),
                                Text('Fiyat: $tamFiyat \u{20BA}',
                                    style: TextStyle(
                                        fontSize: 16, color: Color(yaziColor))),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Stok : ${urunS.urun_adet}",
                                  style: TextStyle(color: Color(yaziColor)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
