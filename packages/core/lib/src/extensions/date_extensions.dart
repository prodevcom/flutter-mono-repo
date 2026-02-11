import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String get formatted => DateFormat('dd/MM/yyyy').format(this);
  String get formattedWithTime => DateFormat('dd/MM/yyyy HH:mm').format(this);
  String get iso => toIso8601String();
  String get timeOnly => DateFormat('HH:mm').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
