final List<String> kMonthNames = [
  "января",
  "февраля",
  "марта",
  "апреля",
  "мая",
  "июня",
  "июля",
  "августа",
  "сентября",
  "октября",
  "ноября",
  "декабря",
];

extension DateTimeExtentions on DateTime {
  String get date {
    final DateTime now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      final s = diff.inSeconds;
      if (s <= 1) return "только что";
      return "$s секунд назад";
    }

    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      if (m == 1) return "минуту назад";
      return "$m минут назад";
    }

    if (diff.inHours < 24) {
      final h = diff.inHours;
      if (h == 1) return "час назад";

      if (h <= 4) return "$h часа назад";

      return "$h часов назад";
    }

    if (diff.inDays <= 7) {
      final d = diff.inDays;
      if (d == 1) return "день назад";

      if (d <= 4) return "$d дня назад";

      return "$d дней назад";
    }

    final years = diff.inDays ~/ 365;
    final months = (diff.inDays % 365) ~/ 30;

    if (years >= 1) {
      return "${this.day} ${kMonthNames[this.month - 1]}, ${this.year}";
    }

    if (diff.inDays > 7) {
      return "${this.day} ${kMonthNames[this.month - 1]}";
    }

    return this.toString();
  }
}
