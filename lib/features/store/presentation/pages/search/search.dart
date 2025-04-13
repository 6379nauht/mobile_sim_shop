// search.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/products/product_cards/product_card_vertical.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/search/widgets/filter_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // Theo dõi focus của TextField
  String? selectedSort;
  List<String> selectedCategories = [];
  double? minPrice;
  double? maxPrice;
  Timer? _debounce;
  bool _showSuggestions = false; // Trạng thái hiển thị gợi ý

  @override
  void initState() {
    super.initState();
    // Lắng nghe khi TextField nhận focus
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty) {
        setState(() {
          _showSuggestions = true;
        });
      }
    });
    // Lắng nghe thay đổi trong TextField để cập nhật giao diện
    _searchController.addListener(() {
      setState(() {}); // Cập nhật UI khi nội dung thay đổi
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(SearchProductsEvent(
        query: query,
        sort: selectedSort,
        categories: selectedCategories,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ));
      setState(() {
        _showSuggestions = false; // Ẩn gợi ý sau khi tìm kiếm
        _searchFocusNode.unfocus(); // Bỏ focus khỏi TextField
      });
    }
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (value.isNotEmpty) {
        context.read<SearchBloc>().add(FetchSuggestionsEvent(value));
        setState(() {
          _showSuggestions = true; // Hiển thị gợi ý khi có dữ liệu nhập
        });
      } else {
        setState(() {
          _showSuggestions = false; // Ẩn gợi ý nếu TextField rỗng
        });
      }
    });
  }

  void _clearText() {
    setState(() {
      _searchController.clear(); // Xóa nội dung TextField
      _showSuggestions = false;
      _resetFilters();
      context.read<SearchBloc>().add(ClearResultSearch());
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterDialog(
        initialSort: selectedSort,
        initialCategories: selectedCategories,
        initialMinPrice: minPrice,
        initialMaxPrice: maxPrice,
        onApply: (sort, categories, minPrice, maxPrice) {
          setState(() {
            selectedSort = sort;
            selectedCategories = categories;
            this.minPrice = minPrice;
            this.maxPrice = maxPrice;
          });
          _onSearch(_searchController.text);
        },
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedSort = null;
      selectedCategories = [];
      minPrice = null;
      maxPrice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Container(
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
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Nhập từ khóa tìm kiếm...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF42A5F5)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min, // Giới hạn kích thước Row
                children: [
                  if (_searchController.text.isNotEmpty) // Hiển thị "X" khi có nội dung
                    IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF42A5F5)),
                      onPressed: _clearText,
                    ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Color(0xFF42A5F5)),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            style: TextStyle(color: Colors.grey[800]),
            onChanged: _onTextChanged,
            onSubmitted: _onSearch,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetFilters();
              context.read<SearchBloc>().add(ClearResultSearch());
              context.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        elevation: 4,
      ),
      body: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị gợi ý
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                print('SearchState: status=${state.status}, suggestions=${state.suggestions}');
                if (state.status == SearchStatus.success && state.suggestions.isNotEmpty && _showSuggestions) {
                  return Container(
                    margin: EdgeInsets.all(8.w),
                    constraints: BoxConstraints(maxHeight: 300.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        final displayText = suggestion
                            .split(':')[0]
                            .replaceAll('**', '')
                            .replaceAll('"', '')
                            .trim();
                        print('Rendering suggestion[$index]: $displayText');
                        return ListTile(
                          title: Text(
                            displayText,
                            style: TextStyle(color: Colors.black, fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            _searchController.text = displayText;
                            _onSearch(displayText);
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Phần kết quả tìm kiếm
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.defaultSpace.w),
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state.status == SearchStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF42A5F5)),
                        );
                      } else if (state.status == SearchStatus.failure) {
                        return Center(
                          child: Text(
                            'Lỗi: ${state.errorMessage}',
                            style: TextStyle(color: Colors.grey[800], fontSize: 16.sp),
                          ),
                        );
                      } else if (state.status == SearchStatus.success) {
                        final searchResults = state.products;
                        if (searchResults.isEmpty) {
                          return Center(
                            child: Text(
                              'Không tìm thấy sản phẩm nào',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                            ),
                          );
                        }
                        return GridLayout(
                          itemCount: searchResults.length,
                          itemBuilder: (_, index) => ProductCardVertical(
                            product: searchResults[index],
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'Enter a keyword to search',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}