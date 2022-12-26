import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/ui/ui.dart';

class JoinRoom extends StatelessWidget {
  const JoinRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scaffold(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceTint.withOpacity(0.08),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Insets.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Insets.medium),
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.medium,
                          horizontal: Insets.extraLarge,
                        ),
                        child: TextField(
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                          textAlign: TextAlign.center,
                          autofocus: true,
                          maxLength: 10,
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
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/waitingRoom');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        icon: const Icon(Icons.navigate_next_rounded),
                        label: const Text('Join'),
                      ),
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
