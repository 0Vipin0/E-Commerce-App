import 'package:ecommerce_app/utils/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'controllers/authentication_controller.dart';
import 'controllers/bindings/cart_binding.dart';
import 'controllers/bindings/edit_product_binding.dart';
import 'controllers/bindings/home_binding.dart';
import 'controllers/bindings/initial_bindings.dart';
import 'controllers/bindings/order_binding.dart';
import 'controllers/language_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.setWindowTitle('E-Commerce App');
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<LanguageController>(LanguageController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "E-Commerce App",
      enableLog: true,
      translations: Messages(),
      locale: Get.find<LanguageController>().currentLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: GetBuilder<AuthenticationController>(
        builder: (AuthenticationController auth) => auth.isAuth
            ? Home()
            : FutureBuilder<void>(
                future: auth.tryAutoLogin(),
                builder: (BuildContext context,
                        AsyncSnapshot<void> authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : Login(),
              ),
      ),
      theme: Get.find<ThemeController>().currentTheme,
      getPages: <GetPage>[
        GetPage(
          name: Login.route,
          page: () => Login(),
        ),
        GetPage(
          name: CartScreen.route,
          page: () => CartScreen(),
          binding: CartBinding(),
        ),
        GetPage(
          name: UserProductsScreen.route,
          page: () => UserProductsScreen(),
        ),
        GetPage(
          name: OrdersScreen.route,
          page: () => OrdersScreen(),
          binding: OrdersBinding(),
        ),
        GetPage(
          name: ProductDetailScreen.route,
          page: () => ProductDetailScreen(),
        ),
        GetPage(
          name: EditProductScreen.route,
          page: () => EditProductScreen(),
          binding: EditProductBinding(),
        ),
        GetPage(
          name: Home.route,
          page: () => Home(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
