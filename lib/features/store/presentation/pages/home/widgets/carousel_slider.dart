import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_event.dart';

import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/images/rounded_image.dart';


class CarouselSliderWidget extends StatelessWidget {
  final List<String> banners;

  const CarouselSliderWidget({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          context.read<CarouselBloc>().add(ChangeSliderEvent(newIndex: index));
        },
      ),
      items: banners.map((bannerUrl) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace.w / 2),
          child: RoundedImage(imageUrl: bannerUrl),
        );
      }).toList(),
    );
  }
}
