import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryTabs({
    required this.selectedCategory,
    required this.onCategorySelected,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  List<String> categories = [];
  bool isLoading = true;
  String? hoveredCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      categories = [
        "Coffee",
        "Non-Coffee",
        "Snack",
        "Food",
        "Royal Glace",
        "Fresh Juice",
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = widget.selectedCategory == category;
          final isHovered = hoveredCategory == category;

          return MouseRegion(
            onEnter: (_) => setState(() => hoveredCategory = category),
            onExit: (_) => setState(() => hoveredCategory = null),
            child: GestureDetector(
              onTap: () => widget.onCategorySelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.brown
                      : isHovered
                          ? Colors.brown.shade100
                          : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.transparent),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
