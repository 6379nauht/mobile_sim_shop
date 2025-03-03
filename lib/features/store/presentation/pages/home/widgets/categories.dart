import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            title: 'Sim Theo Mạng',
            showActionButton: false,
            textColor: AppColors.white,
          ),
          SizedBox(
            height: AppSizes.spaceBtwItems.h,
          ),

          ///Categories
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return VerticalImageText(image: AppImages.iconViettel, onTap: (){},);
              },
            ),
          ),
        ],
      ),
    );
  }
}

