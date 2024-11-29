import 'package:flutter/material.dart';
import 'package:food_order_app/widgets/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_order_app/widgets/BottomNavBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  bool isLoadingCategories = true;
  bool isLoadingSubCategories = true;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subCategories = [];
  int currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchCategories() async {
    try {
      dynamic response = await http
          .get(Uri.parse('http://192.168.43.67:8000/category/listCategories'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          categories =
              jsonResponse.map((e) => e as Map<String, dynamic>).toList();
          isLoadingCategories = false;
          // After categories are set, fetch sub-categories for the first category
          if (categories.isNotEmpty) {
            fetchSubCategories();
          }
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<void> fetchSubCategories() async {
    try {
      dynamic response = await http.get(Uri.parse(
          'http://192.168.43.67:8000/sub-category/listCategorySubCategories/${categories[currentCategoryIndex]['name']}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          subCategories =
              jsonResponse.map((e) => e as Map<String, dynamic>).toList();
          isLoadingSubCategories = false;
        });
      } else {
        throw Exception('Failed to load sub-categories');
      }
    } catch (e) {
      print('Error fetching sub-categories: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Home', leading: false),
      body: isLoadingCategories
          ? Center(
              child: SpinKitCircle(
                color: Colors.teal,
                size: MediaQuery.of(context).size.width * 0.3,
              ),
            )
          : Padding(
            padding: EdgeInsets.all(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.15,
                        width: constraints.maxWidth,
                        child: Align(
                          alignment: Alignment.center,
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.search, color: Colors.black),
                                  onPressed: () {}),
                              hintText: 'Search for food',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors
                                      .black, // Purple border color when enabled
                                  width: 1.5, // Adjust the width if needed
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.red,
                        height: constraints.maxHeight * 0.2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: categories
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              Map category = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  print('${category['name']} pressed');
                                  setState(() {
                                    currentCategoryIndex = index;
                                    fetchSubCategories();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: index < categories.length - 1
                                          ? constraints.maxWidth * 0.08
                                          : 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/${category['name']
                                                .toLowerCase()}.jpg'),
                                        radius: currentCategoryIndex == index
                                            ? constraints.maxWidth * 0.11
                                            : constraints.maxWidth * 0.08,
                                        backgroundColor: Colors.white,
                                      ),
                                      Text(
                                        category[
                                        'name'],
                                        style: TextStyle(
                                          color: currentCategoryIndex == index
                                              ? Colors.teal
                                              : Colors.black,
                                          fontWeight:
                                          currentCategoryIndex == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: currentCategoryIndex == index
                                              ? constraints.maxWidth * 0.055
                                              : constraints.maxWidth * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.teal,
                        thickness: constraints.maxHeight * 0.01,
                        height: constraints.maxHeight * 0.08,
                      ),
                      Wrap(
                        spacing: constraints.maxWidth * 0.15, // Space between items in a row
                        runSpacing: constraints.maxHeight * 0.05, // Space between rows
                        children: subCategories.map((subCategory) {
                          return GestureDetector(
                            onTap: () {
                              print('${subCategory['name']} pressed');
                              Navigator.pushNamed(
                                  context, '/listProducts',
                                  arguments: subCategory);
                            },
                            child: Container(
                              width: constraints.maxWidth * 0.42,
                              height: constraints.maxHeight * 0.28,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight * 0.22,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/${subCategory['name']
                                                .toLowerCase()}.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  //SizedBox(height: 10.0),
                                  Text(
                                    subCategory[
                                    'name'], // Display the category name
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Center-align the text
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
      bottomNavigationBar: BottomNavBar(index: 0),
    );
  }
}
