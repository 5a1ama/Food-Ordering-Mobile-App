import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/cart_provider.dart';
import 'package:food_order_app/pages/Home.dart';
import 'package:food_order_app/pages/ProductDetails.dart';
import 'package:food_order_app/pages/Profile.dart';
import 'package:food_order_app/pages/ListProducts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cartItems');

  runApp(
    ChangeNotifierProvider(
        create: (_) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order King',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/listProducts': (context) => ListProducts(),
        '/productDetails': (context) => ProductDetails(),
        '/profile': (context) => Profile(),
      },
    );
  }
}
