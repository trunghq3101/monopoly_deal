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
          Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/waitingRoom',
                  arguments: WaitingRoomArgs(
                    pendingAction: () => wsGateway
                      ..connect()
                      ..send((sid) => CreateRoomPacket(sid: sid)),
                  ),
                );
              },
              child: const Text('Create room'),
            );
          }),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/joinRoom');
              },
              child: const Text('Join room'),
            );
          }),
        ],
      ),
    );
  }
}
