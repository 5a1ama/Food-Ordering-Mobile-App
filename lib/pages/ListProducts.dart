import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_order_app/widgets/CustomAppBar.dart';
import 'package:food_order_app/widgets/ProductRatingStars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food_order_app/widgets/BottomNavBar.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  bool isLoadingProducts = true;
  List<Map<String, dynamic>> subCategoryProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSubCategoryProducts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchSubCategoryProducts() async {
    try {
      final Map<String, dynamic> subCategory =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      dynamic response = await http.get(Uri.parse(
          'http://192.168.43.67:8000/product/listSubCategoryProducts/${subCategory['name']}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          subCategoryProducts =
              jsonResponse.map((e) => e as Map<String, dynamic>).toList();
          isLoadingProducts = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> subCategory =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Widget bodyContent = isLoadingProducts
        ? Center(
            child: SpinKitCircle(
              color: Colors.teal,
              size: MediaQuery.of(context).size.width * 0.3,
            ),
          )
        : Padding(
            padding: EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: subCategoryProducts.map((product) {
                      return GestureDetector(
                        onTap: () {
                          print('${product['name']} pressed');
                          Navigator.pushNamed(context, '/productDetails',
                              arguments: product);
                        },
                          child: Container(
                          height: constraints.maxHeight * 0.2,
                          width: constraints.maxWidth,
                          margin: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.35,
                                height: constraints.maxHeight,
                                child: Image(
                                  image: AssetImage(
                                      'assets/${product['name'].toLowerCase()}.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: constraints.maxWidth * 0.05),
                              Container(
                                width: constraints.maxWidth * 0.5,
                                height: constraints.maxHeight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.045,
                                      ),
                                    ),
                                    //SizedBox(height: 10.0),
                                    Text(
                                      '\$${product['price'].toString()}',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.045,
                                      ),
                                    ),
                                    //SizedBox(height: 10.0),
                                    ProductRatingStars(
                                      rating: (product['rating'] as num)
                                          .toDouble(),
                                      size: constraints.maxWidth * 0.07,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                //color: Colors.blue,
                                width: constraints.maxWidth * 0.1,
                                height: constraints.maxHeight,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'All ${subCategory['name']}', leading: true),
      body: bodyContent,
      bottomNavigationBar: BottomNavBar(index: 0),
    );
  }
}
