// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stok_satis_takip/Controller/ColorController.dart';
import 'package:stok_satis_takip/Controller/SepetController.dart';
import 'package:stok_satis_takip/Controller/SnackController.dart';
import 'package:stok_satis_takip/Controller/UrunController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';
import 'package:stok_satis_takip/Cores/Gecmis.dart';
import 'package:stok_satis_takip/Cores/Urunler.dart';
import 'package:table_calendar/table_calendar.dart';

var refUrun = FirebaseDatabase.instance.ref().child("Urunler");
var refGecmis = FirebaseDatabase.instance.ref().child("Gecmis");

class GecmisSayfa extends StatelessWidget {
  GecmisSayfa({super.key});
  final CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  Rx<DateTime> anlikTarih = DateTime.now().obs;
  DateFormat tarihFormati = DateFormat('yyyy-MM-dd');

  int backgColor = Get.find<renkKontrol>().backbg.value;
  int barColor = Get.find<renkKontrol>().barBg.value;
  int butonColor = Get.find<renkKontrol>().buton.value;
  int yaziColor = Get.find<renkKontrol>().yazi.value;

  RxDouble totalCiro = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(backgColor),
      appBar: AppBar(
        backgroundColor: Color(barColor),
        title: Text(
          "Ana Sayfa",
          style: TextStyle(color: Color(yaziColor)),
        ),
      ),
      body: Column(children: [
        TableCalendar(
          locale: 'tr_TR',
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2400, 12, 31),
          focusedDay: anlikTarih.value,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(anlikTarih.value, day);
          },
          onDaySelected: (date, focusedDay) {
            //guncellenicek alan
            anlikTarih.value = date;
            Get.forceAppUpdate();
          },
        ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
              stream: refUrun.onValue,
              builder: (context, event) {
                if (event.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (event.hasError) {
                  return Center(child: Text("Hata: ${event.error}"));
                } else if (!event.hasData ||
                    event.data?.snapshot.value == null) {
                  return const Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Ürün Bulunamadı"),
                    ],
                  ));
                } else {
                  var urunListe = <Urunler>[];
                  var gelenUrunler = event.data!.snapshot.value as dynamic;
                  if (gelenUrunler != null) {
                    gelenUrunler.forEach((key, nesne) {
                      var gelen = Urunler.fromJson(key, nesne);
                      urunListe.add(gelen);
                    });
                  }

                  return StreamBuilder<DatabaseEvent>(
                      stream: refGecmis.onValue,
                      builder: (context, ev) {
                        if (ev.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (ev.hasError) {
                          return Center(child: Text("Hata: ${ev.error}"));
                        } else if (!ev.hasData ||
                            ev.data?.snapshot.value == null) {
                          return const Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text("Geçmiş Bulunamadı")]));
                        } else {
                          var gecmisListe = <Gecmis>[];
                          var gelenGecmisler =
                              ev.data!.snapshot.value as dynamic;
                          if (gelenGecmisler != null) {
                            totalCiro.value = 0.0;
                            gelenGecmisler.forEach((key, nesne) {
                              if (nesne["tarih"] ==
                                  tarihFormati.format(anlikTarih.value)) {
                                var gelenGecmis = Gecmis.fromJson(key, nesne);
                                gecmisListe.add(gelenGecmis);
                                totalCiro.value += gelenGecmis.urun_toplam;
                              }
                            });

                            return ListView.builder(
                              itemCount: gecmisListe.length,
                              itemBuilder: (context, i) {
                                var gecmis = gecmisListe[i];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    color: Color(butonColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  gecmis.gecmis_ad,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(yaziColor)),
                                                ),
                                                const SizedBox(height: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Birim Fiyatı: ${gecmis.urun_fiyat}\u{20BA}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(yaziColor)),
                                                    ),
                                                    Text(
                                                      "Fiyat : ${gecmis.urun_toplam} \u{20BA}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(yaziColor)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Adet: ${gecmis.satis_adet}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(yaziColor)),
                                                    ),
                                                    const SizedBox(width: 8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  VibrationController().tip(
                                                      titresimTip: "cancel");
                                                  var urun = urunListe
                                                      .firstWhere(
                                                          (item) =>
                                                              item.urun_id ==
                                                              gecmis.urun_id,
                                                          orElse: () {
                                                    UrunIslem().urunKayit(
                                                        ".",
                                                        gecmis.gecmis_ad,
                                                        gecmis.satis_adet,
                                                        gecmis.urun_fiyat);
                                                    UrunIslem().UrunSil(
                                                        urun_id:
                                                            gecmis.gecmis_id,
                                                        referans: "Gecmis");
                                                    return Urunler(
                                                        "", "", "", 0, 0);
                                                  });

                                                  if (urun.urun_id.isNotEmpty) {
                                                    bool kontrol =
                                                        await EkranUyari()
                                                            .SilEminMisin(
                                                      urun_id: gecmis.gecmis_id,
                                                      mesaj:
                                                          "${gecmis.gecmis_ad} geçmişten silmek istiyor musunuz?",
                                                      referans: "Gecmis",
                                                    );
                                                    if (kontrol) {
                                                      SepetController()
                                                          .urunAdetGuncelle(
                                                        urun_adet: urun
                                                                .urun_adet +
                                                            gecmis.satis_adet,
                                                        urun_id: gecmis.urun_id,
                                                      );
                                                    }
                                                  }
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Color(backgColor)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                        return Center();
                      });
                }
              }),
        )
      ]),
    );
  }
}
