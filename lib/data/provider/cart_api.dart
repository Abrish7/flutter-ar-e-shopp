import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_v3/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartApi {
  // final String getURL = "http://localhost:3000/api/shopping-cart/add-to-cart";

  Future<dynamic> setProductInCart(
      {required customerId, required productId, required quantity}) async {
    try {
      final response = await http.post(Uri.parse(Configurations().getCartURL()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'customerId': customerId,
            'products': [
              {"productId": productId, "quantity": quantity}
            ],
          }));
      final data = (jsonDecode(response.body));
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getCustomerCart({required customerId}) async {
    print("from API: " + customerId);
    try {
      final response = await http.get(
        Uri.parse(Configurations().getCustomerCartURL() + "/" + customerId),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      // print('cart: ' + jsonDecode(response.body)['cart'].toString());
      final data = (jsonDecode(response.body)['cart'][0]['products'] as List);
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      String store = (jsonDecode(response.body)['subTotal'].toString());
      prefs.setString('cartTotal', store);
      // prefs.setString(
      //     'cartTotal', (jsonDecode(response.body).subTotal).toString());
      // print('new products' + data[0].toString());
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> updateCartQuantity(
      {required customerId, required productId, required quantity}) async {
    print("customer: " +
        customerId +
        " product: " +
        productId +
        " quantity: " +
        quantity.toString());
    try {
      final response = await http.post(
          Uri.parse(Configurations().getCartQuantityUpdateURL()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'customerId': customerId,
            'productId': productId,
            'newQuantity': quantity
          }));
      final data = (jsonDecode(response.body)['message']);
      return data;
    } catch (e) {
      print("Error");
      return [];
    }
  }

  Future<dynamic> removeCustomerCartItem(
      {required customerId, required productId}) async {
    try {
      final response = await http.post(
          Uri.parse(Configurations().getCustomerCartRemoveURL()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'customerId': customerId,
            'productId': productId
          }));
      final data = (jsonDecode(response.body));
      return data;
    } catch (e) {
      return [];
    }
  }
}
