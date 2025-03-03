import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search_day_year/search_day_year_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search_day_year/search_day_year_state.dart';

/// Bloc
class SearchDayYearBloc extends Bloc<SearchDayYearEvent, SearchDayYearState> {
  SearchDayYearBloc()
      : super(SearchDayYearState(
    searchType: 0, // Mặc định là chọn ngày
    selectedDate: DateTime.now(), // Ngày hiện tại
    selectedYear: DateTime.now().year, // Năm hiện tại
  )) {
    on<SelectSearchType>((event, emit) {
      emit(state.copyWith(searchType: event.searchType));
    });

    on<SelectDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.selectedDate));
    });

    on<SelectYear>((event, emit) {
      emit(state.copyWith(selectedYear: event.selectedYear));
    });

  }
}