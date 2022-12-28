import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class WsErrorDisplay extends StatefulWidget {
  const WsErrorDisplay({super.key});

  @override
  State<WsErrorDisplay> createState() => _ErrorDisplayState();
}

class _ErrorDisplayState extends State<WsErrorDisplay> {
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

  void _showErrorDialog(event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connection error'),
        content: Text(event.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
