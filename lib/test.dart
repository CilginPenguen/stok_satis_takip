/*
Column(
              children: [
                Expanded(
                  child: ListView.builder(
                  itemCount: SepetController().sepetListesi.length,
                  itemBuilder: (context, i) {
                    var sepet = SepetController().sepetListesi[i];
                    for (int a = 0; a < urunListe.length; a++) {
                      if (sepet.sepet_id == urunListe[a].urun_id) {
                        sepet.stok_adet = urunListe[a].urun_adet;
                      }
                    }
                      String fiyatText =
                          "${sepet.urun_fiyat}.${sepet.urun_kurus}";
                      double tamFiyat = double.parse(fiyatText);
                      double urunToplamFiyat = tamFiyat * sepet.sepet_adet;

                      return Card(
                        color: Color(butonColor),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sepet.sepet_ad,
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
                                          'Birim Fiyatı: $tamFiyat\u{20BA}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(yaziColor)),
                                        ),
                                        Text(
                                          "Fiyat : $urunToplamFiyat \u{20BA}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(yaziColor)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      /*sepet.sepet_adet > 1
                                          ? adetAzalt
                                          : null,*/
                                      icon: const Icon(Icons.remove),
                                      color: Color(backgColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Adet: ${sepet.sepet_adet}",
                                      style: TextStyle(color: Color(yaziColor)),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () {
                                        updateSepetAdet("ahmet");
                                      },
                                      /*(sepet.sepet_adet < sepet.stok_adet)
                                              ? adetArttir
                                              : null,*/
                                      icon: const Icon(Icons.add),
                                      color: Color(backgColor),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      /*
                                      sepetSil(sepet.urun_id);
                                      toplamiGuncelle(
                                          sepet.urun_id, urunToplamFiyat);*/
                                    },
                                    icon: Icon(Icons.delete,
                                        color: Color(backgColor)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: -3,
                              blurRadius: 5,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Center(
                              child: Text(
                                "Tutar: ${toplamFiyat.toStringAsFixed(2)}\u{20BA}",
                                style: TextStyle(
                                  color: Color(yaziColor),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            color: Color(barColor),
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.done,
                                color: Color(yaziColor),
                                size: 48,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              label: Text(
                                "Alışverişi Tamamla",
                                style: TextStyle(
                                  color: Color(yaziColor),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ); */