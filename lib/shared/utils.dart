String formatDate(
  DateTime? date, {
  String fallback = 'nessuna data',
  int minYear = 2000,
}) {
  if (date == null || date.isBefore(DateTime(minYear))) return fallback;
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
