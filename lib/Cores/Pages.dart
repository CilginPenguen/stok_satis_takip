import 'package:get/get.dart';
import 'package:stok_satis_takip/Pages/SepetEkle.dart';
import 'package:stok_satis_takip/Pages/SepetSayfa.dart';
import 'package:stok_satis_takip/Pages/UrunEkle.dart';
import 'package:stok_satis_takip/Pages/botnavbar.dart';

class Pages {
  static var pages = [
    GetPage(name: "/", page: () => BotNavBar()),
    GetPage(name: "/urunEkle", page: () => UrunEklePage()),
    GetPage(name: "/Sepet", page: () => SepetSayfa()),
    GetPage(name: "/SepetEkle", page: () => const SepetEkleSayfasi()),
  ];
}
