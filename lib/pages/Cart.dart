import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/cart_provider.dart';
import 'package:food_order_app/widgets/BottomNavBar.dart';
import 'package:food_order_app/widgets/CustomAppBar.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Widget bodyContent = cartProvider.items.isEmpty
        ? Center(child: Text('Your cart is empty'))
        : Padding(
            padding: EdgeInsets.all(8.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cartProvider.items[index];
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.2,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          cartItem.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Quantity: ${cartItem.quantity}'),
                              Text('Price: \$${cartItem.price}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_shopping_cart),
                          onPressed: () => cartProvider.removeItem(cartItem),
                        ),
                      ],
                    ),
                  );
                }
              );
            }),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'My Cart', leading: true),
      body: bodyContent,
      bottomNavigationBar: BottomNavBar(index: 1),
    );
  }
}
