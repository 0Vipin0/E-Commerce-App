import 'dart:convert';

import 'package:ecommerce_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/authentication_controller.dart';
import '../models/cart_item_model.dart';
import '../models/order_item_model.dart';

class OrdersController extends GetxController {
  List<OrderItemModel> _orders = <OrderItemModel>[];
  final String authToken = Get.find<AuthenticationController>().token;
  final String userId = Get.find<AuthenticationController>().userId;

  List<OrderItemModel> get orders => <OrderItemModel>[..._orders.toList()];

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    await getOrders();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getOrders() async {
    try {
      final String url =
          '${Constants.projectAPIUrl}/orders/$userId.json?auth=$authToken';
      final http.Response response = await http.get(url);
      final RxList<OrderItemModel> loadedOrders = <OrderItemModel>[].obs;
      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((String orderId, dynamic orderData) {
        loadedOrders.add(
          OrderItemModel(
            id: orderId,
            amount: orderData['amount'] as double,
            dateTime: DateTime.parse(orderData['dateTime'] as String),
            products: (orderData['products'] as List<dynamic>)
                .map((dynamic item) =>
                    CartItemModel.fromMap(item as Map<String, dynamic>))
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList().obs;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    isLoading.value = true;
    update();
    final String url =
        '${Constants.projectAPIUrl}/orders/$userId.json?auth=$authToken';
    final DateTime timestamp = DateTime.now();
    final http.Response response = await http.post(
      url,
      body: json.encode(<String, dynamic>{
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts.map((CartItemModel cp) => cp.toMap()).toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItemModel(
        id: json.decode(response.body)['name'] as String,
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    isLoading.value = false;
  }
}
