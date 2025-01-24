import 'package:logger/logger.dart';

class LogService {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 4, // Tampilkan 2 level fungsi pemanggil
      errorMethodCount: 5, // Tampilkan stack trace hingga 5 level saat error
      lineLength: 120, // Panjang maksimal log
      colors: true, // Gunakan warna untuk konsol
      printEmojis: true, // Tampilkan emoji
      dateTimeFormat: DateTimeFormat.onlyTime,
    ),
  );

  static void d(String message) => logger.d(message);
  static void i(String message) => logger.i(message);
  static void w(String message) => logger.w(message);
  static void e(String message) => logger.e(message);
}
