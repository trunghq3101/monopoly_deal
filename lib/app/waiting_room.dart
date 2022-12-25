import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/styles.dart';

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(Insets.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Leave"),
                ),
              ),
              const SizedBox(height: Insets.medium),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(Insets.medium),
                  child: Text(
                    'A8DIZ',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color:
                    Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(Insets.medium),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          WaitingIndicator(),
                          WaitingIndicator(),
                        ],
                      ),
                      const SizedBox(height: Insets.medium),
                      const LinearProgressIndicator(),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  icon: const Icon(Icons.navigate_next_rounded),
                  label: const Text('Start game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingIndicator extends StatelessWidget {
  const WaitingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.small),
      child: Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
      ),
    );
  }
}
