import 'package:get/get.dart';

import '../authentication_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthenticationController>(AuthenticationController(),
        permanent: true);
  }
}
