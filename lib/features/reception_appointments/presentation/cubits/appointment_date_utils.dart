class AppointmentDateUtils {
  static String formatMonth(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

  static String formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
