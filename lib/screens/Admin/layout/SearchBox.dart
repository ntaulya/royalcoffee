import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchBox extends StatelessWidget {    
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  final String hintText;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSearchTap,
    this.hintText = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSearchTap(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: onSearchTap,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
