import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';

class UrunIslem extends GetxController {
  Future<void> urunKayit(
      String urun_barkod, String urun_ad, int urun_adet, num urun_fiyat) async {
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

      var urun = HashMap<String, dynamic>();
      urun["urun_barkod"] = urun_barkod;
      urun["urun_ad"] = urun_ad;
      urun["urun_adet"] = urun_adet;
      urun["urun_fiyat"] = urun_fiyat;
      await refUrun.push().set(urun);
      Get.offAllNamed("/");

      // Başarılı olduğunda yeşil arkaplanlı snackbar göster
      EkranUyari().snackCikti(false, "Ürün Başarıyla Kaydedildi");
    } catch (error) {
      print(error);
    }
  }

  Future<void> UrunSil(
      //genel olarak kullanılabilir bir sil işlemi, kod tekrarı olmaması adına geçmiş silme işlemi burda da yapılabilir.
      {required String urun_id,
      required String referans}) async {
    try {
      var ref = FirebaseDatabase.instance.ref().child(referans);
      ref.child(urun_id).remove();
      Get.back(canPop: true);
      EkranUyari().snackCikti(false, "İşlem Başarıyla Gerçekleşti");
    } on Exception catch (e) {
      EkranUyari().snackCikti(true, "Hata: İşlem Gerçekleştirilemedi");
    }
  }

  Future<void> urunGuncelle({
    required String urun_barkod,
    required String urun_id,
    required String urun_ad,
    required int urun_adet,
    required num urun_fiyat,
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

      var urun = HashMap<String, dynamic>();
      urun["urun_barkod"] = urun_barkod;
      urun["urun_ad"] = urun_ad;
      urun["urun_adet"] = urun_adet;
      urun["urun_fiyat"] = urun_fiyat;
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
