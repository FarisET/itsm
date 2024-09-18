bool isValidDate(int? day, int? month, int? year) {
  if (day == null || month == null || year == null) {
    return false;
  }

  try {
    final date = DateTime(year, month, day);
    return date.year == year && date.month == month && date.day == day;
  } catch (e) {
    return false;
  }
}
