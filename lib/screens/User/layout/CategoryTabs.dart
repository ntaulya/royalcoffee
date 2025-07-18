import 'package:flutter/material.dart';

import '../../../controllers/Product/CategoryController.dart';
import '../../../models/Category.dart';
import '../../../services/CategoryCacheService.dart';

class CategoryTabs extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String>? onInitialCategoryReady;

  const CategoryTabs({
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onInitialCategoryReady,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  final CategoryController _controller = CategoryController();
  final CategoryCacheService _cacheService = CategoryCacheService();

  List<Category> categories = [];
  bool isLoading = true;
  String? hoveredCategory;
  String? selectedCategoryName;

  @override
  void initState() {
    super.initState();
    _loadCategoriesWithCache();
  }

  Future<void> _loadCategoriesWithCache() async {
    setState(() => isLoading = true);

    final fetchedCategories = await _controller.loadCategories();

    if (fetchedCategories.isNotEmpty) {
      final cachedId = await _cacheService.getSelectedCategoryId();
      final selectedCategory = fetchedCategories.firstWhere(
        (cat) => cat.id == cachedId,
        orElse: () => fetchedCategories[0],
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInitialCategoryReady?.call(selectedCategory.id.toString());
      });

      setState(() {
        categories = fetchedCategories;
        selectedCategoryName = selectedCategory.name;
        isLoading = false;
      });
    } else {
      setState(() {
        categories = [];
        isLoading = false;
      });
    }
  }

  void _onCategoryTap(Category category) {
    setState(() {
      selectedCategoryName = category.name;
    });

    _cacheService.saveSelectedCategoryId(category.id); 
    widget.onCategorySelected(category.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.only(left:16 ,top: 16, bottom: 0),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryName == category.name;
          final isHovered = hoveredCategory == category.name;

          return MouseRegion(
            onEnter: (_) => setState(() => hoveredCategory = category.name),
            onExit: (_) => setState(() => hoveredCategory = null),
            child: GestureDetector(
              onTap: () => _onCategoryTap(category),
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
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
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
