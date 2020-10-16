import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/orders_controller.dart';

class CartScreen extends StatelessWidget {
  static const String route = '/cart/';

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${controller.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Obx(
                    () => Get.find<OrdersController>().isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : FlatButton(
                            onPressed: (controller.totalAmount <= 0)
                                ? null
                                : () {
                                    Get.find<OrdersController>()
                                        .addOrder(
                                          controller.items.values.toList(),
                                          controller.totalAmount,
                                        )
                                        .then((dynamic value) =>
                                            controller.clear());
                                  },
                            textColor: Theme.of(context).primaryColor,
                            child: const Text('ORDER NOW'),
                          ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GetBuilder<CartController>(
            builder: (CartController controller) => Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (BuildContext context, int i) => CartItemWidget(
                  controller.items.values.toList()[i].id,
                  controller.items.keys.toList()[i],
                  controller.items.values.toList()[i].price,
                  controller.items.values.toList()[i].quantity,
                  controller.items.values.toList()[i].title,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItemWidget(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) {
        return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (DismissDirection direction) {
        Get.find<CartController>().removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}