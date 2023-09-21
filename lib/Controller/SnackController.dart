import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_takip/Controller/UrunController.dart';
import 'package:stok_satis_takip/Controller/VibrationController.dart';

class EkranUyari extends GetxController {
  Future<void> snackCikti(bool exists, String gelenMesaj) async {
    if (exists) {
      VibrationController().tip(titresimTip: "cancel");
      Get.showSnackbar(GetSnackBar(
        margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
        borderRadius: 20,
        borderColor: const Color.fromARGB(255, 53, 1, 2),
        icon: const Icon(
          Icons.warning,
          color: Colors.black,
        ),
        messageText: Text(
          gelenMesaj,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ));
    } else {
      VibrationController().tip(titresimTip: "success");
      Get.showSnackbar(GetSnackBar(
        margin: const EdgeInsets.only(bottom: 20),
        borderRadius: 20,
        borderColor: const Color.fromARGB(255, 1, 53, 8),
        icon: const Icon(
          Icons.done,
          color: Colors.black,
        ),
        messageText: Text(
          gelenMesaj,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ));
    }
  }

  Future<void> eminMisin(
      {required String urun_id,
      required String mesaj,
      required String referans}) async {
    Get.dialog(AlertDialog(
      backgroundColor: const Color.fromARGB(255, 55, 47, 47),
      shadowColor: const Color.fromARGB(255, 42, 41, 41),
      title: Text(
        mesaj,
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Color.fromARGB(255, 19, 102, 21),
                  ),
                ),
                onPressed: () {
                  UrunIslem().UrunSil(urun_id: urun_id, referans: referans);
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Color.fromARGB(255, 19, 102, 21),
                  size: 32,
                ),
                label: const Text(
                  "Evet",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                )),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Color.fromARGB(255, 152, 34, 26),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color.fromARGB(255, 152, 34, 26),
                  size: 32,
                ),
                label: const Text(
                  "Hayır",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                )),
          ],
        )
      ],
    ));
  }
}
