import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/SepetController.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';

class SepetEkleSayfasi extends StatelessWidget {
  const SepetEkleSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final sepetController = Get.put(SepetController());
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    var refUrun = FirebaseDatabase.instance.ref().child("Urunler");
    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Text(
          "Ürünler",
          style: TextStyle(color: Color(yaziColor)),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refUrun.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (event.hasError) {
            return Center(child: Text("Hata: ${event.error}"));
          } else if (!event.hasData || event.data?.snapshot.value == null) {
            return const Center(child: Text("Veri Bulunamadı"));
          } else {
            var urunListe = <Urunler>[];
            var gelenUrunler = event.data!.snapshot.value as dynamic;
            if (gelenUrunler != null) {
              gelenUrunler.forEach((key, nesne) {
                var gelenUrun = Urunler.fromJson(key, nesne);
                urunListe.add(gelenUrun);
              });
            }

            return ListView.builder(
                itemCount: urunListe.length,
                itemBuilder: (context, i) {
                  var urunS = urunListe[i];
                  String fiyatText = "${urunS.urun_fiyat}.${urunS.urun_kurus}";
                  double tamFiyat = double.parse(fiyatText);
                  return Card(
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  sepetController.sepeteUrunEkle(
                                      sepet_id: urunS.urun_id,
                                      sepet_ad: urunS.urun_ad,
                                      stok_adet: urunS.urun_adet,
                                      urun_fiyat: urunS.urun_fiyat,
                                      urun_kurus: urunS.urun_kurus,
                                      sepet_adet: 0);
                                },
                                icon: Icon(Icons.plus_one,
                                    color: Color(backgColor)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
