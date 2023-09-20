class RenkAyar {
  String renk_id;
  String renk_aciklama;
  int renk_kod;
  RenkAyar(this.renk_id, this.renk_aciklama, this.renk_kod);
  factory RenkAyar.fromJson(String key, Map<dynamic, dynamic> json) {
    return RenkAyar(
        key, json["renk_aciklama"] as String, json["renk_kod"] as int);
  }
}
