// ignore: file_names
// ignore_for_file: must_be_immutable, file_names, duplicate_ignore

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/BarcodeController.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/UrunController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';

class UrunEklePage extends StatelessWidget {
  UrunEklePage({
    super.key,
  });

  var boolcuk = false.obs;

  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;

  var tfBarkod = TextEditingController();
  var tfUrunAd = TextEditingController();
  var tfUrunAdet = TextEditingController();
  var tfUrunFiyat = TextEditingController();

  var refUrun = FirebaseDatabase.instance.ref().child("Urunler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Barkod Alanı",
                                helperText: "Barkod",
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
                                onPressed: () async {
                                  tfBarkod.text = await BarcodeController()
                                      .barkodTara(urunListe: urunListe);
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
                                  EkranUyari()
                                      .snackCikti(false, "Barkod Temizlendi");
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
                      border: Border.all(color: Color(butonColor), width: 5),
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
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: tfUrunAd,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Ürün Adını Giriniz",
                            helperText: "Ürün Adı",
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
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: tfUrunAdet,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
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
                              borderSide: BorderSide(color: Color(butonColor)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(yaziColor)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorText: tfUrunAdet.text.isEmpty ? 'Boş' : null,
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
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.,]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Boş Bırakılamaz';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // Her değişiklikte kontrol ve düzenleme yap
                                  String newValue = value.replaceAll(',', '.');
                                  if (newValue.contains('.') &&
                                      newValue.split('.')[1].length > 2) {
                                    // En fazla 2 ondalık basamağa izin ver
                                    newValue = double.parse(newValue)
                                        .toStringAsFixed(2);
                                  }
                                  tfUrunFiyat.value = TextEditingValue(
                                    text: newValue,
                                    selection: TextSelection.collapsed(
                                        offset: newValue.length),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: "Ürün Fiyatını Giriniz.",
                                  helperText: "Ürün Fiyatı",
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
                                  errorText: tfUrunFiyat.text.isEmpty
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
                    onPressed: () async {
                      if (boolcuk.value) {
                        tfBarkod.text = ".";
                        UrunIslem().urunKayit(
                          tfBarkod.text,
                          tfUrunAd.text,
                          int.parse(tfUrunAdet.text),
                          num.parse(tfUrunFiyat.text),
                        );
                      } else {
                        bool kayitKontrol = await BarcodeController()
                            .varMi(urunListe, tfBarkod.text);
                        if (kayitKontrol) {
                          EkranUyari().snackCikti(true, "Barkod Zaten Kayıtlı");
                        } else {
                          UrunIslem().urunKayit(
                            tfBarkod.text,
                            tfUrunAd.text,
                            int.parse(tfUrunAdet.text),
                            num.parse(tfUrunFiyat.text),
                          );
                        }
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
          }
        },
      ),
    );
  }
}
