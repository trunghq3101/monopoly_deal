import 'package:flutter/material.dart';
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
          ElevatedButton(
            onPressed: () {},
            child: const Text('Create room'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Join room'),
          ),
        ],
      ),
    );
  }
}
