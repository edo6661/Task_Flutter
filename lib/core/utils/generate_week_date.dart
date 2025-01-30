List<DateTime> generateWeekDate(int weekOffSet) {
  final today = DateTime.now();
  // ! 1 = Monday, 7 = Sunday
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffSet * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}
