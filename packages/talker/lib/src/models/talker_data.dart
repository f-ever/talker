import 'package:talker/talker.dart';

/// Base [Talker] Data transfer object
/// Objects of this type are passed through
/// handlers observer and stream
class TalkerData {
  TalkerData(
    this.message, {
    this.logLevel,
    this.exception,
    this.error,
    this.stackTrace,
    this.title = 'log',
    DateTime? time,
    this.pen,
    this.key,
  }) {
    _time = time ?? DateTime.now();
  }

  late DateTime _time;

  /// {@template talker_data_message}
  /// [String] [message] - message describes what happened
  /// {@endtemplate}
  final String? message;

  final String? key;

  /// {@template talker_data_loglevel}
  /// [LogLevel] [logLevel] - to control logging output
  /// {@endtemplate}
  final LogLevel? logLevel;

  /// {@template talker_data_exception}
  /// [Exception?] [exception] - exception if it happened
  /// {@endtemplate}
  final Object? exception;

  /// {@template talker_data_error}
  /// [Error?] [error] - error if it happened
  /// {@endtemplate}
  final Error? error;

  /// {@template talker_data_title}
  /// Title of Talker log
  /// {@endtemplate}
  String? title;

  /// {@template talker_data_stackTrace}
  /// StackTrace?] [stackTrace] - stackTrace if [exception] or [error] happened
  /// {@endtemplate}
  final StackTrace? stackTrace;

  /// {@template talker_data_time}
  /// Internal time when the log occurred
  /// {@endtemplate}
  DateTime get time => _time;

  /// [AnsiPen?] [pen] - sets your own log color for console
  AnsiPen? pen;

  /// {@template talker_data_generateTextMessage}
  /// Internal method that generates
  /// a complete message about the event
  ///
  /// See examples:
  /// [TalkerLog] -> [TalkerLog.generateTextMessage]
  /// [TalkerException] -> [TalkerException.generateTextMessage]
  /// [TalkerError] -> [TalkerError.generateTextMessage]
  ///
  /// {@endtemplate}
  String generateTextMessage(
      {TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    return '${displayTitleWithTime(timeFormat: timeFormat)}$message$displayStackTrace';
  }
}

/// Extension to get
/// display text of [TalkerData] fields
extension FieldsToDisplay on TalkerData {
  /// Displayed title of [TalkerData]

  String displayTitleWithTime(
      {TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final titleStr = '[$title]';
    final timeStr = '[${displayTime(timeFormat: timeFormat)}]';

    // Apply ANSI styles based on logLevel
    if (logLevel != null) {
      final titlePen = _getTitlePen(logLevel!);
      final timePen = _getTimePen();
      return '${titlePen.write(titleStr)}${timePen.write(timeStr)}';
    }

    return '$titleStr$timeStr';
  }

  /// Get styled pen for title based on LogLevel
  AnsiPen _getTitlePen(LogLevel level) {
    final pen = AnsiPen();

    switch (level) {
      case LogLevel.critical:
        // Bright red background, white text
        pen
          ..xterm(15) // Bright white text
          ..xterm(196, bg: true); // Bright red background
        break;
      case LogLevel.error:
        // Dark red background, white text
        pen
          ..xterm(15) // Bright white text
          ..xterm(88, bg: true); // Dark red background
        break;
      case LogLevel.warning:
        // Orange background, white text
        pen
          ..xterm(15) // Bright white text
          ..xterm(208, bg: true); // Orange background
        break;
      case LogLevel.info:
        // Light green background, black text
        pen
          ..xterm(16) // Black text
          ..xterm(42, bg: true); // Light green background
        break;
      case LogLevel.debug:
        // Cyan background, black text
        pen
          ..xterm(16) // Black text
          ..xterm(51, bg: true); // Cyan background
        break;
      case LogLevel.verbose:
        // Gray background, white text
        pen
          ..xterm(15) // Bright white text
          ..xterm(240, bg: true); // Gray background
        break;
    }

    return pen;
  }

  /// Get styled pen for time - distinctive style for timestamp
  AnsiPen _getTimePen() {
    final pen = AnsiPen();
    // Dark gray background, bright white text
    pen
      ..xterm(15) // Bright white text
      ..xterm(236, bg: true); // Dark gray background
    return pen;
  }

  /// Displayed stackTrace of [TalkerData]
  String get displayStackTrace {
    if (stackTrace == null || stackTrace == StackTrace.empty) {
      return '';
    }
    return '\nStackTrace: $stackTrace}';
  }

  /// Displayed exception of [TalkerData]
  String get displayException {
    if (exception == null) {
      return '';
    }
    return '\n$exception';
  }

  /// Displayed error of [TalkerData]
  String get displayError {
    if (error == null) {
      return '';
    }
    return '\n$error';
  }

  /// Displayed message of [TalkerData]
  String get displayMessage {
    if (message == null) {
      return '';
    }
    return '$message';
  }

  /// Displayed tile of [TalkerData]
  String displayTime({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) =>
      TalkerDateTimeFormatter(time, timeFormat: timeFormat).format;
}
