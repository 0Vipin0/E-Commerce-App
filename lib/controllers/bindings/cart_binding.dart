import 'package:get/get.dart';

import '../cart_controller.dart';
import '../orders_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
  }
}
