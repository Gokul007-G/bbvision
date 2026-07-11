class PayrollModel {
  final int id;
  final int month;
  final int year;
  final int flag;
  final String monthRange;

  PayrollModel({
    required this.id,
    required this.month,
    required this.year,
    required this.flag,
    required this.monthRange,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    int month = json['month'] ?? 0;
    int year = json['year'] ?? 0;

    return PayrollModel(
      id: json['id'] ?? 0,
      month: month,
      year: year,
      flag: json['flag'] ?? 0,
      monthRange: _generateMonthRange(month, year),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'month': month, 'year': year, 'flag': flag};
  }

  /// Generate Month Range
  static String _generateMonthRange(int month, int year) {
    if (month < 1 || month > 12) {
      return "$month-$year";
    }

    final lastDate = DateTime(year, month + 1, 0); // last day of month

    final monthName = _monthName(month);

    return "1st $monthName $year – ${_ordinal(lastDate.day)} $monthName $year";
  }

  static String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  static String _ordinal(int day) {
    if (day >= 11 && day <= 13) return "${day}th";

    switch (day % 10) {
      case 1:
        return "${day}st";
      case 2:
        return "${day}nd";
      case 3:
        return "${day}rd";
      default:
        return "${day}th";
    }
  }
}
