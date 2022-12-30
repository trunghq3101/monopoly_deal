import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class AppErrorDisplay extends StatefulWidget {
  const AppErrorDisplay({super.key});

  @override
  State<AppErrorDisplay> createState() => AppErrorDisplayState();
}

class AppErrorDisplayState extends State<AppErrorDisplay> {
  late Widget Function(AppError error) _errorDialogBuilder =
      _defaultErrorDialogBuilder;
  List<Widget>? _actions;
  late final StreamSubscription<AppError> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = appErrorGateway.error.listen(_showErrorDialog);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void dismiss() {
    Navigator.of(context).pop();
  }

  void setActions(List<Widget> actions) {
    _actions = actions;
  }

  void unset() {
    _errorDialogBuilder = _defaultErrorDialogBuilder;
    _actions = null;
  }

  Widget _defaultErrorDialogBuilder(AppError error) {
    return AlertDialog(
      title: Text(error.title(context)),
      content: Text(error.content(context)),
      actions: _actions ??
          [
            TextButton(
              onPressed: dismiss,
              child: const Text('Cancel'),
            ),
          ],
    );
  }

  void _showErrorDialog(AppError error) {
    showDialog(
      context: context,
      builder: (context) => _errorDialogBuilder(error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension AppErrorDisplayContent on AppError {
  String title(BuildContext context) {
    switch (type) {
      case AppErrorType.roomNotExist:
      case AppErrorType.socketConnection:
        return 'Connection error';
      case AppErrorType.general:
      default:
        return 'An error occurred';
    }
  }

  String content(BuildContext context) {
    final exceptionMessage = exception?.toString() ?? 'Something went wrong';
    switch (type) {
      case AppErrorType.roomNotExist:
        return 'Room does not exist. Please recheck the room code';
      case AppErrorType.alreadyInRoom:
        return 'You are already in a room. Please quit that room first.';
      case AppErrorType.general:
      case AppErrorType.socketConnection:
      default:
        return exceptionMessage;
    }
  }
}
