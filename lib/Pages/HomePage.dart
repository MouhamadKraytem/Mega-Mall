import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/FireBaseServices.dart';
import '../Widgets/CategorieCard.dart';
import '../Widgets/ProductCard.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  Future<List<Map<String, dynamic>>> getCategories() async {
    final fireBaseServices =
        Provider.of<FireBaseServices>(context, listen: false);
    return await fireBaseServices.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mega Mall",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _signOut();
          },
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Consumer<FireBaseServices>(
          builder: (context, fireBaseServices, child) {
        return HomeBody(fireBaseServices);
      }),
    );
  }

  void _signOut() async {
    final fireBaseServices =
        Provider.of<FireBaseServices>(context, listen: false);
    try {
      await fireBaseServices.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      // Handle any errors that might occur during sign out
      print('Error during sign out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  Widget HomeBody(FireBaseServices fireBaseServices) {
    return Consumer<FireBaseServices>(
      builder: (context, fireBaseServices, child) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fireBaseServices.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle errors
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> categories = snapshot.data!;
              // Use your categories data here
              return Column(
                children: [
                  CategorieSection(categories),
                  FeatureSection(),
                ],
              );
            } else {
              return Text('No categories found.');
            }
          },
        );
      },
    );
  }

  Widget CategorieSection(List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle("Categories"),
        _categoriesNav(categories),
      ],
    );
  }

  Widget _pageTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            "see all",
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }

  Widget _categoriesNav(List<Map<String, dynamic>> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            return CategoryCard(
                category: category); // Use the CategoryCard widget
          }).toList(),
        ),
      ),
    );
  }

  Widget FeatureSection() {
    return Consumer<FireBaseServices>(builder: (context, fireBaseServices, child) {
      return FutureBuilder(
        future: fireBaseServices.getProducts(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Handle errors
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>>  product = snapshot.data!;
            // Use your categories data here
            return Column(
              children: [
                _pageTitle("Featured Product"),
                _productView(product),
              ],
            );
          } else {
            return Text('No categories found.');
          }
        },
      );
    });
  }

  Widget _productView(List<Map<String, dynamic>>  products){
    return Row(
      children: products.map(
          (product) => ProductCard(product: product)
      ).toList(),
    );
  }
}
