import 'package:get/get.dart';
import 'package:stok_satis_takip/Pages/UrunEkle.dart';
import 'package:stok_satis_takip/Pages/botnavbar.dart';

class Pages {
  static var pages = [
    GetPage(name: "/", page: () => BotNavBar()),
    GetPage(name: "/urunEkle", page: () => UrunEklePage()),
  ];
}
