import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';

import '../../../../../../core/router/routes.dart';
import '../../../../../../core/utils/constants/colors.dart';
import '../../../../../../core/utils/constants/image_strings.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/image_text/vertical_image_text.dart';
import '../../../../../../core/widgets/text/section_heading.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.defaultSpace.w),
      child: Column(
        children: [
          ///Heading
          const SectionHeading(
            title: 'Danh mục',
            showActionButton: false,
            textColor: AppColors.white,
          ),
          SizedBox(
            height: AppSizes.spaceBtwItems.h,
          ),

          ///Categories
         BlocBuilder<CategoryBloc, CategoryState>(builder: (_, state) {
           if(state.status == CategoryStatus.loading) {
             return SizedBox(
               height: 80.h,
               child: const Center(child: CupertinoActivityIndicator(),),
             );
           } else if (state.status == CategoryStatus.success) {
             final categories = state.categories;
             if(categories.isEmpty) {
               return SizedBox(
                 height: 80.h,
                 child: const Center(
                   child: Text(
                     'Không có danh mục nổi bật',
                     style: TextStyle(color: AppColors.white),
                   ),
                 ),
               );
             }
             return SizedBox(
               height: 90.h,
               child: ListView.builder(
                 itemCount: categories.length,
                 shrinkWrap: true,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (_, index) {
                   final category = categories[index];
                   return VerticalImageText(
                     image: category.image,
                     title: category.name,
                     onTap: () => context.pushNamed(Routes.subCategoriesName),
                   );
                 },
               ),
             );
           } else if (state.status == CategoryStatus.failure) {
             return SizedBox(
               height: 80.h,
               child: Center(
                 child: Text(
                   state.errorMessage ?? 'Lỗi không xác định',
                   style: const TextStyle(color: AppColors.white),
                 ),
               ),
             );
           }
           return const SizedBox.shrink();
         },
         ),
        ],
      ),
    );
  }
}

