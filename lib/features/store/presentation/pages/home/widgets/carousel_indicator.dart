import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_event.dart';

import '../../../../../../core/utils/constants/colors.dart';
import '../../../blocs/carousel_slider/carousel_slider_state.dart';

class CarouselIndicatorWidget extends StatelessWidget {
  final List<String> banners;

  const CarouselIndicatorWidget({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarouselBloc, CarouselState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < banners.length; i++)
              GestureDetector(
                onTap: () {
                  context.read<CarouselBloc>().add(ChangeSliderEvent(newIndex: i));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  width: state.currentIndex == i ? 10.0 : 8.0,
                  height: state.currentIndex == i ? 10.0 : 8.0,
                  decoration: BoxDecoration(
                    color: state.currentIndex == i
                        ? AppColors.primary
                        : AppColors.grey,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
