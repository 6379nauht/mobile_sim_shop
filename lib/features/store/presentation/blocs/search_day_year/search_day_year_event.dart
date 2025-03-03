import 'package:equatable/equatable.dart';

/// Sự kiện (Event)
abstract class SearchDayYearEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectSearchType extends SearchDayYearEvent {
  final int searchType; // 0: Ngày, 1: Năm
  SelectSearchType(this.searchType);
}

class SelectDate extends SearchDayYearEvent {
  final DateTime selectedDate; // Đảm bảo có thuộc tính này

  SelectDate(this.selectedDate); // Constructor nhận giá trị ngày

  @override
  List<Object?> get props => [selectedDate];
}

class SelectYear extends SearchDayYearEvent {
  final int selectedYear;
  SelectYear(this.selectedYear);
}

class PerformSearch extends SearchDayYearEvent {}
