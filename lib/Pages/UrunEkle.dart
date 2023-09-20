// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';
import 'package:stok_satis_takip/Pages/botnavbar.dart';

class UrunEklePage extends StatelessWidget {
  UrunEklePage({
    super.key,
  });

  var boolcuk = false.obs;
  String errorYaka = "";

  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;

  var tfBarkod = TextEditingController();
  var tfUrunAd = TextEditingController();
  var tfUrunAdet = TextEditingController();
  var tfUrunFiyat = TextEditingController();
  var tfUrunKurus = TextEditingController();

  var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

  Future<void> urunKayit(String urun_barkod, String urun_ad, int urun_adet,
      int urun_fiyat, int urun_kurus) async {
    try {
      if (urun_barkod.isEmpty ||
          urun_ad.isEmpty ||
          urun_adet <= 0 ||
          urun_fiyat <= 0 ||
          urun_kurus < 0 ||
          urun_kurus > 99) {
        // Hatalı giriş durumunda kırmızı arkaplanlı snackbar göster
        Get.snackbar("Hata", "Lütfen geçerli bilgileri girin",
            backgroundColor: const Color.fromARGB(255, 119, 11, 3),
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      var urun = HashMap<String, dynamic>();
      urun["urun_barkod"] = urun_barkod;
      urun["urun_ad"] = urun_ad;
      urun["urun_adet"] = urun_adet;
      urun["urun_fiyat"] = urun_fiyat;
      urun["urun_kurus"] = urun_kurus;
      await refUrun.push().set(urun);
      Get.offAllNamed("/");

      // Başarılı olduğunda yeşil arkaplanlı snackbar göster
      Get.snackbar("Başarılı", "Kayıt Başarıyla Tamamlandı",
          backgroundColor: const Color.fromARGB(255, 2, 108, 6),
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      // Hata alındığında kırmızı arkaplanlı snackbar göster
      Get.snackbar("Hata", "Hata: $error",
          backgroundColor: const Color.fromARGB(255, 119, 11, 3),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> barkodKontrolSnack(bool exists) async {
    if (exists) {
      Get.showSnackbar(const GetSnackBar(
        margin: EdgeInsets.only(bottom: 20),
        borderRadius: 20,
        borderColor: Color.fromARGB(255, 53, 1, 2),
        icon: Icon(
          Icons.warning,
          color: Colors.black,
        ),
        messageText: Text(
          "Barkod Zaten Kayıtlı",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ));
    } else {
      Get.showSnackbar(const GetSnackBar(
        margin: EdgeInsets.only(bottom: 20),
        borderRadius: 20,
        borderColor: Color.fromARGB(255, 1, 53, 8),
        icon: Icon(
          Icons.done,
          color: Colors.black,
        ),
        messageText: Text(
          "Barkod Kayıtlı Değil",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Boş alana tıklanınca klavyeyi kapat
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(backgColor),
        appBar: AppBar(
          backgroundColor: Color(barColor),
          title: Text(
            "Ürün Ekle",
            style: TextStyle(color: Color(yaziColor)),
          ),
        ),
        resizeToAvoidBottomInset: false,
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
              Future<void> barkodTara() async {
                String tarananBarkod = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                if (tarananBarkod != '-1') {
                  bool kontrol = true;
                  for (var urun in urunListe) {
                    if (urun.urun_barkod == tarananBarkod) {
                      barkodKontrolSnack(true);
                      kontrol = false;
                      break;
                    }
                  }
                  if (kontrol) {
                    barkodKontrolSnack(false);
                    tfBarkod.text = tarananBarkod;
                  }
                } else {
                  Get.offAll(BotNavBar());
                }
              }

              tfUrunKurus.text = "00";

              return Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => Visibility(
                        visible: !boolcuk.value,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: tfBarkod,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Barkod Alanı",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Color(butonColor))),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(yaziColor)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(butonColor),
                                  ),
                                  onPressed: () {
                                    barkodTara();
                                    VibrationController()
                                        .tip(titresimTip: "light");
                                  },
                                  icon: Icon(
                                    Icons.barcode_reader,
                                    color: Color(yaziColor),
                                  ),
                                  label: Text(
                                    "Barkod Tara",
                                    style: TextStyle(color: Color(yaziColor)),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(butonColor),
                                  ),
                                  onPressed: () {
                                    VibrationController()
                                        .tip(titresimTip: "light");
                                    tfBarkod.text = "";
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Color(yaziColor),
                                  ),
                                  label: Text(
                                    "Temizle",
                                    style: TextStyle(color: Color(yaziColor)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Barkodsuz Kayıt İçin Sürükleyin",
                          style: TextStyle(color: Color(yaziColor)),
                        ),
                        Obx(
                          () => Switch(
                            value: boolcuk.value,
                            activeColor: const Color.fromARGB(255, 0, 70, 3),
                            inactiveThumbColor:
                                const Color.fromARGB(255, 129, 10, 2),
                            inactiveTrackColor: Colors.redAccent,
                            onChanged: (value) {
                              boolcuk.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: tfUrunAd,
                            decoration: InputDecoration(
                              hintText: "Ürün Adını Gir",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Color(butonColor))),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(yaziColor)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                5), // Optional: Açıklama için boşluk eklendi
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: tfUrunAdet,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Adet",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Color(butonColor))),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(yaziColor)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tfUrunFiyat,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: "Ürün Fiyatını Gir",
                              helperText: "Tam Kısmı Buraya Girin",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: Color(butonColor)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(yaziColor)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text("."),
                        const SizedBox(
                            width: 4), // Add some spacing between text fields
                        Expanded(
                          child: TextField(
                            controller: tfUrunKurus,
                            maxLength: 2,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: "Kuruş Giriniz",
                              helperText: "Kuruş",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: Color(butonColor)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(yaziColor)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(butonColor),
                      ),
                      onPressed: () {
                        if (boolcuk.value) {
                          tfBarkod.text = ".";
                          urunKayit(
                              tfBarkod.text,
                              tfUrunAd.text,
                              int.parse(tfUrunAdet.text),
                              int.parse(tfUrunFiyat.text),
                              int.parse(tfUrunKurus.text));
                        } else {
                          urunKayit(
                              tfBarkod.text,
                              tfUrunAd.text,
                              int.parse(tfUrunAdet.text),
                              int.parse(tfUrunFiyat.text),
                              int.parse(tfUrunKurus.text));
                        }
                      },
                      icon: Icon(
                        Icons.save,
                        color: Color(yaziColor),
                      ),
                      label: Text(
                        "Kaydet",
                        style: TextStyle(color: Color(yaziColor)),
                      ),
                    ),
                    SizedBox(
                      //bunu unutma ya hayat kurtarıyo :))
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("İnternet Bağlantınızı Kontrol Edin"),
              );
            }
          },
        ),
      ),
    );
  }
}
