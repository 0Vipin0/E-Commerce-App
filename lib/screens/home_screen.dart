import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/product_model.dart';
import '../screens/cart_screen.dart';
import '../utils/i18n.dart';
import '../widgets/appbar_widget.dart';
import 'product_detail_screen.dart';

class Home extends StatelessWidget {
  static String route = "/home/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Messages.home_screen_heading.tr),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                Get.find<LanguageController>().switchLanguage();
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.find<ThemeController>().switchTheme();
              },
            ),
            PopupMenuButton<FilterOptions>(
              onSelected: (FilterOptions selectedValue) {
                Get.find<ProductsController>().setFilter(selectedValue);
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => <PopupMenuItem<FilterOptions>>[
                PopupMenuItem<FilterOptions>(
                  value: FilterOptions.Favorites,
                  child: Text(Messages.show_favorites.tr),
                ),
                PopupMenuItem<FilterOptions>(
                  value: FilterOptions.All,
                  child: Text(Messages.show_all.tr),
                ),
              ],
            ),
            GetBuilder<CartController>(
              builder: (CartController controller) => BadgeWidget(
                value: controller.items.length.toString() ?? "0",
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.toNamed(CartScreen.route);
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: AppDrawerWidget(),
        body: Obx(() {
          if (Get.find<ProductsController>().isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GetBuilder<ProductsController>(
              builder: (ProductsController controller) => GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: controller.items.length,
                itemBuilder: (BuildContext context, int i) => ProductItemWidget(
                  product: controller.items[i],
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.isPhone ? 2 : 3,
                  childAspectRatio: context.isPhone ? 3 / 2 : 2 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            );
          }
        }));
  }
}

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).accentColor,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;

  const ProductItemWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: GetBuilder<ProductsController>(
            builder: (ProductsController controller) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                controller.toggleFavoriteStatus(product);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to cart!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Get.toNamed(ProductDetailScreen.route, arguments: product.id);
          },
          child: FadeInImage(
            placeholder:
                const AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
