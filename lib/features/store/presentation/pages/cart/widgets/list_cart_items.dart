
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/product_quantity_with_add_remove.dart';

import '../../../../../../core/utils/constants/sizes.dart';
import 'cart_item.dart';

class ListCartItems extends StatelessWidget {
  const ListCartItems({
    super.key, this.showAddRemoveButton = true,
  });
  final bool showAddRemoveButton;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) =>
          SizedBox(height: AppSizes.defaultSpace.h),
      itemCount: 10,
      itemBuilder: (_, index) => Column(children: [
        const CartItem(),
        if(showAddRemoveButton) SizedBox(
          height: AppSizes.spaceBtwItems.h,
        ),
        if(showAddRemoveButton) Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 70.w,
                ),
                const ProductQuantityWithAddRemove(),

                ///Price
              ],
            ),
            Text('13.250.000 VND',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge),
          ],
        )
      ]),
    );
  }
}