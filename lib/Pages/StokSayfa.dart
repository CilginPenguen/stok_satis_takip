import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';

class StokSayfa extends StatelessWidget {
  const StokSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    int backgColor = Get.find<renkKontrol>().backbg.value;
    int barColor = Get.find<renkKontrol>().barBg.value;
    int butonColor = Get.find<renkKontrol>().buton.value;
    int yaziColor = Get.find<renkKontrol>().yazi.value;

    RxInt tfLimit = (int.parse(GetStorage().read("limit") ?? "0")).obs;

    var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Text(
          "Stok Limit",
          style: TextStyle(
            color: Color(yaziColor),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/");
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SizedBox(
              height: 40,
              width: 75,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(butonColor), width: 5),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(color: Color(yaziColor)),
                  controller: TextEditingController(text: "${tfLimit.value}"),
                  onChanged: (value) {
                    print(value);
                    if (value == "") {
                      value = "0";
                      print(value);
                    } else {
                      tfLimit.value = int.parse(value);
                      GetStorage().write("limit", value);
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
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
                var gelenUrun = Urunler.fromJson(key, nesne);
                urunListe.add(gelenUrun);
              });
            }

            return ListView.builder(
              itemCount: urunListe.length,
              itemBuilder: (context, i) {
                var urunS = urunListe[i];
                String fiyatText = "${urunS.urun_fiyat}";
                double tamFiyat = double.parse(fiyatText);

                return Obx(() {
                  int limit = tfLimit.value;
                  return Visibility(
                    visible: limit >= urunS.urun_adet,
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
                                  Text(
                                    urunS.urun_ad,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(yaziColor),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Fiyat: $tamFiyat \u{20BA}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(yaziColor),
                                    ),
                                  ),
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
                });
              },
            );
          }
        },
      ),
    );
  }
}
