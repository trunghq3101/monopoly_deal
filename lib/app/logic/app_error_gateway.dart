import 'dart:async';

import 'package:logging/logging.dart';

enum AppErrorType {
  general,
  socketConnection,
  roomNotExist;
}

class AppError {
  final AppErrorType type;
  final Object? exception;
  final StackTrace? stackTrace;

  AppError(this.type, [this.exception, this.stackTrace]);
}

class AppErrorGateway {
  final StreamController<AppError> _errorController = StreamController();
  Stream<AppError> get error => _errorController.stream;
  final _logger = Logger("$AppErrorGateway");

  void addError(AppError appError) {
    _logger.warning(appError.type, appError.exception, appError.stackTrace);
    _errorController.add(appError);
  }
}
