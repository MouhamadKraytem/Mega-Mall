import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
    final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 220,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(

        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Apply rounded corners to the image
              child: Image.asset(
                'products/${product['productImg']}',
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported, // Fallback icon if image fails to load
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  );
                },
              ),
            ),
          ),
          Text(product['productName']),
          Text(product['productPrice'].toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(

                children: [
                  Icon(Icons.star, color: Colors.amber,),
                  Text(product['rating'].toString()),
                ],
              ),
              Text("Reviews (${product['reviews'].toString()})",style: Theme.of(context).textTheme.bodySmall,)
            ],
          )
        ],
      ),
    );
  }
}
