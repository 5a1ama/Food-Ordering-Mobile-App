import 'package:flutter/material.dart';
import 'package:food_order_app/widgets/CustomAppBar.dart';
import 'package:food_order_app/widgets/ProductRatingStars.dart';
import 'package:food_order_app/widgets/RateStars.dart';
import 'package:food_order_app/widgets/BottomNavBar.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  double totalPrice = 0.0;
  bool isFullDescription = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final product =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      setState(() {
        totalPrice = product['price'];
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rate This Product!',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 10),
              RateStars(),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      'Rate',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> product =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Widget bodyContent = Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final textSpan = TextSpan(
          text: product['description'],
          style: TextStyle(
            fontSize: constraints.maxWidth * 0.045,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 3,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        bool isOverflowing = textPainter.didExceedMaxLines;
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.5,
                child: Column(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.4,
                      width: constraints.maxWidth,
                      child: Image(
                        image: AssetImage(
                            'assets/${product['name'].toLowerCase()}.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showRatingDialog,
                      child: Container(
                        height: constraints.maxHeight * 0.1,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProductRatingStars(
                              rating: (product['rating'] as num).toDouble(),
                              size: constraints.maxWidth * 0.12,
                            ),
                            Text(
                              'rate this product',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.03,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Container(
                    height: isFullDescription? null : constraints.maxHeight * 0.17,
                    child: Column(
                      children: [
                        Text(
                          product['description'],
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.045,
                          ),
                          maxLines: isFullDescription ? null : 3,
                          overflow: isFullDescription
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        if (isOverflowing)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFullDescription = !isFullDescription;
                              });
                            },
                            child: Text(
                              isFullDescription ? "See less" : "See more",
                              style: TextStyle(fontSize: constraints.maxWidth * 0.04, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: constraints.maxHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.08,
                          ),
                        ),
                        Row(
                          children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: quantity > 1
                                ? () {
                                    setState(() {
                                      quantity--;
                                      totalPrice = product['price'] * quantity;
                                    });
                                  }
                                : null,
                            color: Colors.teal,
                            iconSize: constraints.maxWidth * 0.1,
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.07,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {
                              setState(() {
                                quantity++;
                                totalPrice = product['price'] * quantity;
                              });
                            },
                            color: Colors.teal,
                            iconSize: constraints.maxWidth * 0.1,
                          ),
                        ]),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: constraints.maxWidth * 0.06,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(constraints.maxWidth, constraints.maxWidth * 0.16),
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 15),
            ],
          ),
        );
      }),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '${product['name']}', leading: true),
      body: bodyContent,
      bottomNavigationBar: BottomNavBar(index: 0),
    );
  }
}
