import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';

import '../../../../../../core/utils/constants/sizes.dart';

class FilterDialog extends StatefulWidget {
  final String? initialSort;
  final List<String> initialCategories;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final Function(String?, List<String>, double?, double?) onApply;

  const FilterDialog({
    super.key,
    this.initialSort,
    this.initialCategories = const [],
    this.initialMinPrice,
    this.initialMaxPrice,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? selectedSort;
  late List<String> selectedCategories;
  late double? minPrice;
  late double? maxPrice;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.initialSort;
    selectedCategories = List.from(widget.initialCategories);
    minPrice = widget.initialMinPrice;
    maxPrice = widget.initialMaxPrice;

    // Khởi tạo TextEditingController với giá trị ban đầu
    _minPriceController = TextEditingController(text: minPrice?.toString());
    _maxPriceController = TextEditingController(text: maxPrice?.toString());
  }

  @override
  void dispose() {
    // Giải phóng controller khi widget bị hủy
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.8,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.all(AppSizes.defaultSpace.w),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwItems.h),

              // Sort by
              Text(
                'Sort by',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    _buildRadioTile('Name', 'name'),
                    _buildRadioTile('Most Popular', 'popular'),
                    _buildRadioTile('Newest', 'newest'),
                    _buildRadioTile('Lowest Price', 'lowest_price'),
                    _buildRadioTile('Highest Price', 'highest_price'),
                    _buildRadioTile('Most Suitable', 'suitable'),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwSections.h),

              // Category
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (_, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.categories.length,
                      itemBuilder: (_, index) => CheckboxListTile(
                        title: Text(
                          state.categories[index].name,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        value: selectedCategories.contains(state.categories[index].id),
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedCategories.add(state.categories[index].id);
                            } else {
                              selectedCategories.remove(state.categories[index].id);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwSections.h),

              // Pricing
              Text(
                'Pricing',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF42A5F5),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceTextField(
                      label: '\$ Lowest',
                      controller: _minPriceController,
                      onSubmitted: (value) {
                        setState(() {
                          minPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: AppSizes.spaceBtwItems.w),
                  Expanded(
                    child: _buildPriceTextField(
                      label: '\$ Highest',
                      controller: _maxPriceController,
                      onSubmitted: (value) {
                        setState(() {
                          maxPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwSections.h),

              // Nút Apply
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Cập nhật giá trị trước khi gọi onApply
                    minPrice = double.tryParse(_minPriceController.text);
                    maxPrice = double.tryParse(_maxPriceController.text);
                    widget.onApply(selectedSort, selectedCategories, minPrice, maxPrice);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 5,
                    backgroundColor: AppColors.primary,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng RadioListTile
  Widget _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title, style: TextStyle(color: Colors.grey[800])),
      value: value,
      groupValue: selectedSort,
      activeColor: AppColors.primary,
      onChanged: (value) => setState(() => selectedSort = value),
    );
  }

  // Hàm xây dựng TextField cho giá
  Widget _buildPriceTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onSubmitted,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      ),
      keyboardType: TextInputType.number,
      controller: controller,
      onSubmitted: onSubmitted, // Gọi khi nhấn Enter
    );
  }
}