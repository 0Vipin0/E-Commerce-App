import 'dart:convert';

import 'package:ecommerce_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/product_model.dart';
import 'authentication_controller.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsController extends GetxController {
  final String authToken = Get.find<AuthenticationController>().token;
  final String userId = Get.find<AuthenticationController>().userId;

  FilterOptions _selectedOption = FilterOptions.All;

  List<ProductModel> _items = <ProductModel>[];

  List<ProductModel> get items => _selectedOption == FilterOptions.All
      ? <ProductModel>[..._items]
      : favoriteItems;

  List<ProductModel> get favoriteItems =>
      _items.where((ProductModel prodItem) => prodItem.isFavorite).toList();

  ProductModel findById(String id) =>
      _items.firstWhere((ProductModel prod) => prod.id == id);

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    await getProducts();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getProducts() async {
    String url = '${Constants.projectAPIUrl}/products.json?auth=$authToken';
    try {
      final http.Response response = await http.get(url);
      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          '${Constants.projectAPIUrl}/userFavorites/$userId.json?auth=$authToken';
      final http.Response favoriteResponse = await http.get(url);
      final dynamic favoriteData = json.decode(favoriteResponse.body);
      final List<ProductModel> loadedProducts = <ProductModel>[];
      extractedData.forEach((String prodId, dynamic prodData) {
        bool isFavorite = false;
        if (favoriteData != null) {
          isFavorite = favoriteData[prodId] as bool;
        }
        loadedProducts.add(ProductModel(
          id: prodId,
          title: prodData['title'] as String,
          description: prodData['description'] as String,
          price: prodData['price'] as double,
          isFavorite: isFavorite ?? false,
          imageUrl: prodData['imageUrl'] as String,
        ));
      });
      _items = loadedProducts;
    } catch (error) {
      print(error);
      rethrow;
    }
    update();
  }

  Future<void> addProduct(ProductModel product) async {
    final String url =
        '${Constants.projectAPIUrl}/products.json?auth=$authToken';
    try {
      final http.Response response = await http.post(
        url,
        body: json.encode(<String, dynamic>{
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final ProductModel newProduct = ProductModel(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'] as String,
      );
      _items.add(newProduct);
      update();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, ProductModel newProduct) async {
    final int prodIndex =
        _items.indexWhere((ProductModel prod) => prod.id == id);
    if (prodIndex >= 0) {
      final String url =
          '${Constants.projectAPIUrl}/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode(<String, dynamic>{
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      update();
    }
  }

  Future<void> deleteProduct(String id) async {
    final String url =
        '${Constants.projectAPIUrl}/products/$id.json?auth=$authToken';
    final int existingProductIndex =
        _items.indexWhere((ProductModel prod) => prod.id == id);
    ProductModel existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    update();
    final http.Response response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      update();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> toggleFavoriteStatus(ProductModel product) async {
    final bool oldStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    update();
    final String url =
        '${Constants.projectAPIUrl}/userFavorites/$userId/${product.id}.json?auth=$authToken';
    try {
      final http.Response response = await http.put(
        url,
        body: json.encode(
          product.isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        product.isFavorite = oldStatus;
      }
    } catch (error) {
      product.isFavorite = oldStatus;
    }
  }

  void setFilter(FilterOptions filterOptions) {
    _selectedOption = filterOptions;
    update();
  }
}
