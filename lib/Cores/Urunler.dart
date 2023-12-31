class Urunler {
  String urun_id;
  String urun_barkod;
  String urun_ad;
  int urun_adet;
  num urun_fiyat;

  Urunler(
    this.urun_id,
    this.urun_barkod,
    this.urun_ad,
    this.urun_adet,
    this.urun_fiyat,
  );

  factory Urunler.fromJson(String key, Map<dynamic, dynamic> json) {
    return Urunler(
      key,
      json["urun_barkod"] as String,
      json["urun_ad"] as String,
      json["urun_adet"] as int,
      json["urun_fiyat"] as num,
    );
  }
}
