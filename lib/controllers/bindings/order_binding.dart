import 'package:get/get.dart';

import '../orders_controller.dart';

class OrdersBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(OrdersController(), permanent: true);
  }
}