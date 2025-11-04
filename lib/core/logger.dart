
import 'dart:developer' as dev;
class Logger {
  static void info(String msg) => dev.log('[INFO] $msg');
  static void warn(String msg) => dev.log('[WARN] $msg');
  static void error(String msg, [Object? e]) => dev.log('[ERROR] $msg', error: e);
}
