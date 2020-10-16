import 'package:flutter/material.dart';

import 'cart_item_model.dart';

class OrderItemModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime dateTime;

  OrderItemModel({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  factory OrderItemModel.fromMap(
    String orderId,
    Map<String, dynamic> map,
  ) {
    return OrderItemModel(
      id: orderId,
      amount: map['amount'] as double,
      products: map['products'] as List<CartItemModel>,
      dateTime: map['dateTime'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount.toStringAsFixed(3),
      'products': products,
      'dateTime': dateTime,
    };
  }
}
