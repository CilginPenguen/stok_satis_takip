import 'package:get/get.dart';

class NavBarController extends GetxController {
  var secilenIndeks = 0.obs;
  void secilenSayfa(int i) {
    secilenIndeks.value = i;
    update();
  }
}
