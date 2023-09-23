import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Pages/botnavbar.dart';

class BarcodeController extends GetxController {
  Future<String> barkodTara({required List urunListe}) async {
    String tarananBarkod = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    if (tarananBarkod != '-1') {
      bool durum = await barkodKontrol(urunListe, tarananBarkod);
      if (durum) {
        EkranUyari().snackCikti(true, "Bu Barkod Zaten Kayıtlı.");
        return "";
      } else {
        EkranUyari()
            .snackCikti(false, "Bu Barkodda Ürün Yok Devam Edebilirsiniz.");
        return tarananBarkod;
      }
    }
    Get.offAll(BotNavBar());
    return "";
  }

  Future<bool> barkodKontrol(List urunListe, String barkod) async {
    bool kontrol = false;
    for (var urun in urunListe) {
      if (urun.urun_barkod == barkod) {
        kontrol = true;
        return kontrol;
      }
    }
    return kontrol;
  }
}
