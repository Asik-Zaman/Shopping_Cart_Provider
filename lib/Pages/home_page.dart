import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_with_provider/Helper/db_helper.dart';
import 'package:shopping_with_provider/Models/cart_model.dart';
import 'package:shopping_with_provider/Pages/cart_screen.dart';
import 'package:shopping_with_provider/Provider/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper = DBHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
        },
      ),
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  (MaterialPageRoute(builder: (context) => CartScreen())));
            },
            child: Badge(
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
          ),
          SizedBox(
            width: 20,
          )
        ],
        title: Text('Product'),
        centerTitle: true,
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counter++;
          setState(() {});
        },
      ), */
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: productImage.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(productImage[index]))),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index],
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
                                        productUnit[index],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        '\$' + productPrice[index].toString(),
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                dbHelper!
                                    .insert(Cart(
                                        id: index,
                                        productId: index.toString(),
                                        productName:
                                            productName[index].toString(),
                                        initialPrice: productPrice[index],
                                        productPrice: productPrice[index],
                                        quantity: 1,
                                        unitTag: productUnit[index].toString(),
                                        image: productImage[index].toString()))
                                    .then((value) {
                                  cart.addtotalPrice(double.parse(
                                      productPrice[index].toString()));
                                  cart.addCounter();

                                  final snackbar = SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Product is added to cart'),
                                    duration: Duration(seconds: 2),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                }).onError((error, stackTrace) {
                                  final snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Product is already added in cart'),
                                      duration: Duration(seconds: 1));

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
