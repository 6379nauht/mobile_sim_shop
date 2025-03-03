

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/constants/colors.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../blocs/search_day_year/search_day_year_bloc.dart';
import '../../../blocs/search_day_year/search_day_year_event.dart';
import '../../../blocs/search_day_year/search_day_year_state.dart';

class SearchDayYear extends StatelessWidget {
  const SearchDayYear({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDayYearBloc, SearchDayYearState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<int>(
                    value: 0,
                    groupValue: state.searchType,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      context
                          .read<SearchDayYearBloc>()
                          .add(SelectSearchType(value!));
                    },
                  ),
                  Text("Ngày Sinh", style: Theme.of(context).textTheme.bodySmall,),
                  SizedBox(width: AppSizes.spaceBtwSections.h),
                  Radio<int>(
                    value: 1,
                    groupValue: state.searchType,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      context
                          .read<SearchDayYearBloc>()
                          .add(SelectSearchType(value!));
                    },
                  ),
                  Text("Năm Sinh", style: Theme.of(context).textTheme.bodySmall,),
                ],
              ),

              SizedBox(height: AppSizes.spaceBtwItems.h),

              /// Date Picker or Dropdown Year
              state.searchType == 0
                  ? GestureDetector(
                onTap: () async {
                  DateTime? pickedDate =
                  await showDatePicker(
                    context: context,
                    initialDate: state.selectedDate ??
                        DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    if (!context.mounted) return; // Check widget
                    context.read<SearchDayYearBloc>().add(SelectDate(pickedDate));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                            state.selectedDate ??
                                DateTime.now()),
                        style:
                        const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today,
                          color: Colors.blue),
                    ],
                  ),
                ),
              )
                  : DropdownButtonFormField<int>(
                value: state.selectedYear,
                items: List.generate(
                  50,
                      (index) => DropdownMenuItem(
                    value: DateTime.now().year - index,
                    child: Text(
                        "${DateTime.now().year - index}"),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<SearchDayYearBloc>()
                        .add(SelectYear(value));
                  }
                },
              ),

              SizedBox(height: AppSizes.spaceBtwItems.h),

              /// Search button
              Center(
                child: SizedBox(
                  width: 80.w,
                  height: 40.w,
                  child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<SearchDayYearBloc>()
                            .add(PerformSearch());
                      },
                      child: const Text("Tìm Kiếm")),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
