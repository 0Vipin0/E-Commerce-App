import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/products_controller.dart';
import '../models/product_model.dart';

class EditProductController extends GetxController {
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode imageUrlFocusNode = FocusNode();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isBusy = false;

  ProductModel editedProduct = ProductModel(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void onInit() {
    imageUrlFocusNode.addListener(_updateImageUrl);
    super.onInit();
  }

  @override
  void onReady() {
    final String productId = Get.arguments as String;
    if (productId != null) {
      editedProduct = Get.find<ProductsController>().findById(productId);
      priceController.text = editedProduct.price.toString();
      titleController.text = editedProduct.title;
      descriptionController.text = editedProduct.description;
      imageUrlController.text = editedProduct.imageUrl;
    }
    update();
    super.onReady();
  }

  @override
  void onClose() {
    imageUrlFocusNode.removeListener(_updateImageUrl);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.dispose();
    super.onClose();
  }

  void _updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') &&
              !imageUrlController.text.endsWith('.jpg') &&
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      update();
    }
  }

  Future<void> saveForm() async {
    final bool isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState.save();
    isBusy = true;
    update();
    if (editedProduct.id != null) {
      await Get.find<ProductsController>()
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Get.find<ProductsController>().addProduct(editedProduct);
      } catch (error) {
        Get.defaultDialog(
          title: "An error occurred!",
          content: const Text("Something went wrong."),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Okay'),
            )
          ],
        );
      }
    }
    isBusy = false;
    update();
    Get.back();
  }
}
