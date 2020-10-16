import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/products_controller.dart';
import '../widgets/appbar_widget.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String route = '/user_products/';

  Future<void> _refreshProducts() async {
    await Get.find<ProductsController>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed(EditProductScreen.route);
            },
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: Obx(
        () => Get.find<ProductsController>().isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(),
                child: GetBuilder<ProductsController>(
                  builder: (ProductsController productsData) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (BuildContext context, int i) => Column(
                        children: <Widget>[
                          UserProductItemWidget(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItemWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.toNamed(EditProductScreen.route, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Get.find<ProductsController>().deleteProduct(id);
                } catch (error) {
                  Get.snackbar("Deleting Failed",
                      "Unable to delete the item, due to + $error");
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
