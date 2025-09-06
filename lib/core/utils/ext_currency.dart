extension StringFormatter on String {
  String toCurrency() {
    int step = 1;
    String val = this;
    if (int.tryParse(this) == null) return this;

    for (var i = val.length - 1; i >= 0; i--) {
      if (i - 2 * step > 0) {
        val = val.replaceRange(i - 2 * step, i - 2 * step, ".");
        step++;
      }
    }

    return val;
  }

  int toInt() {
    return int.parse(this);
  }

  String toDateMMMwHourMinutes() {
    try {
      DateTime date = DateTime.parse(this);
      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      String monthName = monthNames[date.month - 1];
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      return "${date.day} $monthName ${date.year} $hour:$minute";
    } catch (e) {
      return this;
    }
  }

  String toDateMMM() {
    try {
      DateTime date = DateTime.parse(this);
      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      String monthName = monthNames[date.month - 1];
      return "${date.day} $monthName ${date.year}";
    } catch (e) {
      return this;
    }
  }
}
