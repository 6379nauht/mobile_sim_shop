import 'package:equatable/equatable.dart';

class SearchDayYearState extends Equatable {
  final int searchType;
  final DateTime? selectedDate;
  final int selectedYear;

  const SearchDayYearState({
    required this.searchType,
    this.selectedDate,
    required this.selectedYear,
  });

  SearchDayYearState copyWith({
    int? searchType,
    DateTime? selectedDate,
    int? selectedYear,
  }) {
    return SearchDayYearState(
      searchType: searchType ?? this.searchType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [searchType, selectedDate, selectedYear];
}