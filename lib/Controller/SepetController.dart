// ignore: file_names
import 'package:get/get.dart';
import 'package:stok_satis_takip/Cores/Sepetim.dart';

class SepetController extends GetxController {
  // RxList'i kullanarak dinlenebilir bir liste oluştur
  RxList<Sepetim> sepetListesi = <Sepetim>[].obs;

  // Sepete ürün ekleme metodu
  void sepeteUrunEkle({
    required String sepet_id,
    required String sepet_ad,
    required int stok_adet,
    required int urun_fiyat,
    required int urun_kurus,
    required int sepet_adet,
  }) {
    Sepetim urun = Sepetim(
      sepet_id: sepet_id,
      sepet_ad: sepet_ad,
      stok_adet: stok_adet,
      urun_fiyat: urun_fiyat,
      urun_kurus: urun_kurus,
      sepet_adet: sepet_adet,
    );

    sepetListesi.add(urun);
    update();
    print(sepetListesi.isEmpty);
    for (var a in sepetListesi) {
      print(a.sepet_ad);
      print(a.sepet_adet);
      print(a.sepet_id);
    }
  }
}
