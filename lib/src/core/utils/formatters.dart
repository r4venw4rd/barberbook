import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:intl/intl.dart';

/// Renders [time] as a 24h `HH:mm` string.
String formatTimeOfDay(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

/// Renders [value] as a whole-dollar price, for example `$28`.
String formatPrice(double value) => '\$${value.toStringAsFixed(0)}';

/// Renders [value] as a two-decimal price, for example `$28.00`.
String formatPrice2(double value) => '\$${value.toStringAsFixed(2)}';

/// Renders [date] relative to today (`Today`, `Tomorrow`, `Yesterday`) or as
/// a short weekday and day-of-month label.
String dayLabel(DateTime date, [BuildContext? context]) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final only = DateTime(date.year, date.month, date.day);
  final diff = only.difference(today).inDays;
  if (context != null) {
    final l10n = context.l10n;
    if (diff == 0) return l10n.today;
    if (diff == 1) return l10n.tomorrow;
    if (diff == -1) return l10n.yesterday;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('EEE, d MMM', locale).format(date);
  }
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  return DateFormat('EEE, d MMM', 'en').format(date);
}

/// Renders [date] as a long weekday and month name, without the year.
String longDate(DateTime date, [BuildContext? context]) {
  final locale = context != null
      ? Localizations.localeOf(context).toString()
      : 'en';
  return DateFormat('EEEE, d MMMM', locale).format(date);
}

/// Renders [date] with day, short month and a four-digit year.
String shortDate(DateTime date, [BuildContext? context]) {
  final locale = context != null
      ? Localizations.localeOf(context).toString()
      : 'en';
  return DateFormat('d MMM yyyy', locale).format(date);
}

/// Short three-letter month name for [date].
String monthLabel(DateTime date, [BuildContext? context]) {
  final locale = context != null
      ? Localizations.localeOf(context).toString()
      : 'en';
  return DateFormat('MMM', locale).format(date);
}

/// Short three-letter weekday name for [date].
String weekdayShort(DateTime date, [BuildContext? context]) {
  final locale = context != null
      ? Localizations.localeOf(context).toString()
      : 'en';
  return DateFormat('EEE', locale).format(date);
}

/// Time-of-day greeting used by the home header.
String greeting(BuildContext context) {
  final l10n = context.l10n;
  final hour = DateTime.now().hour;
  if (hour < 12) return l10n.greetingMorning;
  if (hour < 17) return l10n.greetingAfternoon;
  return l10n.greetingEvening;
}
