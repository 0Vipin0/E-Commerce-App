import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../utils/i18n.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(Messages.welcome_everyone.tr),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: Text(Messages.shop_screen_text.tr),
            onTap: () {
              Get.offNamed(Home.route);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Text(Messages.orders_screen_text.tr),
            onTap: () {
              Get.offNamed(OrdersScreen.route);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(Messages.user_product_screen_text.tr),
            onTap: () {
              Get.offNamed(UserProductsScreen.route);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(Messages.logout.tr),
            onTap: () {
              Get.find<AuthenticationController>()
                  .logout()
                  .then((dynamic value) => Get.offNamed(Login.route))
                  .catchError((dynamic error) {
                Get.snackbar(Messages.unable_logout.tr, error as String);
              });
            },
          ),
        ],
      ),
    );
  }
}
