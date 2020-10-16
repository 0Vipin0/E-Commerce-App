import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../products_controller.dart';

class HomeBinding with Bindings {
  @override
  void dependencies() {
    Get.put(ProductsController(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
