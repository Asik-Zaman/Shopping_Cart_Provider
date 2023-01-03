import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_with_provider/Helper/db_helper.dart';
import 'package:shopping_with_provider/Models/cart_model.dart';
import 'package:shopping_with_provider/Provider/cart_provider.dart';
import 'dart:core';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? db = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
        },
      ),
      appBar: AppBar(
        actions: [
          Badge(
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              badgeColor: Colors.red,
              position: BadgePosition.topEnd(top: 0, end: -8),
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  );
                },
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 25,
              )),
          SizedBox(
            width: 20,
          )
        ],
        title: Text('Cart List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/empty_cart.png'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Your cart is empty 😌',
                                style: Theme.of(context).textTheme.headline5),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                'Explore products and shop your\nfavourite items',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2)
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data![index].image
                                                      .toString()))),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data![index].unitTag
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  '\$' +
                                                      snapshot.data![index]
                                                          .initialPrice
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                                onPressed: () {
                                                  db!.deleteItem(snapshot
                                                      .data![index].id!);
                                                  cart.removeCounter();
                                                  cart.removetotalPrice(
                                                      double.parse(snapshot
                                                          .data![index]
                                                          .productPrice
                                                          .toString()));
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.green,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity--;
                                                        int? newPrice =
                                                            price * quantity;
                                                        if (quantity > 0) {
                                                          db!
                                                              .updateQuantity(Cart(
                                                                  id: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!,
                                                                  productId: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!
                                                                      .toString(),
                                                                  productName: snapshot
                                                                      .data![
                                                                          index]
                                                                      .productName!,
                                                                  initialPrice: snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!,
                                                                  productPrice:
                                                                      newPrice,
                                                                  quantity:
                                                                      quantity,
                                                                  unitTag: snapshot
                                                                      .data![
                                                                          index]
                                                                      .unitTag
                                                                      .toString(),
                                                                  image: snapshot
                                                                      .data![
                                                                          index]
                                                                      .image
                                                                      .toString()))
                                                              .then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.removetotalPrice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!
                                                                    .toString()));
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            print(error
                                                                .toString());
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      )),
                                                  Consumer<CartProvider>(
                                                    builder: (context, value,
                                                        child) {
                                                      return Text(
                                                        snapshot.data![index]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity++;
                                                        int? newPrice =
                                                            price * quantity;

                                                        db!
                                                            .updateQuantity(Cart(
                                                                id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!,
                                                                productId: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!
                                                                    .toString(),
                                                                productName: snapshot
                                                                    .data![
                                                                        index]
                                                                    .productName!,
                                                                initialPrice: snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!,
                                                                productPrice:
                                                                    newPrice,
                                                                quantity:
                                                                    quantity,
                                                                unitTag: snapshot
                                                                    .data![
                                                                        index]
                                                                    .unitTag
                                                                    .toString(),
                                                                image: snapshot
                                                                    .data![
                                                                        index]
                                                                    .image
                                                                    .toString()))
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.addtotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .initialPrice!
                                                                  .toString()));
                                                        }).onError((error,
                                                                stackTrace) {
                                                          print(
                                                              error.toString());
                                                        });
                                                      },
                                                      icon: Icon(Icons.add,
                                                          color: Colors.white)),
                                                ],
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.gettotalPrice().toStringAsFixed(2) == '0.00'
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReusableWidget(
                        title: 'Sub Total',
                        value: '\$' + value.gettotalPrice().toStringAsFixed(2)),
                    ReusableWidget(
                     title: 'Discount 5%',
                        value: '\$' + value.getDiscountedPrice().toStringAsFixed(2)
                    ),
                    ReusableWidget(
                      title: 'Total',
                      value: '\$' + value.gettotalPrice().toStringAsFixed(2),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}
