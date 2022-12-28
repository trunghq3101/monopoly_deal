import 'dart:async';

import 'package:logging/logging.dart';

enum AppError {
  socketConnection('Socket connection error'),
  roomNotExist('Room does not exist');

  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

class AppErrorGateway {
  final StreamController<AppError> _errorController = StreamController();
  Stream<AppError> get error => _errorController.stream;
  final _logger = Logger("$AppErrorGateway");

  void addError(AppError appError, [Object? originError, StackTrace? s]) {
    _logger.warning(appError.message, originError, s);
    _errorController.add(appError);
  }
}
