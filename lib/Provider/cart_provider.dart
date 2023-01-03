import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_with_provider/Helper/db_helper.dart';
import 'package:shopping_with_provider/Models/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  double _discountedPrice = 0.0;
  double get discountedPrice => _discountedPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('cart_items', _counter);
    sp.setDouble('totalPrice', _totalPrice);
    sp.setDouble('discountedPrice', _discountedPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _counter = sp.getInt('cart_items') ?? 0;
    _totalPrice = sp.getDouble('totalPrice') ?? 0;
    _discountedPrice = sp.getDouble('discountedPrice') ?? 0;
    notifyListeners();
  }

  void addtotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removetotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double gettotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }

  double getDiscountedPrice() {
    var disPrice = _totalPrice * 5 / 100;
    _discountedPrice = disPrice;
    _totalPrice = _totalPrice - _discountedPrice;
    _getPrefItems();
    return _discountedPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }
}
