import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/order/widgets/order_list_item.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: Text('Đơn hàng', style: Theme.of(context).textTheme.headlineSmall,), showBackArrow: true,),
      body: Padding(padding: EdgeInsets.all(AppSizes.defaultSpace.r),
      child: const OrderListItem(),
      ),
    );
  }
}
