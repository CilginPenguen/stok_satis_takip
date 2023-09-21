import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';

class UrunIslem extends GetxController {
  Future<void> urunKayit(String urun_barkod, String urun_ad, int urun_adet,
      int urun_fiyat, int urun_kurus) async {
    try {
      var refUrun = FirebaseDatabase.instance.ref().child("Urunler");
      if (urun_barkod.isEmpty) {
        EkranUyari().snackCikti(true, "Barkod Boş Olamaz.");
        return;
      }
      if (urun_ad.isEmpty) {
        EkranUyari().snackCikti(true, "Ürün Adı Boş Olamaz.");
        return;
      }
      if (urun_adet <= 0) {
        EkranUyari().snackCikti(true, "Ürün Adeti 0 dan Küçük Olamaz");
        return;
      }
      if (urun_fiyat <= 0) {
        EkranUyari().snackCikti(true, "Ürün Fiyatı 0 dan Küçük Olamaz");
        return;
      }
      if (urun_kurus < 0 || urun_kurus > 99) {
        EkranUyari().snackCikti(true, "Kuruş 0 ile 99 Aralığında Olmalı.");
        return;
      }

      var urun = HashMap<String, dynamic>();
      urun["urun_barkod"] = urun_barkod;
      urun["urun_ad"] = urun_ad;
      urun["urun_adet"] = urun_adet;
      urun["urun_fiyat"] = urun_fiyat;
      urun["urun_kurus"] = urun_kurus;
      urun["sepet_adet"] = 1;
      await refUrun.push().set(urun);
      Get.offAllNamed("/");

      // Başarılı olduğunda yeşil arkaplanlı snackbar göster
      EkranUyari().snackCikti(false, "Ürün Başarıyla Kaydedildi");
    } catch (error) {
      print(error);
    }
  }

  Future<void> UrunSil(
      {required String urun_id, required String referans}) async {
    var ref = FirebaseDatabase.instance.ref().child(referans);
    ref.child(urun_id).remove();
    Get.back();
  }

  Future<void> urunGuncelle({
    required String urun_barkod,
    required String urun_id,
    required String urun_ad,
    required int urun_adet,
    required int urun_fiyat,
    required int urun_kurus,
  }) async {
    try {
      var refUrun = FirebaseDatabase.instance.ref().child("Urunler");
      if (urun_barkod.isEmpty) {
        EkranUyari().snackCikti(true, "Barkod Boş Olamaz.");
        return;
      }
      if (urun_ad.isEmpty) {
        EkranUyari().snackCikti(true, "Ürün Adı Boş Olamaz.");
        return;
      }
      if (urun_adet <= 0) {
        EkranUyari().snackCikti(true, "Ürün Adeti 0 dan Küçük Olamaz");
        return;
      }
      if (urun_fiyat <= 0) {
        EkranUyari().snackCikti(true, "Ürün Fiyatı 0 dan Küçük Olamaz");
        return;
      }
      if (urun_kurus < 0 || urun_kurus > 99) {
        EkranUyari().snackCikti(true, "Kuruş 0 ile 99 Aralığında Olmalı.");
        return;
      }

      var urun = HashMap<String, dynamic>();
      urun["urun_barkod"] = urun_barkod;
      urun["urun_ad"] = urun_ad;
      urun["urun_adet"] = urun_adet;
      urun["urun_fiyat"] = urun_fiyat;
      urun["urun_kurus"] = urun_kurus;
      urun["sepet_adet"] = 1;
      await refUrun.child(urun_id).update(urun);
      VibrationController().tip(titresimTip: "success");

      Get.back(canPop: true);
      EkranUyari().snackCikti(false, "Güncelleme Başarılı");

      // Başarılı olduğunda yeşil arkaplanlı snackbar göster
    } catch (error) {
      print(error);
    }
  }
}
