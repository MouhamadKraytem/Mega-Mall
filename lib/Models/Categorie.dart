import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final int color; // Color as an int
  late final String iconImage; // Icon as IconData

  // Constructor accepts Color as an int and IconData for the icon
  Category({
    required this.name,
    required this.color,
    required this.iconImage,
  });

  // Return Color from color integer
  Color getColor() {
    return Color(color);
  }

  // Convert Category to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': iconImage,
      'color': color,
    };
  }

  // Create a Category from Firestore document
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      name: data['name'] ?? 'Unknown', // Default value if name is not found
      iconImage: data['icon'], // Default icon if not found
      color: data['color'] ?? 0xffffffff, // Default to white if color is not found
    );
  }

  // Add a category to Firestore
  static Future<void> addCategory(Category category) async {
    await FirebaseFirestore.instance.collection('categories').add(category.toMap());
  }
}
