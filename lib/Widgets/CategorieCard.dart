import 'dart:ui_web';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/Categorie.dart';

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;

  CategoryCard({required this.category});


  @override
  Widget build(BuildContext context) {
    Category cate = Category(name: category['name'], color: category['color'] as int, iconImage: category['icon']);


    return Container(
      width: 76,
      height: 82,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: cate.getColor(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cate.getColor(), // Background color
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Apply rounded corners to the image
              child: Image.asset(
                'category/${cate.iconImage}',
                width: 48,
                height: 48,
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
          Expanded(
            child: Text(
              cate.name ?? 'Category',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }


}
