import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';

class UrunlerSayfasi extends StatelessWidget {
  const UrunlerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

    Future<void> UrunSil(String urun_id) async {
      refUrun.child(urun_id).remove();
      Get.back();
    }

    Future<void> eminMisin(String urun_id, String urun_ad) async {
      Get.dialog(AlertDialog(
        backgroundColor: const Color.fromARGB(255, 55, 47, 47),
        shadowColor: const Color.fromARGB(255, 42, 41, 41),
        title: Text(
          "$urun_ad silmek istiyor musunuz ?",
          style: TextStyle(color: Color(yaziColor)),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 5.0,
                      color: Color.fromARGB(255, 19, 102, 21),
                    ),
                  ),
                  onPressed: () {
                    UrunSil(urun_id);
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 19, 102, 21),
                    size: 32,
                  ),
                  label: Text(
                    "Evet",
                    style: TextStyle(color: Color(yaziColor), fontSize: 21),
                  )),
              OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 5.0,
                      color: Color.fromARGB(255, 152, 34, 26),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Color.fromARGB(255, 152, 34, 26),
                    size: 32,
                  ),
                  label: Text(
                    "Hayır",
                    style: TextStyle(color: Color(yaziColor), fontSize: 21),
                  )),
            ],
          )
        ],
      ));
    }

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
          if (event.hasData) {
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
                  return GestureDetector(
                    onTap: () {},
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
                                          fontSize: 18,
                                          color: Color(yaziColor))),
                                  const SizedBox(height: 8),
                                  Text('Fiyat: $tamFiyat \u{20BA}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(yaziColor))),
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
                                    eminMisin(urunS.urun_id, urunS.urun_ad);
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Color(backgColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Urunler",
                  style: TextStyle(color: Color(yaziColor)),
                ),
              ),
              body: Center(
                child: Text(
                  "Urun Bulunamadı",
                  style: TextStyle(color: Color(yaziColor)),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
