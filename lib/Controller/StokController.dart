import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class stokLimit extends GetxController {
  GetStorage limitValue = GetStorage();
  var key = "limit";

  void setLimit(int limit) async {
    await limitValue.write(key, limit);
  }

  int getLimit() {
    return limitValue.read(key) ?? 0;
  }
}
