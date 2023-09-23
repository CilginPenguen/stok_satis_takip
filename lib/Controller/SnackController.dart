import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/UrunController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';

class EkranUyari extends GetxController {
  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;

  Future<void> snackCikti(bool exists, String gelenMesaj) async {
    if (exists) {
      VibrationController().tip(titresimTip: "cancel");
      Get.showSnackbar(GetSnackBar(
        margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
        borderRadius: 20,
        borderColor: const Color.fromARGB(255, 53, 1, 2),
        icon: const Icon(
          Icons.warning,
          color: Colors.black,
        ),
        messageText: Text(
          gelenMesaj,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ));
    } else {
      VibrationController().tip(titresimTip: "success");
      Get.showSnackbar(GetSnackBar(
        margin: const EdgeInsets.only(bottom: 20),
        borderRadius: 20,
        borderColor: const Color.fromARGB(255, 1, 53, 8),
        icon: const Icon(
          Icons.done,
          color: Colors.black,
        ),
        messageText: Text(
          gelenMesaj,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1, milliseconds: 500),
      ));
    }
  }

  Future<void> SilEminMisin(
      {required String urun_id,
      required String mesaj,
      required String referans}) async {
    Get.dialog(AlertDialog(
      backgroundColor: const Color.fromARGB(255, 55, 47, 47),
      shadowColor: const Color.fromARGB(255, 42, 41, 41),
      title: Text(
        mesaj,
        style: const TextStyle(color: Colors.white),
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
                  UrunIslem().UrunSil(urun_id: urun_id, referans: referans);
                  VibrationController().tip(titresimTip: "success");
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Color.fromARGB(255, 19, 102, 21),
                  size: 32,
                ),
                label: const Text(
                  "Evet",
                  style: TextStyle(color: Colors.white, fontSize: 21),
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
                  VibrationController().tip(titresimTip: "cancel");
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color.fromARGB(255, 152, 34, 26),
                  size: 32,
                ),
                label: const Text(
                  "Hayır",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                )),
          ],
        )
      ],
    ));
  }

  //Ürün Güncelleme
  Future<void> urunGuncelle({
    required String mesaj,
    required bool barkodVarMi,
    required String barkod,
    required String urun_id,
    required String urun_ad,
    required int urun_adet,
    required num urun_fiyat,
  }) async {
    var tfBarkod = TextEditingController();
    var tfUrunAd = TextEditingController();
    var tfUrunAdet = TextEditingController();
    var tfUrunFiyat = TextEditingController();

    tfBarkod.text = barkod;
    tfUrunAd.text = urun_ad;
    tfUrunAdet.text = urun_adet.toString();
    tfUrunFiyat.text = urun_fiyat.toString();

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 55, 47, 47),
        shadowColor: const Color.fromARGB(255, 42, 41, 41),
        title: Text(
          mesaj,
          style: const TextStyle(color: Colors.white),
        ),
        scrollable: true,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Visibility(
            visible: barkodVarMi,
            child: TextField(
              //Barkod Alanı
              controller: tfBarkod,
              style: const TextStyle(color: Colors.white),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Barkod Alanı",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Color(backgColor))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(yaziColor)),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                //Ürün Ad Alanı
                controller: tfUrunAd,
                style: const TextStyle(color: Colors.white),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Ürün Adını Gir",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Color(butonColor))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(yaziColor)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                //Ürün Adeti alanı
                controller: tfUrunAdet,
                style: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      //urun fiyat alanı
                      controller: tfUrunFiyat,
                      style: const TextStyle(color: Colors.white),
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
                        hintText: "Ürün Fiyatını Gir",
                        helperText: "Tam Kısım",
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
                        errorText:
                            tfUrunFiyat.text.isEmpty ? 'Boş Bırakılamaz' : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                //Evet Butonu
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Color.fromARGB(255, 19, 102, 21),
                  ),
                ),
                onPressed: () {
                  UrunIslem().urunGuncelle(
                      urun_barkod: tfBarkod.text,
                      urun_id: urun_id,
                      urun_ad: tfUrunAd.text,
                      urun_adet: int.parse(tfUrunAdet.text),
                      urun_fiyat: num.parse(tfUrunFiyat.text));
                },
                icon: const Icon(
                  Icons.cloud,
                  color: Color.fromARGB(255, 19, 102, 21),
                  size: 32,
                ),
                label: const Text(
                  "Güncelle",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                //Hayır Butonu
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Color.fromARGB(255, 152, 34, 26),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  VibrationController().tip(titresimTip: "cancel");
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color.fromARGB(255, 152, 34, 26),
                  size: 32,
                ),
                label: const Text(
                  "İptal",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
