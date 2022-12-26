import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return M3Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              InheritedStartPage.wsConnectionManagerOf(context)
                  .connection()
                  .createRoom();
              Navigator.of(context).pushNamed('/waitingRoom');
            },
            child: const Text('Create room'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/joinRoom');
            },
            child: const Text('Join room'),
          ),
        ],
      ),
    );
  }
}
