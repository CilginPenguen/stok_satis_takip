// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/UrunController.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Boş Bırakılamaz alana tıklanınca klavyeyi kapat
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
        resizeToAvoidBottomInset: true,
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
                      EkranUyari().snackCikti(true, "Bu Barkod Zaten Kayıtlı.");
                      kontrol = false;
                      break;
                    }
                  }
                  if (kontrol) {
                    EkranUyari().snackCikti(
                        false, "Bu Barkodda Ürün Yok Devam Edebilirsiniz.");
                    tfBarkod.text = tarananBarkod;
                  }
                } else {
                  Get.offAll(BotNavBar());
                }
              }

              return SingleChildScrollView(
                child: Padding(
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
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            color: Color(butonColor))),
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
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(butonColor), width: 5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Barkodsuz Kayıt İçin Sürükleyin",
                              style: TextStyle(color: Color(yaziColor)),
                            ),
                            Obx(
                              () => Switch(
                                value: boolcuk.value,
                                activeColor:
                                    const Color.fromARGB(255, 0, 70, 3),
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
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderSide:
                                      BorderSide(color: Color(yaziColor)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: tfUrunAdet,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Boş Bırakılamaz';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Adet",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Color(butonColor)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(yaziColor)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                errorText:
                                    tfUrunAdet.text.isEmpty ? 'Boş' : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: tfUrunFiyat,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Boş Bırakılamaz';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Ürün Fiyatını Gir",
                                      helperText: "Tam Kısmı Buraya Girin",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            color: Color(butonColor)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Color(yaziColor)),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      errorText: tfUrunFiyat.text.isEmpty
                                          ? 'Boş Bırakılamaz'
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text("."),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: TextFormField(
                                    controller: tfUrunKurus,
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Boş Bırakılamaz';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Kuruş Giriniz",
                                      helperText: "Kuruş",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            color: Color(butonColor)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Color(yaziColor)),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      errorText: tfUrunKurus.text.isEmpty
                                          ? 'Boş Bırakılamaz'
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(butonColor),
                        ),
                        onPressed: () {
                          if (boolcuk.value) {
                            tfBarkod.text = ".";
                            UrunIslem().urunKayit(
                                tfBarkod.text,
                                tfUrunAd.text,
                                int.parse(tfUrunAdet.text),
                                int.parse(tfUrunFiyat.text),
                                int.parse(tfUrunKurus.text));
                          } else {
                            UrunIslem().urunKayit(
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
