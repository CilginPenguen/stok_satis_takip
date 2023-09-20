import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/RenkAyar.dart';
import 'package:stok_satis_takip/Controller/NavBarController.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Pages/NavBarPages/UrunSayfa.dart';
import 'package:stok_satis_takip/Pages/NavBarPages/AnaSayfa.dart';
import 'package:stok_satis_takip/Pages/NavBarPages/Ayarlar.dart';

// ignore: must_be_immutable
class BotNavBar extends StatelessWidget {
  BotNavBar({super.key});

  var sayfaListe = [AnaSayfa(), const UrunlerSayfasi(), Ayarlar()];

  var refAyar = FirebaseDatabase.instance.ref().child("Ayarlar");

  final NavBarController kontrol = Get.put(NavBarController());
  final renkKontrol rkontrol = Get.put(renkKontrol());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
        stream: refAyar.onValue,
        builder: (context, event) {
          if (event.hasData) {
            var ayarListe = <RenkAyar>[];
            var gelenAyarlar = event.data!.snapshot.value as dynamic;
            if (gelenAyarlar != null) {
              gelenAyarlar.forEach((key, nesne) {
                var gelenAyar = RenkAyar.fromJson(key, nesne);
                ayarListe.add(gelenAyar);
              });
            }
            int backg = ayarListe[0].renk_kod;
            int barBg = ayarListe[1].renk_kod;
            int yazi = ayarListe[2].renk_kod;
            int buton = ayarListe[3].renk_kod;

            Get.find<renkKontrol>().guncelle(backg, barBg, yazi, buton);

            int backgColor = Get.find<renkKontrol>().backbg.value;
            int barColor = Get.find<renkKontrol>().barBg.value;
            int butonColor = Get.find<renkKontrol>().buton.value;

            return Scaffold(
              body: Obx(() => sayfaListe[kontrol.secilenIndeks.value]),
              bottomNavigationBar: Obx(
                () => BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Ana Sayfa",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.catching_pokemon_rounded),
                      label: "Ürünler",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.palette),
                      label: "Ayarlar",
                    ),
                  ],
                  backgroundColor: Color(barColor),
                  selectedItemColor: Color(butonColor),
                  selectedLabelStyle: const TextStyle(fontSize: 17),
                  selectedIconTheme: const IconThemeData(size: 30.0),
                  unselectedItemColor: Color(backgColor),
                  unselectedLabelStyle: const TextStyle(fontSize: 15),
                  currentIndex: kontrol.secilenIndeks.value,
                  onTap: (i) {
                    kontrol.secilenSayfa(i);
                    VibrationController().tip(titresimTip: "light");
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                  "Lütfen İnternet Bağlantınızı Kontrol Edin ve Yeniden Başlatın"),
            );
          }
        });
  }
}
