import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  static const roomIdLength = 6;
  String _enteredRoomId = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scaffold(
              backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.05),
              appBar: AppBar(
                backgroundColor:
                    theme.colorScheme.surfaceTint.withOpacity(0.08),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Insets.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Insets.medium),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.medium,
                          horizontal: Insets.extraLarge,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() => _enteredRoomId = value);
                          },
                          style: theme.textTheme.headline3?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer),
                          textAlign: TextAlign.center,
                          autofocus: true,
                          maxLength: roomIdLength,
                          decoration: const InputDecoration(
                            hintText: 'Enter code',
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Builder(builder: (context) {
                        return ElevatedButton.icon(
                          onPressed: _enteredRoomId.length == roomIdLength
                              ? () => GameRoomModel.of(context)
                                  .joinRoom(_enteredRoomId)
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onPrimary,
                            backgroundColor: theme.colorScheme.primary,
                          ).copyWith(
                            elevation: ButtonStyleButton.allOrNull(0.0),
                          ),
                          icon: const Icon(Icons.navigate_next_rounded),
                          label: const Text('Join'),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
