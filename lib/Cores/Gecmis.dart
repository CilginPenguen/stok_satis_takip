class Gecmis {
  String gecmis_id;
  String urun_id;
  String gecmis_ad;
  int satis_adet;
  num urun_fiyat;
  num urun_toplam;
  String tarih;
  Gecmis(this.gecmis_id,
      {required this.urun_id,
      required this.gecmis_ad,
      required this.satis_adet,
      required this.urun_fiyat,
      required this.urun_toplam,
      required this.tarih});
  factory Gecmis.fromJson(String key, Map<dynamic, dynamic> json) {
    return Gecmis(key,
        urun_id: json["urun_id"],
        gecmis_ad: json["gecmis_ad"],
        satis_adet: json["satis_adet"],
        urun_fiyat: json["urun_fiyat"],
        urun_toplam: json["urun_toplam"],
        tarih: json["tarih"]);
  }
}
