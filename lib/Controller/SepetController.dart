// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Cores/Sepetim.dart';

class SepetController extends GetxController {
  RxList<Sepetim> sepetListesi = <Sepetim>[].obs;

  final toplamFiyat = 0.0.obs;

  void sepeteUrunEkle({
    required String sepet_id,
    required String sepet_ad,
    required int stok_adet,
    required int urun_fiyat,
    required int urun_kurus,
    required int sepet_adet,
  }) {
    // Belirtilen sepet_id'ye sahip bir ürün var mı kontrol et
    bool urunVarMi = sepetListesi.any((item) => item.sepet_id == sepet_id);

    if (!urunVarMi) {
      Sepetim urun = Sepetim(
        sepet_id: sepet_id,
        sepet_ad: sepet_ad,
        stok_adet: stok_adet,
        urun_fiyat: urun_fiyat,
        urun_kurus: urun_kurus,
        sepet_adet: sepet_adet,
      );
      EkranUyari().snackCikti(false, "Ürün Başarıyla Sepete Eklendi");
      sepetListesi.add(urun);
      update();
    } else {
      EkranUyari().snackCikti(true, "Ürün Zaten Sepette");
    }
  }

  void arttirSepetAdet(String sepetId, double birimFiyat) {
    final sepet = sepetListesi.firstWhere((item) => item.sepet_id == sepetId);

    if (sepet != null && sepet.sepet_adet < sepet.stok_adet) {
      sepet.sepet_adet++;
      toplamFiyat.value += birimFiyat;
      update();
    }
  }

  void azaltSepetAdet(String sepet_id, double birimFiyat) {
    final sepet = sepetListesi.firstWhere((item) => item.sepet_id == sepet_id);

    if (sepet != null && sepet.sepet_adet > 1) {
      sepet.sepet_adet--;
      toplamFiyat.value -= birimFiyat;
      update();
    }
  }

  void toplamGuncelle(double fiyat, int fark) {
    toplamFiyat.value -= (fiyat * fark);

    // Güncelleme işleminden sonra bir sonraki frame'de ekrana yansımasını sağlaymış. Yeni öğrendiğim bir özellik.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void urunSil(String sepet_id, double fiyat, int fark) {
    sepetListesi.removeWhere((urun) => urun.sepet_id == sepet_id);
    update();
    toplamGuncelle(fiyat, fark);
  }
}
